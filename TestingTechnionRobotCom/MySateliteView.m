//
//  MySateliteView.m
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 7/4/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import "MyMapView.h"
#import "MySateliteView.h"
#import "UIView+Gestures.h"
#import "SateliteLocation.h"
#import "SateliteCoordinate.h"


@interface MySateliteView()
@property (strong, nonatomic) IBOutlet UIImageView *sateliteImage;
@property (assign, nonatomic) BOOL myLocation;

@end

@implementation MySateliteView

-(void)drawRect:(CGRect)rect {
  [super drawRect:rect];
  _sateliteImage.frame = rect;
  _sateliteImage.clipsToBounds = true;
  
  if (_myLocation) {
    
  }
}

+(instancetype)newWithLocation:(SateliteLocation *)location myLocation:(BOOL)myLocation {
  MySateliteView *v = [[[NSBundle mainBundle] loadNibNamed:@"Satelite" owner:self options:nil] objectAtIndex:0];
  CGPoint center = [MySateliteView createPointFromLocation:location];
  CGRect frame = CGRectMake(center.x - 15, center.y - 15, 30, 30);
  v.bounds = frame;
  v.frame = frame;
  v.tag = location.sateliteNumber.integerValue;
  v.lastLocation = [SateliteCoordinate new];
  v.myLocation = myLocation;
  [v rotate:location.coordinates.degree];
  
  return v;
}

-(void)update:(SateliteLocation *)location {
  if ([self needsNewCenter:location.coordinates]) {
    [UIView animateWithDuration:0.2 animations:^{
      CGPoint center = [MySateliteView createPointFromLocation:location];
      self.frame = CGRectMake(center.x - 15, center.y - 15, 30, 30);
      self.superview.clipsToBounds = YES;
    }];
  }
  if ([self needsRotate:location.coordinates]) {
    [self rotate:location.coordinates.degree];
  }
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

+(CGPoint)createPointFromLocation:(SateliteLocation *)location {
  double newX = xOrigin + xOffset * location.coordinates.x + 15;
  double newY = yOrigin + yOffset * location.coordinates.y + 15;
  
  if (newX > xOrigin + axisSize) {
    newX = xOrigin + axisSize;
  }
  
  if (newX < xOrigin) {
    newX = xOrigin;
  }
  
  if (newY > yOrigin + axisSize) {
    newY = yOrigin + axisSize;
  }
  
  if (newY < yOrigin) {
    newY = yOrigin;
  }
  
  return CGPointMake(newX, newY);
}
@end
