//
//  PlayVC.h
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 6/24/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayVC : UIViewController

typedef NS_ENUM(NSUInteger, UIType) {
  UITypeGyroNone = 0,
  UITypeGyro = 1,
  UITypeJoystick = 2
};

@property (nonatomic, assign) UIType segueData;
@property (nonatomic, strong) NSString *ipAddress;
@property (nonatomic, strong) NSString *udpPort;
@property (nonatomic, strong) NSNumber *sateliteNumber;

@end
