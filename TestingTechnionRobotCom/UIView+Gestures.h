//
//  UIView+Gestures.h
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 6/26/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "GestureProtocol.h"

@protocol GestureDelegate <NSObject>
//Swipe
@optional
-(void)swipeLeft;
-(void)swipeRight;
-(void)swipeDown;
-(void)swipeUp;

//Single tap
@optional
-(void)handleSingleTap:(UIView *)view;

//Hold
@optional
-(void)handleHold:(UIButton *)sender;
-(void)handleRelease:(UIView *)sender;

@end

@interface UIView (Gestures) <Gesturing>

@property (nonatomic, strong) id<GestureDelegate> gestureDelegate;

-(void)addHoldGesture;
-(void)removeHoldGesture;

-(void)addSwipeGestures;
-(void)removeSwipeGestures;

-(void)addTapGestures;
-(void)removeTapGestures;

@end
