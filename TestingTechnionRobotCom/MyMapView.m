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

int xLabelSize = 25;
int yLabelSize = 25;

int axisSize;
double xOrigin = 0;
double yOrigin = 0;
double xOffset;
double yOffset;

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
  
  xOffset = 0.02 * axisSize;
  yOffset = 0.02 * axisSize;
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
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _satelites = [NSMutableArray new];
  });
  for (MySateliteView *v in _satelites) {
    v.hidden = YES;
    [v removeFromSuperview];
  }

  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self createSateliteViewFromLocation:locations.myLocation];
    
    for (SateliteLocation *l in locations.otherLocations) {
      [self createSateliteViewFromLocation:l];
    }
  });
}

#pragma mark -
#pragma mark SateliteCreation
-(void)createSateliteViewFromLocation:(SateliteLocation *)location {
  CGRect frame = [self createRectFromLocation:location];
  MySateliteView *myLocationView = [MySateliteView newWithFrame:frame];
  [myLocationView rotate:M_PI/4];
  [myLocationView addTapGestures];
  myLocationView.gestureDelegate = self;
  
  [_satelites addObject:myLocationView];
  [self addSubview:myLocationView];
}

#pragma mark -
#pragma mark SateliteDrawing
-(CGRect)createRectFromLocation:(SateliteLocation *)location {
  double newX = xOrigin + xOffset * 10;
  double newY = yOrigin + yOffset * 10;
  
  if (newX > xOrigin + axisSize) {
    newX = xOrigin + axisSize;
  }
  
  if (newY > yOrigin + axisSize) {
    newY = yOrigin + axisSize;
  }
  
  return CGRectMake(newX, newY, 30, 30);
}

#pragma mark -
#pragma mark SateliteTap
-(void)handleSingleTap:(UIView *)view {
  
}

@end
