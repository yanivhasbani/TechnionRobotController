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


@interface SendPacketModel()

@property (nonatomic, strong) NSNumber *sateliteNumber;
@property (nonatomic, strong) NSString *message;

@end

#ifdef NETWORK_LOGS
static NSHashTable *debug_packetGenerated;
#endif

@implementation SendPacketModel

-(NSString *)description {
  return [SendPacketModel debugDescription];
}

-(NSString *)debugDescription {
  return [[self generatePacket] json];
}


-(NSDictionary *)generatePacket {
  [debug_packetGenerated addObject:self];
  
  return @{
           @"sateliteNumber" : _sateliteNumber ? : [NSNull null],
           @"ipAddress" : [NetworkUtils getIPAddress] ? : [NSNull null],
           @"message" : _message ? : [NSNull null]
           };
}

+(instancetype)newWithMessage:(NSString *)message sateliteNumber:(NSNumber *)sateliteNumber {
#ifdef NETWORK_LOGS
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    debug_packetGenerated = [NSHashTable new];
  });
#endif
  
  SendPacketModel *p = [SendPacketModel new];
  
  p.message = message;
  p.sateliteNumber = sateliteNumber;
  
  return p;
}

@end
