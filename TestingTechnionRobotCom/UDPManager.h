//
//  UDPManager.h
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 6/13/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^connectionCompletionBlock)(NSError *err);

@interface UDPManager : NSObject

+(instancetype)sharedManager;

-(void)openConnectionForData:(NSString *)ipAddress
                     udpPort:(NSString *)udpPort
                intervalTime:(NSNumber *)intervalTime
                  completion:(connectionCompletionBlock)completion;

-(NSString *)getPacket;
-(void)sendPacket:(NSString *)message;
@end
