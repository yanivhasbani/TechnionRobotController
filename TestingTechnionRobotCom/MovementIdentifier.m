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
const float gyroInterval = 0.25f;
const float threshold = 0.9f;

+(instancetype)shared {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedMovementIdentifier = [MovementIdentifier new];
    sharedMovementIdentifier.motionManager = [[CMMotionManager alloc] init];
  });
  
  return sharedMovementIdentifier;
}

+(void)start {
  [sharedMovementIdentifier start];
}

+(void)stop {
  [sharedMovementIdentifier stop];
}

-(void)start {
  //Gyroscope
  if([self.motionManager isGyroAvailable])
  {
    /* Start the gyroscope if it is not active already */
    if([self.motionManager isGyroActive] == NO)
    {
      /* Update us 2 times a second */
      [self.motionManager setGyroUpdateInterval:gyroInterval];
      
      /* Add on a handler block object */
      
      /* Receive the gyroscope data on this block */
      [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData * _Nullable accData, NSError * _Nullable error) {
          [self handleMovement:accData.acceleration.x y:accData.acceleration.y];
        }
      ];
    }
  }
  else
  {
    NSLog(@"Gyroscope not Available!");
  }
}

-(void)stop {
  [self.motionManager stopAccelerometerUpdates];
}

-(void)handleMovement:(double)x y:(double)y {
  double roundX = round(x);
  double roundY = round(y);
  
  if (roundX == 0 && roundY == 0) {
    [self.delegate S];
  }
  
  if (ABS(roundX) > threshold) {
    NSLog(@"X: %f", roundX);
    if (roundX > 0) {
      [self.delegate U];
    } else {
      [self.delegate D];
    }
    
    [self.motionManager stopAccelerometerUpdates];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      [self start];
    });
    return;
  }
  
  
  if (ABS(roundY) > threshold) {
    NSLog(@"Y: %f", roundY);
    if (roundY > 0) {
      [self.delegate L];
    } else {
      [self.delegate R];
    }
    
    [self.motionManager stopAccelerometerUpdates];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      [self start];
    });
  }
}

@end
