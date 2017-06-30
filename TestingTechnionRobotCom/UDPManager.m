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
#import "GCDAsyncUdpSocket.h" // for UDP

#import "UDPManager.h"
#import "NetworkUtils.h"
#import "PacketModel.h"

@interface UDPManager() <GCDAsyncUdpSocketDelegate>

#ifdef NETWORK_LOGS 
+(NSString *)description;
#endif

@end

static NSMutableDictionary *debug_varifiedSentPackets;
static NSMutableDictionary *debug_sentPackets;
static NSMutableDictionary *debug_receivedPackets;

@implementation UDPManager
{
  GCDAsyncUdpSocket *_udpSocket;
  dispatch_queue_t _udpQueue;
  NSNumber *_intervalTime;
  connectionCompletionBlock _completion;
  NSMutableDictionary<NSNumber *, NSString*> *_udpReceivedPackets;
  NSMutableDictionary<NSNumber *, NSString*> *_udpSentPackets;
  NSString *_ipAddress;
  NSString *_udpPort;
}

static UDPManager *sharedManager;
+(instancetype)sharedManager {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedManager = [UDPManager new];
    sharedManager->_udpQueue = dispatch_queue_create([@"udpQueue" cStringUsingEncoding:kCFStringEncodingUTF8], DISPATCH_QUEUE_SERIAL);
    if (sharedManager->_udpQueue) {
      sharedManager->_udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:sharedManager
                                                                delegateQueue:sharedManager->_udpQueue];
      sharedManager->_udpReceivedPackets = [NSMutableDictionary new];
      sharedManager->_udpSentPackets = [NSMutableDictionary new];
      sharedManager->_ipAddress = [NetworkUtils getIPAddress];
#if NETWORK_LOGS
      debug_sentPackets = sharedManager->_udpSentPackets;
      debug_receivedPackets = sharedManager->_udpReceivedPackets;
      debug_varifiedSentPackets  = [NSMutableDictionary new];
#endif
    }
  });
  
  return sharedManager;
}

+(NSString *)description {
#ifdef NETWORK_LOGS
  return [NSString stringWithFormat:@"received:\n%@\nsent:\n%@\nverifiedSent:\n%@\n",
                                     debug_receivedPackets,
                                     debug_sentPackets,
                                     debug_varifiedSentPackets];
#endif
  return @"";
}

#pragma mark -
#pragma mark APIs
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

-(NSString *)getPacket {
  if (![_udpReceivedPackets count]) {
    NSLog(@"No packets in buffer");
    return nil;
  }
  
  NSNumber *key = [[_udpReceivedPackets keysSortedByValueUsingComparator: ^(id obj1, id obj2) {
    
    if ([obj1 integerValue] > [obj2 integerValue]) {
      
      return (NSComparisonResult)NSOrderedDescending;
    }
    if ([obj1 integerValue] < [obj2 integerValue]) {
      
      return (NSComparisonResult)NSOrderedAscending;
    }
    
    return (NSComparisonResult)NSOrderedSame;
  }] firstObject];
  
  NSString *packet = [_udpReceivedPackets[key] copy];
  [_udpReceivedPackets removeObjectForKey:key];
  if(NETWORK_LOGS) {
    NSLog(@"Returning packet = %@ to user", packet);
  }
  return packet;
}

-(void)sendPacket:(NSString *)message {
  if (!message) {
    return;
  }
  
  PacketModel newWithMessage:message robotNumber:<#(NSNumber *)#>
  
  NSNumber *key = @((long)[[NSDate new] timeIntervalSince1970]);
  [_udpSentPackets setObject:message forKey:key];
  NSData *d = [message dataUsingEncoding:NSUTF8StringEncoding];
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([_intervalTime doubleValue] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    if(NETWORK_LOGS) {
      NSLog(@"Sending packet = %@ to user", [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding]);
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
  
  NSString *receiveString= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  if (NETWORK_LOGS) {
    NSLog(@"Socket receiving data Remote Message:%@",receiveString);
  }
  if (receiveString) {
    NSNumber *key = @((long)[[NSDate date] timeIntervalSince1970]);
    [_udpReceivedPackets setObject:receiveString forKey:key];
  }
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([_intervalTime doubleValue] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    NSError *error = nil;
    [_udpSocket receiveOnce:&error];
  });
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
  NSString *message = [_udpSentPackets objectForKey:@(tag)];
  if (NETWORK_LOGS) {
    NSLog(@"Packet %@ was sent to user at %ld",message, tag);
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
      NSLog(@"Error while sending packet to user. tag = %ld", tag);
    }
    if ([_udpSentPackets objectForKey:@(tag)]) {
      //Retry sending due to error
      NSString *message = _udpSentPackets[@(tag)];
      [_udpSentPackets removeObjectForKey:@(tag)];
      [self sendPacket:message];
    }
  }
}


@end
