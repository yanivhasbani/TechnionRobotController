//
//  GestureProtocol.h
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 6/26/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#ifndef UIViewGestureProtocol_h
#define UIViewGestureProtocol_h

@protocol Gesturing <NSObject>

-(void)swipeLeft:(UISwipeGestureRecognizer*)gestureRecognizer;
-(void)swipeRight:(UISwipeGestureRecognizer*)gestureRecognizer;
-(void)swipeUp:(UISwipeGestureRecognizer*)gestureRecognizer;
-(void)swipeDown:(UISwipeGestureRecognizer*)gestureRecognizer;
-(void)handleSingleTap:(UISwipeGestureRecognizer*)gestureRecognizer;
-(void)holdDown;
-(void)holdReleased;

@end

#endif /* UIViewGestureProtocol_h */
