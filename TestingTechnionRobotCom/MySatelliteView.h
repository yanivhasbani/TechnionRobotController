//
//  MySatelliteView.h
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 7/4/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SatelliteCoordinate, SatelliteLocation;
@interface MySatelliteView : UIView

@property (nonatomic, strong) SatelliteLocation *currentLocation;

-(BOOL)needsRotate:(SatelliteCoordinate *)coordinate;
-(BOOL)needsNewCenter:(SatelliteCoordinate *)coordinate;

+(instancetype)newWithLocation:(SatelliteLocation *)location myLocation:(BOOL)myLocation;

-(void)rotate:(double)rads;
-(void)update:(SatelliteLocation *)location;
@end
