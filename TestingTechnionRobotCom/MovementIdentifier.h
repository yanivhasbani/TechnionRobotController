//
//  Coordinates.h
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 6/20/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MovementIdentifierDelegate <NSObject>

-(void)S;
-(void)R;
-(void)L;
-(void)U;
-(void)D;

@end

@interface MovementIdentifier : NSObject

@property (nonatomic, weak) id<MovementIdentifierDelegate> delegate;

+(instancetype)shared;

+(void)start;
+(void)stop;

@end
