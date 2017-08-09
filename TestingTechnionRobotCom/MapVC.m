
//
//  MapVC.m
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 6/30/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import "MapVC.h"
#import "MapModel.h"
#import "DetailsVC.h"
#import "MyMapView.h"
#import "UDPManager.h"
#import "UIView+Gestures.h"
#import "UIAlertController+MyAlertController.h"

@interface MapVC () <MapModelDelegate, GestureDelegate>

@property (nonatomic, strong) MapModel *mapModel;
@property (strong, nonatomic) IBOutlet MyMapView *mapView;
@property (strong, nonatomic) IBOutlet UILabel *mapState;
@property (strong, nonatomic) IBOutlet UIButton *logButton;

@end

@implementation MapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _mapModel = [MapModel new];
    _mapModel.delegate = self;
    _mapState.gestureDelegate = self;
  
    [_mapState addTapGestures];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      [_mapModel currentLocation];
    });
}


#pragma mark -
#pragma mark MapDelegate
-(void)mapModelLoadedData:(MapModel *)locations {
  if (!locations) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      id v = [UIAlertController newWithTitle:@"No location data" message:@"No location data received from base"];
      [self presentViewController:v animated:YES completion:nil];
    });
    return;
  }
  _logButton.hidden = NO;
  [_mapView loadLocations:locations];
}

#pragma mark -
#pragma mark Gestures
-(void)handleSingleTap:(UIView *)view {
  if ([_mapState.text isEqualToString:@"Current"]) {
    _mapState.text = @"History";
    [_mapModel historyOfLocations];
    return;
  }
  
  _mapState.text = @"Current";
  [_mapModel currentLocation];
}

#pragma mark -
#pragma mark backButton
- (IBAction)backButtonPressed:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark LogButton
- (IBAction)logButtonPressed:(id)sender {
  NSArray *satellitelocations = [_mapView getAllSatelliteLocations];
  [self performSegueWithIdentifier:@"LogVC" sender:satellitelocations];
}


#pragma mark -
#pragma mark Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSArray<SatelliteLocation *> *)model {
  if ([segue.destinationViewController isKindOfClass:[DetailsVC class]]) {
    DetailsVC *vc = (DetailsVC *)segue.destinationViewController;
    vc.dataModel = model;
    vc.model = [model firstObject];
  }
}


@end
