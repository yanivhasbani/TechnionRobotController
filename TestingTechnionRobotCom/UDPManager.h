//
//  UDPManager.h
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 6/13/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "udpPacketProtocol.h"

typedef void(^connectionCompletionBlock)(NSError *err);

@class SateliteLocation;
@interface UDPManager : NSObject

+(void)openConnectionForData:(NSString *)ipAddress
                     udpPort:(NSString *)udpPort
                intervalTime:(NSNumber *)intervalTime
                  completion:(connectionCompletionBlock)completion;

+(NSArray<UDPPacketProtocol> *)getPackets;
+(void)sendPacket:(id<UDPPacketProtocol>)message;
@end
