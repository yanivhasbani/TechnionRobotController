//
//  SatelliteDetailsCell.m
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 7/22/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import "SatelliteDetailsCell.h"
#import "SatelliteLocation.h"

@interface SatelliteDetailsCell()

@property (strong, nonatomic) IBOutlet UILabel *satelliteLabel;

@end

@implementation SatelliteDetailsCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

-(void)updateUI:(SatelliteLocation *)location {
  self.satelliteLabel.text = location.satelliteNumber.stringValue;
}

@end
