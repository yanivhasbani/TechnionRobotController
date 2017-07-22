//
//  PacketModel.m
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 6/30/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import "NSDictionary+Utils.h"
#import "SendPacketModel.h"
#import "NetworkUtils.h"
#import "ParseJSONProtocol.h"


@interface SendPacketModel() <ParseJSONProtocol>

@property (nonatomic, strong) NSNumber *sentFreq;
@property (nonatomic, strong) NSString *message;

@end

#ifdef NETWORK_LOGS
static NSHashTable *debug_packetGenerated;
#endif

@implementation SendPacketModel

-(NSDictionary *)json {
  return @{
           @"ipAddress" : [NetworkUtils getIPAddress] ? : [NSNull null],
           @"message" : _message ? : [NSNull null]
           };
}

+(BOOL)validateJSON:(NSDictionary *)dictionary {
  return NO;
}

+(instancetype)newWithJson:(NSDictionary *)dictionary {
  return nil;
}

-(NSString *)description {
  return [self debugDescription];
}

-(NSString *)debugDescription {
  return [[self generatePacket] json];
}


-(NSDictionary *)generatePacket {
#ifdef NETWORK_LOGS
  [debug_packetGenerated addObject:self];
#endif
  
  return @{
           @"ipAddress" : [NetworkUtils getIPAddress] ? : [NSNull null],
           @"message" : _message ? : [NSNull null]
           };
}

+(instancetype)newWithMessage:(NSString *)message {
#ifdef NETWORK_LOGS
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    debug_packetGenerated = [NSHashTable new];
  });
#endif
  
  SendPacketModel *p = [SendPacketModel new];
  
  p.message = message;
  
  return p;
}

@end
