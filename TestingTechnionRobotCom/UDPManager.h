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
typedef NSDictionary<NSNumber *, NSObject<UDPPacketProtocol> *> UDPDictionary;

@protocol UDPDelegate <NSObject>

-(void)gotPacket:(id<UDPPacketProtocol>)packet;

@end

@class SatelliteLocation;
@interface UDPManager : NSObject

@property (nonatomic, weak) id<UDPDelegate> delegate;

+(void)openConnectionForData:(NSString *)ipAddress
                     udpPort:(NSString *)udpPort
                  resendTime:(NSNumber *)resendTime
                  completion:(connectionCompletionBlock)completion;

+(UDPDictionary *)getReceivedPackets;
+(void)sendPacket:(id<UDPPacketProtocol>)message;

+(instancetype)sharedManager;
@end
