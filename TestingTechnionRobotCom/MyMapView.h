//
//  MyMapView.h
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 7/3/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapModel.h"


@interface MyMapView : UIView

-(void)loadLocations:(MapModel *)locations;

@end
