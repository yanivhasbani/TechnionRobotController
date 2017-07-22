//
//  DetailsVC.h
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 7/20/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SatelliteLocation;
@interface DetailsVC : UIViewController<LocationSelectionDelegate>

@property (nonatomic, strong) SatelliteLocation *model;

@end
