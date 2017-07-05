//
//  MapVC.m
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 6/30/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import "MapVC.h"
#import "UDPManager.h"
#import "MapModel.h"
#import "MyMapView.h"
#import "UIView+Gestures.h"
#import "UIAlertController+MyAlertController.h"

@interface MapVC () <MapModelDelegate, GestureDelegate>

@property (nonatomic, strong) MapModel *map;
@property (strong, nonatomic) IBOutlet MyMapView *mapView;
@property (strong, nonatomic) IBOutlet UILabel *mapState;

@end

@implementation MapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _map = [MapModel new];
    _map.delegate = self;
    _mapState.gestureDelegate = self;
    [_mapState addTapGestures];
    [_map currentLocation];
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
  
  [_mapView loadLocations:locations];
}

#pragma mark -
#pragma mark Gestures
-(void)handleSingleTap:(UIView *)view {
  if ([_mapState.text isEqualToString:@"Current"]) {
    _mapState.text = @"History";
    [_map historyOfLocations];
    return;
  }
  
  _mapState.text = @"Current";
  [_map currentLocation];
}

- (IBAction)backButtonPressed:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end