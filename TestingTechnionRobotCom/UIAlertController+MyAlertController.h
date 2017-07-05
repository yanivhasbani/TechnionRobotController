//
//  UIAlertController+MyAlertController.h
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 7/2/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (MyAlertController)

+(instancetype)newWithTitle:(NSString *)title message:(NSString *)message;
@end
