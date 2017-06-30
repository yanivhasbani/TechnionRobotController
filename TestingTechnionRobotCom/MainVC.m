//
//  MainVC.m
//  TestingTechnionRobotCom
//
//  Created by Yaniv on 11/20/16.
//  Copyright © 2016 Yaniv. All rights reserved.
//

#import <CoreFoundation/CoreFoundation.h>

#import "NetworkUtils.h"
#import "UDPManager.h"
#import "MainVC.h"
#import "Coordinates.h"
#import "MovementManager.h"
#import "PlayVC.h"
#include <arpa/inet.h>

@implementation NSString (IPValidation)

- (BOOL)isValidIPAddress
{
  const char *utf8 = [self UTF8String];
  int success;
  
  struct in_addr dst;
  success = inet_pton(AF_INET, utf8, &dst);
  if (success != 1) {
    struct in6_addr dst6;
    success = inet_pton(AF_INET6, utf8, &dst6);
  }
  
  return success == 1;
}

-(BOOL)isValidUDPPort {
  if (self) {
      return self.integerValue >= 0 && self.integerValue <= 100000;
  }
  
  return NO;
}

-(BOOL)isValidRobot {
  return self.integerValue >= 1 && self.integerValue <= 10;
}

@end

@interface MainVC () <UITextFieldDelegate>

@property (nonatomic, assign) NSInteger retryConnection;
@property (strong, nonatomic) IBOutlet UITextField *ipAddress;
@property (strong, nonatomic) IBOutlet UITextField *portNumber;
@property (strong, nonatomic) IBOutlet UITextField *robotNumber;

@end

@implementation MainVC

- (void)viewDidLoad {
  [super viewDidLoad];
  _ipAddress.returnKeyType = UIReturnKeyDone;
  _ipAddress.delegate = self;
  _portNumber.returnKeyType = UIReturnKeyDone;
  _portNumber.delegate = self;
  
  NSString *ipAddr = [[NSUserDefaults standardUserDefaults] objectForKey:@"myIPAddress"];
  if (ipAddr) {
    _ipAddress.text = ipAddr;
  }
  
  NSString *udpPort = [[NSUserDefaults standardUserDefaults] objectForKey:@"myUDPPort"];
  if (ipAddr) {
    _portNumber.text = udpPort;
  }
}

- (IBAction)uiPressed:(UIButton *)sender {
  if (!_ipAddress.text || [_ipAddress.text isEqualToString:@""]||  ![_ipAddress.text isValidIPAddress] ||
      !_portNumber.text || [_portNumber.text isEqualToString:@""] || ![_portNumber.text isValidUDPPort] ||
      !_robotNumber.text || [_robotNumber.text isEqualToString:@""] || [_robotNumber.text isValidRobot]) {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Incorrect UDP connection data"
                                                                             message:@"Please fill in a valid ip address and UDP port"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    //We add buttons to the alert controller by creating UIAlertActions:
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alertController addAction:actionOk];
    [self presentViewController:alertController animated:YES completion:nil];
    return;
  }
  
  [[NSUserDefaults standardUserDefaults] setObject:_ipAddress.text forKey:@"myIPAddress"];
  [[NSUserDefaults standardUserDefaults] setObject:_portNumber.text forKey:@"myUDPPort"];
  [[NSUserDefaults standardUserDefaults] setObject:_robotNumber.text forKey:@"myRoboNumber"];
  
  [self performSegueWithIdentifier:@"PlayVC" sender:sender];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return NO;
}

#pragma mark -
#pragma mark Segues
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender {
  if ([segue.destinationViewController isKindOfClass:[PlayVC class]]) {
    PlayVC *v = (PlayVC *)segue.destinationViewController;
    NSString *buttonText = sender.titleLabel.text;
    if ([buttonText.lowercaseString containsString:@"gyro"]) {
      v.segueData = UITypeGyro;
    } else if ([buttonText.lowercaseString containsString:@"swipe"]) {
      v.segueData = UITypeSwipe;
    }
    
    v.udpPort = _portNumber.text;
    v.ipAddress = _ipAddress.text;
    v.robotNumber = @(_robotNumber.text.integerValue);
  }
}

- (IBAction)resetPressed:(UIButton *)sender {
  sender.hidden = YES;
  
  [self performSegueWithIdentifier:@"PlayVC" sender:nil];
}

@end
