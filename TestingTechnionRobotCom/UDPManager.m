//
//  UDPManager.m
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 6/13/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#include <CoreFoundation/CoreFoundation.h>
#include <sys/socket.h>
#include <netdb.h>

#import <objc/runtime.h>

#import "GCDAsyncUdpSocket.h"
#import "UDPManager.h"
#import "NetworkUtils.h"
#import "SateliteLocation.h"
#import "NSDictionary+Utils.h"
#import "ReceivedPacketModel.h"

typedef NSMutableDictionary<NSNumber *, NSObject<UDPPacketProtocol> *> UDPDictionary;

@interface UDPManager() <GCDAsyncUdpSocketDelegate>

@property (nonatomic, strong) GCDAsyncUdpSocket *udpSocket;
@property (nonatomic, strong) NSNumber *intervalTime;
@property (nonatomic, strong) UDPDictionary *sentPackets;
@property (nonatomic, strong) UDPDictionary *receivedPackets;
@property (nonatomic, strong) NSString *ipAddress;
@property (nonatomic, strong) dispatch_queue_t udpQueue;
@property (nonatomic, strong) connectionCompletionBlock completion;
@property (nonatomic, strong) NSString *udpPort;

#ifdef NETWORK_LOGS
+(NSString *)debugDescription;
#endif

@end

static UDPDictionary *debug_varifiedSentPackets;
static UDPDictionary *debug_sentPackets;
static UDPDictionary *debug_receivedPackets;

@implementation UDPManager

static UDPManager *sharedManager;
+(instancetype)sharedManager {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedManager = [UDPManager new];
    sharedManager.udpQueue = dispatch_queue_create([@"udpQueue" cStringUsingEncoding:kCFStringEncodingUTF8], DISPATCH_QUEUE_SERIAL);
    if (sharedManager.udpQueue) {
      sharedManager.udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:sharedManager
                                                                delegateQueue:sharedManager->_udpQueue];
      sharedManager.receivedPackets = [NSMutableDictionary new];
      sharedManager.sentPackets = [NSMutableDictionary new];
      sharedManager.ipAddress = [NetworkUtils getIPAddress];
#ifdef NETWORK_LOGS
      debug_sentPackets = sharedManager.sentPackets;
      debug_receivedPackets = sharedManager.receivedPackets;
      debug_varifiedSentPackets  = [NSMutableDictionary new];
#endif
    }
  });
  
  return sharedManager;
}

+(NSString *)debugDescription {
#ifdef NETWORK_LOGS
  return [NSString stringWithFormat:@"RECEIVED:\n%@\nSENT:\n%@\nVERIFIEDSENT:\n%@\nIPADDRESS:%@\nPORT:%@\nRESENDINGTIME:%@",
          debug_receivedPackets,
          debug_sentPackets,
          debug_varifiedSentPackets,
          sharedManager.ipAddress,
          sharedManager.udpPort,
          sharedManager.intervalTime];
#endif
  return @"";
}

#pragma mark -
#pragma mark APIs

+(void)openConnectionForData:(NSString *)ipAddress
                     udpPort:(NSString *)udpPort
                intervalTime:(NSNumber *)intervalTime
                  completion:(connectionCompletionBlock)completion {
  [[self sharedManager] openConnectionForData:ipAddress
                                      udpPort:udpPort
                                 intervalTime:intervalTime
                                   completion:completion];
}


-(void)openConnectionForData:(NSString *)ipAddress
                     udpPort:(NSString *)udpPort
                intervalTime:(NSNumber *)intervalTime
                  completion:(connectionCompletionBlock)completion {
  if (_udpSocket != nil){
    NSError *error = nil;
    if (![_udpSocket bindToPort:[udpPort integerValue] error:&error])
    {
      NSLog(@"Error binding: %@", error);
      completion(error);
      return;
    }
    
    if (![_udpSocket receiveOnce:&error])
    {
      NSLog(@"Error receiving: %@", error);
      completion(error);
      return;
    }
  } else {
    NSError *err = [NSError errorWithDomain:@"UDPRecivingError" code:-100 userInfo:@{
                                                                                     @"error" : @"No udpSocket initiated"
                                                                                     }];
    completion(err);
  }
  
  _intervalTime = intervalTime;
  _udpPort = udpPort;
  _ipAddress = ipAddress;
  completion(nil);
}

+(NSArray<UDPPacketProtocol> *)getPackets {
  return [[self sharedManager] getPackets];
}

-(NSArray<UDPPacketProtocol> *)getPackets {
  return [_receivedPackets copy];
}

+(void)sendPacket:(id<UDPPacketProtocol>)message {
  [[self sharedManager] sendPacket:message];
}

-(void)sendPacket:(id<UDPPacketProtocol>)message {
  if (!message) {
    return;
  }
  
  NSNumber *key = @((long)[[NSDate new] timeIntervalSince1970]);
  [_sentPackets setObject:message forKey:key];
  NSData *d = [[message debugDescription] dataUsingEncoding:NSUTF8StringEncoding];
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([_intervalTime doubleValue] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    if(NETWORK_LOGS) {
      NSLog(@"SENDING: <%@, at:%@>", [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding], key);
    }
    [_udpSocket sendData:d
                  toHost:_ipAddress
                    port:[_udpPort integerValue]
             withTimeout:[_intervalTime doubleValue]
                     tag:[key intValue]];
  });
}

#pragma mark -
#pragma mark GCDAsyncUdpSocketDelegate

-(void)udpSocket:(GCDAsyncUdpSocket *)sock
  didReceiveData:(NSData *)data
     fromAddress:(NSData *)address
withFilterContext:(id)filterContext{
  
  NSError *e;
  NSDictionary *receiveMessage = [NSJSONSerialization JSONObjectWithData:data options:0 error:&e];
  if (e || !receiveMessage) {
    NSLog(@"Error: receiving data Remote Message:%@", [[NSString alloc] initWithData:data encoding:kCFStringEncodingUTF8]);
    return;
  }
  if (NETWORK_LOGS) {
    NSLog(@"Socket receiving data Remote Message:%@",receiveMessage);
  }
  if (receiveMessage) {
    ReceivedPacketModel *p = [ReceivedPacketModel newWithJson:receiveMessage];
    if (p) {
      NSNumber *key = @((long)[[NSDate date] timeIntervalSince1970]);
      [_receivedPackets setObject:p forKey:key];
    } else {
      ReceivedPacketModel *d = [ReceivedPacketModel newWithJson:@{
                          @"myLocation" : @{
                            @"sateliteNumber" : @(0),
                            @"coordinates" : @{
                              @"x" : @(0),
                              @"y" : @(0),
                              @"degree" : @(0)
                            }
                          }
                          }];
      NSNumber *key = @((long)[[NSDate date] timeIntervalSince1970]);
      [_receivedPackets setObject:d forKey:key];

    }
  }
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([_intervalTime doubleValue] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    NSError *error = nil;
    [_udpSocket receiveOnce:&error];
  });
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
  id<UDPPacketProtocol> message = [_sentPackets objectForKey:@(tag)];
  if (NETWORK_LOGS) {
    NSLog(@"SENT:<%@, at:%ld>",[message description], tag);
  }
  if (message) {
    [debug_varifiedSentPackets setObject:message forKey:@(tag)];
  } else {
    //Weird.. packet was sent but does not show on our sent packet array..
  }
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag
       dueToError:(NSError *)error {
  if (error) {
    if (NETWORK_LOGS) {
      NSLog(@"Error sending. tag = %ld", tag);
    }
    if ([_sentPackets objectForKey:@(tag)]) {
      //Retry sending due to error
      id<UDPPacketProtocol> message = _sentPackets[@(tag)];
      [_sentPackets removeObjectForKey:@(tag)];
      [self sendPacket:message];
    }
  }
}


@end
