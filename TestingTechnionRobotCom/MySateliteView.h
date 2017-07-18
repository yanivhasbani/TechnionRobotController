//
//  MySateliteView.h
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 7/4/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SateliteCoordinate, SateliteLocation;
@interface MySateliteView : UIView

@property (nonatomic, strong) SateliteCoordinate *lastLocation;

-(BOOL)needsRotate:(SateliteCoordinate *)coordinate;
-(BOOL)needsNewCenter:(SateliteCoordinate *)coordinate;

+(instancetype)newWithLocation:(SateliteLocation *)location myLocation:(BOOL)myLocation;

-(void)rotate:(double)rads;
-(void)update:(SateliteLocation *)location;
@end
