//
//  UIView+InflateAnimation.m
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 6/30/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+InflateAnimation.h"

@implementation UIView (InflateAnimation)

-(void)inflateDeflate {
  CABasicAnimation *a = [CABasicAnimation new];
  a.duration = 1.5;
  a.repeatCount = CGFLOAT_MAX;
  a.autoreverses = YES;
  a.fromValue = [NSValue valueWithCGRect:CGRectMake(self.frame.origin.x,
                                                    self.frame.origin.y,
                                                    self.frame.size.width,
                                                    self.frame.size.height)];
  a.toValue = [NSValue valueWithCGRect:CGRectMake(self.center.x - self.frame.size.width,
                                                  self.center.y - self.frame.size.height,
                                                  self.frame.size.width *2,
                                                  self.frame.size.height * 2)];
  [self.layer addAnimation:a forKey:@"frame"];
}

@end
