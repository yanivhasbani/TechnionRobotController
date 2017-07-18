//
//  MyMapView.m
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 7/3/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import "MyMapView.h"
#import "MySateliteView.h"
#import "SateliteLocation.h"
#import "SateliteCoordinate.h"
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

@property (nonatomic, strong) NSMutableArray<MySateliteView *> *satelites;

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
-(void)reset {
  for (MySateliteView *v in _satelites) {
    v.hidden = YES;
    [v removeFromSuperview];
  }
  
  [_satelites removeAllObjects];
}

-(void)loadLocations:(MapModel *)locations {
  if (!_satelites) {
    _satelites = [NSMutableArray new];
  };
  
  [self createSateliteViewFromLocation:locations.myLocation myLocation:YES];
  
  for (SateliteLocation *l in locations.otherLocations) {
    [self createSateliteViewFromLocation:l myLocation:NO];
  }
}

#pragma mark -
#pragma mark SateliteCreation
-(void)createSateliteViewFromLocation:(SateliteLocation *)location myLocation:(BOOL)myLocation{
  MySateliteView *locationView;
  for (MySateliteView *v in _satelites) {
    if (v.tag == location.sateliteNumber.integerValue) {
      locationView = v;
      break;
    }
  }
  if (!locationView) {
    locationView = [MySateliteView newWithLocation:location
                                        myLocation:myLocation];
    [_satelites addObject:locationView];
    [UIView animateWithDuration:0.2 animations:^{
      [self addSubview:locationView];
    }];
  } else {
    [locationView update:location];
  }
}

#pragma mark -
#pragma mark SateliteDrawing


@end
