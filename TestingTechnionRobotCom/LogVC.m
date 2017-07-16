//
//  LogVC.m
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 7/10/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import "LogVC.h"
#import "LogCell.h"

@interface LogVC () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LogVC

- (void)viewDidLoad {
  [super viewDidLoad];
  _tableView.delegate = self;
  _tableView.dataSource = self;
  
  [_tableView reloadData];
  // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_data count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  LogCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LogCell"];
  cell.textView.text = _data[indexPath.row];
  
  return cell;
}

- (IBAction)backBtnPressed:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
  return 100;
}

@end
