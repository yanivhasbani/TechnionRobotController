//
//  DetailsVC.m
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 7/20/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import "MasterVC.h"
#import "DetailsVC.h"
#import "SatelliteLocation.h"
#import "SatelliteCoordinate.h"

@interface DetailsVC ()

@property (strong, nonatomic) IBOutlet UITextView *dataView;
@property (strong, nonatomic) IBOutlet UILabel *xLabel;
@property (strong, nonatomic) IBOutlet UILabel *yLabel;
@property (strong, nonatomic) IBOutlet UILabel *degreeLabel;

@end

@implementation DetailsVC

#pragma mark -
#pragma mark Get/Set
@synthesize model = _model;

-(SatelliteLocation *)model {
  return _model;
}

-(void)setModel:(SatelliteLocation *)model {
  _model = model;
  [self updateUI:model];
}


- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  [self updateUI:_model];
}

-(void)LocationSelected:(SatelliteLocation *)location {
  _model = location;
  [self updateUI:location];
}

-(void)updateUI:(SatelliteLocation *)location {
  if (location.data) {
    _dataView.text = [NSString stringWithFormat:@"%@",location.data];
  } else {
    _dataView.text = @"No Additional Data";
  }
  _xLabel.text = [NSString stringWithFormat:@"%.02f", location.coordinates.x];
  _yLabel.text = [NSString stringWithFormat:@"%.02f", location.coordinates.y];
  double celsius = (location.coordinates.degree * 180/M_PI);
  _degreeLabel.text = [NSString stringWithFormat:@"%.02f", celsius];
}

- (IBAction)backButtonPressed:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)mapButtonPressed:(id)sender {
  [self.parentViewController.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
