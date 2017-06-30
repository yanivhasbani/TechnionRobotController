//
//  Coordinates.m
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 6/20/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#include <CoreMotion/CoreMotion.h>

#import "Coordinates.h"

@interface Coordinates()

@property (nonatomic, strong) CMMotionManager *motionManager;

@end

@implementation Coordinates

static Coordinates* sharedCoordinates;
const float gyroInterval = 0.25f;
const float bound = 0.9f;

+(instancetype)shared {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedCoordinates = [Coordinates new];
    sharedCoordinates.motionManager = [[CMMotionManager alloc] init];
  });
  
  return sharedCoordinates;
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
        double x = round(accData.acceleration.x);
        double y = round(accData.acceleration.y);
        
        if (x == 0 && y == 0) {
          [self.delegate S];
        }
        
        if (ABS(x) > bound) {
          NSLog(@"X: %f", x);
          if (x > 0) {
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
        
                
        if (ABS(y) > bound) {
          NSLog(@"Y: %f", y);
          if (y > 0) {
            [self.delegate L];
          } else {
            [self.delegate R];
          }
          
          [self.motionManager stopAccelerometerUpdates];
          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self start];
          });
        }
       }];
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

@end
