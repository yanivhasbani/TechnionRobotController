//
//  PacketModel.m
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 6/30/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import "PacketModel.h"
#import "NetworkUtils.h"

@interface PacketModel()

@property (nonatomic, strong) NSNumber *robotNumber;
@property (nonatomic, strong) NSString *message;

@end

@implementation PacketModel


-(NSDictionary *)generatePacket {
  return @{
           @"robotNumber" : _robotNumber ? : [NSNull null],
           @"ipAddress" : [NetworkUtils getIPAddress] ? : [NSNull null],
           @"message" : _message ? : [NSNull null]
           };
}

+(instancetype)newWithMessage:(NSString *)message robotNumber:(NSNumber *)robotNumber {
  PacketModel *p = [PacketModel new];
  
  p.message = message;
  p.robotNumber = robotNumber;
  
  return p;
}

@end
