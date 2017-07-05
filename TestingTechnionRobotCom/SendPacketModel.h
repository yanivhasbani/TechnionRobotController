//
//  SendPacketModel.h
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 6/30/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MovementConsts.h"
#import "udpPacketProtocol.h"

@interface SendPacketModel : NSObject<UDPPacketProtocol>

+(instancetype)newWithMessage:(NSString *)message sateliteNumber:(NSNumber *)sateliteNumber;

-(NSDictionary *)generatePacket;

@end
