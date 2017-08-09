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
#import "SatelliteDetailsCell.h"

@interface DetailsVC ()

@property (strong, nonatomic) IBOutlet UITextView *dataView;
@property (strong, nonatomic) IBOutlet UILabel *xLabel;
@property (strong, nonatomic) IBOutlet UILabel *yLabel;
@property (strong, nonatomic) IBOutlet UILabel *degreeLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@interface DetailsVC() <UITableViewDelegate, UITableViewDataSource>

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
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
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

- (IBAction)listButtonPressed:(id)sender {
  [self.tableView reloadData];
  self.tableView.hidden = NO;
}

- (IBAction)mapButtonPressed:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

@synthesize dataModel = _dataModel;

-(NSArray<SatelliteLocation *> *)dataModel {
  return _dataModel;
}

-(void)setDataModel:(NSArray *)dataModel {
  _dataModel = [dataModel copy];
  [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  return [self.dataModel count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  SatelliteDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailsCell"
                                                               forIndexPath:indexPath];
  [cell updateUI:_dataModel[indexPath.row]];
  
  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  SatelliteLocation *sl = self.dataModel[indexPath.row];
  dispatch_async(dispatch_get_main_queue(), ^{
    [UIView animateWithDuration:0.1 animations:^{
      self.model = sl;
      self.tableView.hidden = true;
    }];
  });
}


@end
