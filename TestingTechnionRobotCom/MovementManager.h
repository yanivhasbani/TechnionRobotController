//
//  MovementManager.h
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 6/24/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MovementConsts.h"

@protocol MovementDelegate <NSObject>

-(void)movementOccured:(SatelliteCommand)cmd;

@end

@interface MovementManager : NSObject

@property (nonatomic, weak) id<MovementDelegate> delegate;

+(instancetype)shared;

-(void)start;
-(void)stop;

@end
