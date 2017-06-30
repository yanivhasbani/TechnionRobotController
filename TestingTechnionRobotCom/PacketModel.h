//
//  PacketModel.h
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 6/30/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MovementConsts.h"

@interface PacketModel : NSObject

+(instancetype)newWithMessage:(NSString *)message robotNumber:(NSNumber *)robotNumber;
-(NSDictionary *)generatePacket;

@end
