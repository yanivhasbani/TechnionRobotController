//
//  SatelliteDetailsCell.h
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 7/22/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SatelliteLocation;
@interface SatelliteDetailsCell : UITableViewCell

-(void)updateUI:(SatelliteLocation *)location;

@end
