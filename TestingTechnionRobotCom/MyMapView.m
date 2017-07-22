//
//  MyMapView.m
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 7/3/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import "MyMapView.h"
#import "MySatelliteView.h"
#import "SatelliteLocation.h"
#import "SatelliteCoordinate.h"
#import "UIView+Gestures.h"
#import "MapModel.h"

int xLabelSize = 25;
int yLabelSize = 25;

int axisSize;
double xOrigin = 0;
double yOrigin = 0;

const double lineWidth = 5.0f;


typedef NS_ENUM(NSUInteger, AxisDirection) {
  AxisDirectionX,
  AxisDirectionY
};

@interface MyMapView() <GestureDelegate>

@property (nonatomic, strong) NSMutableArray<MySatelliteView *> *satellites;

@end

@implementation MyMapView

#pragma mark -
#pragma mark DrawAxis
-(void)setAxisConsts:(CGRect)rect {
  double axisXSize = rect.size.width - 30;
  double axisYSize = rect.size.height - 30;
  
  axisSize =  MIN(axisXSize, axisYSize);
  
  if (axisSize == axisYSize) {
    xOrigin = (axisXSize - axisSize) / 2;
  } else {
    yOrigin = (axisYSize - axisSize) / 2;
  }
}

-(void)drawLine:(CGContextRef)context
        xOrigin:(double)xOrigin
        yOrigin:(double)yOrigin
            len:(double)len
      direction:(AxisDirection)direction {
  
  CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
  
  CGContextSetLineWidth(context, lineWidth);
  
  
  
  if (direction == AxisDirectionX) {
    CGContextMoveToPoint(context, xOrigin, yOrigin + 2); //start at this point
    CGContextAddLineToPoint(context, xOrigin + len, yOrigin + 2); //draw to this point
  } else if (direction == AxisDirectionY) {
    CGContextMoveToPoint(context, xOrigin, yOrigin); //start at this point
    CGContextAddLineToPoint(context, xOrigin, yOrigin + len); //draw to this point
  }
  
  CGContextStrokePath(context);
}

-(void)addLabels {
  UILabel *yLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOrigin - (yLabelSize + 5) / 2 + lineWidth/2, yOrigin + axisSize +2, yLabelSize, yLabelSize)];
  yLabel.textColor = [UIColor blueColor];
  [yLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
  yLabel.textAlignment = NSTextAlignmentCenter;
  yLabel.text = @"Y";
  
  [self addSubview:yLabel];
  
  UILabel *xLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOrigin + axisSize, yOrigin - (xLabelSize) / 2 + lineWidth/2, xLabelSize, xLabelSize)];
  xLabel.textColor = [UIColor blueColor];
  xLabel.textAlignment = NSTextAlignmentCenter;
  [xLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
  xLabel.text = @"X";
  
  [self addSubview:xLabel];
}

-(void)drawRect:(CGRect)rect {
  [super drawRect:rect];
  
  [self setAxisConsts:rect];
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  [self drawLine:context xOrigin:xOrigin yOrigin:yOrigin len:axisSize direction:AxisDirectionX];
  [self drawLine:context xOrigin:xOrigin yOrigin:yOrigin len:axisSize direction:AxisDirectionY];
  
  [self addLabels];
}

#pragma mark -
#pragma mark API
-(void)loadLocations:(MapModel *)locations {
  if (!_satellites) {
    _satellites = [NSMutableArray new];
  };
  
  [self createSatelliteViewFromLocation:locations.myLocation myLocation:YES];
  
  for (SatelliteLocation *l in locations.otherLocations) {
    [self createSatelliteViewFromLocation:l myLocation:NO];
  }
}

-(NSArray *)getAllSatelliteLocations {
  NSMutableArray *a = [NSMutableArray new];
  for (MySatelliteView *sv in _satellites) {
    [a addObject:sv.currentLocation];
  }
  
  return [a copy];
}

#pragma mark -
#pragma mark SatelliteCreation
-(void)createSatelliteViewFromLocation:(SatelliteLocation *)location myLocation:(BOOL)myLocation {
  MySatelliteView *locationView;
  for (MySatelliteView *v in _satellites) {
    if (v.tag == location.satelliteNumber.integerValue) {
      locationView = v;
      break;
    }
  }
  if (!locationView) {
    locationView = [MySatelliteView newWithLocation:location
                                        myLocation:myLocation];
    [_satellites addObject:locationView];
    dispatch_async(dispatch_get_main_queue(), ^{
      [UIView animateWithDuration:0.2 animations:^{
        [self addSubview:locationView];
      }];
    });
  } else {
    dispatch_async(dispatch_get_main_queue(), ^{
      [locationView update:location];
    });
  }
}
@end
