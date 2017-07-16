//
//  MyMapView.h
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 7/3/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MapModel;
@interface MyMapView : UIView

-(void)reset;
-(void)loadLocations:(MapModel *)locations;

@end
