//
//  DetailsVC.h
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 7/20/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SatelliteLocation;
@protocol LocationSelectionDelegate <NSObject>

-(void)LocationSelected:(SatelliteLocation *)location;

@end

@class SatelliteLocation;
@interface DetailsVC : UIViewController<LocationSelectionDelegate>

@property (nonatomic, strong) NSArray<SatelliteLocation *> *dataModel;
@property (nonatomic, strong) SatelliteLocation *model;

@end
