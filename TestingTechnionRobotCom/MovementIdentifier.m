//
//  Coordinates.m
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 6/20/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#include <CoreMotion/CoreMotion.h>

#import "MovementIdentifier.h"

@interface MovementIdentifier()

@property (nonatomic, strong) CMMotionManager *motionManager;

@end

@implementation MovementIdentifier

static MovementIdentifier* sharedMovementIdentifier;
const float accelerationInterval = 0.25f;
const float threshold = 0.9f;

-(instancetype)init {
  self = [super init];
  
  _motionManager = [[CMMotionManager alloc] init];
  
  return self;
}

-(void)start {
  if([self.motionManager isAccelerometerAvailable])
  {
    /* Start the accelerometer if it is not active already */
    if([self.motionManager isAccelerometerActive] == NO)
    {
      /* Update us 2 times a second */
      [self.motionManager setAccelerometerUpdateInterval:accelerationInterval];
      
      /* Add on a handler block object */
      
      /* Receive the accelerometer data on this block */
      __weak MovementIdentifier *weakSelf = self;
      [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData * _Nullable accData, NSError * _Nullable error) {
          [weakSelf handleMovement:accData.acceleration.x y:accData.acceleration.y];
        }
      ];
    }
  }
  else
  {
    NSLog(@"Accelerometer not Available!");
  }
}

-(void)stop {
  [_motionManager stopAccelerometerUpdates];
  _motionManager = nil;
}

-(void)handleMovement:(double)x y:(double)y {
  double roundX = round(x);
  double roundY = round(y);
  
  if (roundX == 0 && roundY == 0) {
    [self.delegate S];
  }
  
  if (ABS(roundX) > threshold) {
    if (roundX > 0) {
      [self.delegate U];
    } else {
      [self.delegate D];
    }
    
    [_motionManager stopAccelerometerUpdates];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      [self start];
    });
    return;
  }
  
  
  if (ABS(roundY) > threshold) {
    if (roundY > 0) {
      [self.delegate L];
    } else {
      [self.delegate R];
    }
    
    [_motionManager stopAccelerometerUpdates];
    __weak MovementIdentifier *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      [weakSelf start];
    });
  }
}

@end
