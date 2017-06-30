//
//  UIView+ShakeProtocol.m
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 6/24/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+ShakeProtocol.h"



@implementation UIView (ShakeProtocol)

-(void)shakeLeftArrow {
  float imgWidth = 100;
  CABasicAnimation *a = [CABasicAnimation new];
  a.duration = 0.7;
  a.repeatCount = CGFLOAT_MAX;
  a.autoreverses = YES;
  a.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x - imgWidth - 200, self.center.y/2)];
  a.toValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x + imgWidth - 100, self.center.y/2)];
  [self.layer addAnimation:a forKey:@"position"];
}

-(void)shakeLeftArrowFromCenter {
  float imgWidth = 100;
  CABasicAnimation *a = [CABasicAnimation new];
  a.duration = 0.7;
  a.repeatCount = CGFLOAT_MAX;
  a.autoreverses = YES;
  a.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x - imgWidth - 200, self.center.y/2)];
  a.toValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x + imgWidth - 100, self.center.y/2)];
  [self.layer addAnimation:a forKey:@"position"];
}

-(void)shakeRightArrow {
  float imgWidth = 100;
  CABasicAnimation *a = [CABasicAnimation new];
  a.duration = 0.4;
  a.repeatCount = CGFLOAT_MAX;
  a.autoreverses = YES;
  a.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x - imgWidth, self.center.y/2)];
  a.toValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x + imgWidth, self.center.y/2)];
  [self.layer addAnimation:a forKey:@"position"];
}

-(void)shakeRightArrowFromCenter {
  float imgWidth = 100;
  CABasicAnimation *a = [CABasicAnimation new];
  a.duration = 0.4;
  a.repeatCount = CGFLOAT_MAX;
  a.autoreverses = YES;
  a.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x - imgWidth + 100, self.center.y/2)];
  a.toValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x + imgWidth + 200, self.center.y/2)];
  [self.layer addAnimation:a forKey:@"position"];
}

-(void)shakeUpArrow {
  CABasicAnimation *a = [CABasicAnimation new];
  a.duration = 0.3;
  a.repeatCount = CGFLOAT_MAX;
  a.autoreverses = YES;
  a.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y -50)];
  a.toValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y - 170)];
  [self.layer addAnimation:a forKey:@"position"];
}

-(void)shakeDownArrow {
  CABasicAnimation *a = [CABasicAnimation new];
  a.duration = 0.3;
  a.repeatCount = CGFLOAT_MAX;
  a.autoreverses = YES;
  a.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y - 100)];
  a.toValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y + 50)];
  [self.layer addAnimation:a forKey:@"position"];
}

-(void)shakeDownArrowFromCenter {
  CABasicAnimation *a = [CABasicAnimation new];
  a.duration = 0.3;
  a.repeatCount = CGFLOAT_MAX;
  a.autoreverses = YES;
  a.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)];
  a.toValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y + 150)];
  [self.layer addAnimation:a forKey:@"position"];
}



@end
