//
//  MySateliteView.h
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 7/4/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SateliteCoordinate;
@interface MySateliteView : UIView

@property (nonatomic, strong) SateliteCoordinate *lastLocation;

+(instancetype)newWithFrame:(CGRect)frame;
-(BOOL)needsRotate:(SateliteCoordinate *)coordinate;
-(BOOL)needsNewCenter:(SateliteCoordinate *)coordinate;
-(void)rotate:(double)rads;

@end
