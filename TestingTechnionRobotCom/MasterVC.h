//
//  MasterVC.h
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 7/22/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SatelliteLocation;
@protocol LocationSelectionDelegate <NSObject>

-(void)LocationSelected:(SatelliteLocation *)location;

@end

@protocol DismissMasterDelegate <NSObject>

-(void)toggle;

@end

@interface MasterVC : UITableViewController <UISplitViewControllerDelegate>

@property (nonatomic, weak) id<LocationSelectionDelegate> locationDelegate;
@property (nonatomic, weak) id<DismissMasterDelegate> dismissDelegate;
@property (nonatomic, strong) NSArray<SatelliteLocation *> *dataModel;

@end
