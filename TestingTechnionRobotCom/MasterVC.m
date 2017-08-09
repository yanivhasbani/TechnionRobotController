////
////  MasterVC.m
////  TestingTechnionRobotCom
////
////  Created by Yaniv Hasbani on 7/22/17.
////  Copyright © 2017 Yaniv. All rights reserved.
////
//
//#import "MasterVC.h"
//#import "SatelliteLocation.h"
//
//
//@interface MasterVC ()
//
//@end
//
//@implementation MasterVC
//
//static BOOL collapseDetailViewController;
//
//-(BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(nonnull UIViewController *)secondaryViewController ontoPrimaryViewController:(nonnull UIViewController *)primaryViewController {
//  UINavigationController *nvc  = (UINavigationController *)primaryViewController;
//  UINavigationController *nvc2 = (UINavigationController *)secondaryViewController;
//  nvc.viewControllers = [[[NSMutableArray arrayWithArray:nvc.viewControllers] arrayByAddingObjectsFromArray:nvc2.viewControllers] copy];
//  
//  return collapseDetailViewController;
//}
//
//#pragma mark -
//#pragma mark Set/Get
//
//
//#pragma mark -
//#pragma mark LifeCycle
//- (void)viewDidLoad {
//  [super viewDidLoad];
//  
//  collapseDetailViewController = YES;
//  // Uncomment the following line to preserve selection between presentations.
//  // self.clearsSelectionOnViewWillAppear = NO;
//  
//  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//}
//
//- (void)didReceiveMemoryWarning {
//  [super didReceiveMemoryWarning];
//  // Dispose of any resources that can be recreated.
//}
//
//#pragma mark - Table view data source
//
//
///*
// // Override to support conditional editing of the table view.
// - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
// // Return NO if you do not want the specified item to be editable.
// return YES;
// }
// */
//
///*
// // Override to support editing the table view.
// - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
// if (editingStyle == UITableViewCellEditingStyleDelete) {
// // Delete the row from the data source
// [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
// } else if (editingStyle == UITableViewCellEditingStyleInsert) {
// // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
// }
// }
// */
//
///*
// // Override to support rearranging the table view.
// - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
// }
// */
//
///*
// // Override to support conditional rearranging of the table view.
// - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
// // Return NO if you do not want the item to be re-orderable.
// return YES;
// }
// */
//
///*
// #pragma mark - Navigation
// 
// // In a storyboard-based application, you will often want to do a little preparation before navigation
// - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
// // Get the new view controller using [segue destinationViewController].
// // Pass the selected object to the new view controller.
// }
// */
//
//@end
