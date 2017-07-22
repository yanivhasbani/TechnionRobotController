//
//  SplitVC.m
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 7/22/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import "SplitVC.h"
#import "MasterVC.h"
#import "DetailsVC.h"

@interface SplitVC () <DismissMasterDelegate>

@end

@implementation SplitVC

-(void)toggle {
  [[UIApplication sharedApplication] sendAction:self.displayModeButtonItem.action to:self.displayModeButtonItem.target from:nil forEvent:nil];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.preferredDisplayMode = UISplitViewControllerDisplayModePrimaryOverlay;

  MasterVC *mvc;
  DetailsVC *dvc;
  for (UIViewController *vc in self.viewControllers) {
    //Make it transperent
    UINavigationController *nvc = (UINavigationController *)vc;
    [nvc.navigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    nvc.navigationBar.shadowImage = [UIImage new];
    nvc.navigationBar.translucent = YES;
    
    //Connect data models
    if ([[vc.childViewControllers firstObject] isKindOfClass:[MasterVC class]]) {
      mvc = (MasterVC *)[vc.childViewControllers firstObject];
      mvc.dataModel = [_model copy];
      mvc.dismissDelegate = self;
    }
    
    //Connect data models + delegates
    if ([[vc.childViewControllers firstObject] isKindOfClass:[DetailsVC class]]) {
      dvc = (DetailsVC *)[vc.childViewControllers firstObject];
      mvc.locationDelegate = dvc;
      dvc.model = [mvc.dataModel firstObject];
    }
    
  }
  
  self.delegate = mvc;
  
  if ([self.viewControllers.lastObject isKindOfClass:[UINavigationController class]]) {
    UINavigationController *nvc = self.viewControllers.lastObject;
    nvc.topViewController.navigationItem.leftBarButtonItem = self.displayModeButtonItem;
  }
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
