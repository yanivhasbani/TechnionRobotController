//
//  Coordinates.h
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 6/20/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CoordinateDelegate <NSObject>

-(void)S;
-(void)R;
-(void)L;
-(void)U;
-(void)D;

@end

@interface Coordinates : NSObject

@property (nonatomic, weak) id<CoordinateDelegate> delegate;

+(instancetype)shared;

-(void)start;
-(void)stop;

@end
