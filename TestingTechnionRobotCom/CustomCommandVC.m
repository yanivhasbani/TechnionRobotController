//
//  CustomCommandVC.m
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 6/27/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import "CustomCommandVC.h"
#import "CustomCommandCell.h"
#import "CHCSVParser.h"
#import "UIAlertController+MyAlertController.h"

@interface CustomCommandVC () <UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UITextField *numberOfCommandsField;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation CustomCommandVC

static NSString * const reuseIdentifier = @"CustomActionCell";

static double _numberOfCommands;

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Uncomment the following line to preserve selection between presentations
  // self.clearsSelectionOnViewWillAppear = NO;
  
  if (_numberOfCommands == 0) {
    _numberOfCommandsField.delegate = self;
    _numberOfCommandsField.returnKeyType = UIReturnKeyDone;
  } else {
    _numberOfCommandsField.hidden = YES;
    self.collectionView.hidden = NO;
    [self.collectionView reloadData];
  }
  
  self.collectionView.delegate = self;
  self.collectionView.dataSource = self;
  
  // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  
  return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  
  return _numberOfCommands;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  CustomCommandCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
  
  [cell configureCell:[NSString stringWithFormat:@"Cmd-%ld", (long)indexPath.row]];
  
  return cell;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];
  if (textField.text.integerValue < 0) {
    UIAlertController *a = [UIAlertController newWithTitle:@"Incorrect Number of commands"
                                                   message:@"Please specify number bigger than 0"];
    
    [self presentViewController:a animated:YES completion:nil];
    return NO;
  }
  
  _numberOfCommands = _numberOfCommandsField.text.integerValue;
  
  self.collectionView.hidden = NO;
  self.numberOfCommandsField.hidden = YES;
  _numberOfCommands = self.numberOfCommandsField.text.integerValue;
  [self.collectionView reloadData];
  return YES;
  
}

- (IBAction)backPressed:(UIButton *)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  CustomCommandCell *c = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
  if (c) {
    [c sendCmdToServer:_sateliteNumber];
  }
}

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */

@end
