//
//  MySateliteView.m
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 7/4/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import "MySateliteView.h"

@implementation MySateliteView

+(instancetype)newWithFrame:(CGRect)frame {
  MySateliteView *v = [[[NSBundle mainBundle] loadNibNamed:@"Satelite" owner:self options:nil] objectAtIndex:0];
  v.frame = frame;
  
  return v;
}

-(void)rotate:(double)rads {
  CGAffineTransform transform = CGAffineTransformRotate(CGAffineTransformIdentity, rads);
  self.transform = transform;
}
@end
