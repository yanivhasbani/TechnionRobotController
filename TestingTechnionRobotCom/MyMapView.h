//
//  MyMapView.h
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 7/3/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MapModel, SatelliteLocation;

@interface MyMapView : UIView

-(void)loadLocations:(MapModel *)locations;
-(NSArray *)getAllSatelliteLocations;

@end

extern int axisSize;

extern double xOrigin;
extern double yOrigin;
