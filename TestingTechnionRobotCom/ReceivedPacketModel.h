//
//  ReceivedPacketModel.h
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 7/2/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "udpPacketProtocol.h"

@class SatelliteLocation;
@interface ReceivedPacketModel : NSObject<UDPPacketProtocol>

+(instancetype)newWithJson:(NSDictionary *)dictionary;
//Create packet
-(NSDictionary *)generatePacket;
-(NSNumber *)id;

@end
