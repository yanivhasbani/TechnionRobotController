//
//  MySatelliteView.m
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 7/4/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import "MyMapView.h"
#import "MySatelliteView.h"
#import "UIView+Gestures.h"
#import "SatelliteLocation.h"
#import "SatelliteCoordinate.h"


@interface MySatelliteView()

@property (strong, nonatomic) IBOutlet UIImageView *satelliteImage;
@property (assign, nonatomic) BOOL myLocation;

@end

@implementation MySatelliteView

-(void)drawRect:(CGRect)rect {
  [super drawRect:rect];
  _satelliteImage.frame = rect;
  _satelliteImage.clipsToBounds = true;
  
  if (_myLocation) {
    
  }
}

+(instancetype)newWithLocation:(SatelliteLocation *)location myLocation:(BOOL)myLocation {
  MySatelliteView *v = [[[NSBundle mainBundle] loadNibNamed:@"Satellite" owner:self options:nil] objectAtIndex:0];
  CGPoint center = [MySatelliteView createPointFromLocation:location];
  CGRect frame = CGRectMake(center.x - 15, center.y - 15, 30, 30);
  v.bounds = frame;
  v.frame = frame;
  v.tag = location.satelliteNumber.integerValue;
  v.currentLocation = location;
  v.myLocation = myLocation;
  [v rotate:location.coordinates.degree];
  
  return v;
}

-(void)update:(SatelliteLocation *)location {
  SatelliteLocation *tmpLocation = _currentLocation;
  if ([self needsNewCenter:location.coordinates]) {
//    [UIView animateWithDuration:0.2 animations:^{
      CGPoint center = [MySatelliteView createPointFromLocation:location];
      self.frame = CGRectMake(center.x - 15, center.y - 15, 30, 30);
      self.superview.clipsToBounds = YES;
      tmpLocation = location;
//    }];
  }
  if ([self needsRotate:location.coordinates]) {
//    [UIView animateWithDuration:0.2 animations:^{
      [self rotate:location.coordinates.degree];
      tmpLocation = location;
//    }];
  }
  _currentLocation = location;
  [self layoutIfNeeded];
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

-(BOOL)needsRotate:(SatelliteCoordinate *)coordinate {
  if (coordinate.degree == _currentLocation.coordinates.degree) {
    return NO;
  }
  
  _currentLocation.coordinates.degree = coordinate.degree;
  return YES;
}
-(BOOL)needsNewCenter:(SatelliteCoordinate *)coordinate {
  if (coordinate.x == _currentLocation.coordinates.x &&
      coordinate.y == _currentLocation.coordinates.y) {
    return NO;
  }
  
  _currentLocation.coordinates.x = coordinate.x;
  _currentLocation.coordinates.y = coordinate.y;
  return YES;
}

+(CGPoint)createPointFromLocation:(SatelliteLocation *)location {
  double newX = xOrigin + (axisSize * location.coordinates.x)/4 + 15;
  double newY = yOrigin + (axisSize * location.coordinates.y)/4 + 15;
  
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
