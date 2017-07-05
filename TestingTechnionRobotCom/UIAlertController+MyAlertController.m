//
//  UIAlertController+MyAlertController.m
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 7/2/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import "UIAlertController+MyAlertController.h"

@implementation UIAlertController (MyAlertController)

+(instancetype)newWithTitle:(NSString *)title message:(NSString *)message {
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                           message:message
                                                                    preferredStyle:UIAlertControllerStyleAlert];
  //We add buttons to the alert controller by creating UIAlertActions:
  UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
  [alertController addAction:actionOk];
  
  return alertController;
}

@end
