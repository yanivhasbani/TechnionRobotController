//
//  MySateliteView.m
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 7/4/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import "MySateliteView.h"
#import "UIView+Gestures.h"
#import "SateliteCoordinate.h"

@interface MySateliteView()

@end

@implementation MySateliteView

+(instancetype)newWithFrame:(CGRect)frame {
    MySateliteView *v = [[[NSBundle mainBundle] loadNibNamed:@"Satelite" owner:self options:nil] objectAtIndex:0];
    v.frame = frame;
    v.lastLocation = [SateliteCoordinate new];
    
    return v;
}

-(void)rotate:(double)rads {
  CGAffineTransform transform;
  if (!rads) {
    transform = CGAffineTransformIdentity;
  } else {
    transform = CGAffineTransformRotate(CGAffineTransformIdentity, rads);
  }
  
  [UIView animateWithDuration:0.2 animations:^{
    self.transform = transform;
  }];
}

-(BOOL)needsRotate:(SateliteCoordinate *)coordinate {
  if (coordinate.degree == _lastLocation.degree) {
    return NO;
  }
  
  _lastLocation.degree = coordinate.degree;
  return YES;
}
-(BOOL)needsNewCenter:(SateliteCoordinate *)coordinate {
  if (coordinate.x == _lastLocation.x && coordinate.y == _lastLocation.y) {
    return NO;
  }
  
  _lastLocation.x = coordinate.x;
  _lastLocation.y = coordinate.y;
  return YES;
}
@end
