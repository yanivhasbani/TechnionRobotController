//
//  UIView+Gestures.m
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 6/26/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//
#import <objc/runtime.h>

#import "UIView+Gestures.h"

static NSMutableArray *mySwipeGestures;
static NSMutableArray *myTapGestures;
static NSTimer *timer;

@implementation UIView (Gestures)

@dynamic gestureDelegate;

-(id<GestureDelegate>)gestureDelegate {
  return objc_getAssociatedObject(self, @selector(gestureDelegate));
}

-(void)setGestureDelegate:(id<GestureDelegate>)gestureDelegate {
  objc_setAssociatedObject(self, @selector(gestureDelegate), gestureDelegate, OBJC_ASSOCIATION_RETAIN);
}

-(void)addHoldGesture {
  if (![self isKindOfClass:[UIButton class]]) {
    return;
  }
  
  UIButton *b = (UIButton *)self;
  [b addTarget:self action:@selector(holdDown) forControlEvents:UIControlEventTouchDown];
  [b addTarget:self action:@selector(holdReleased) forControlEvents:UIControlEventTouchUpInside];
}

-(void)removeHoldGesture {
  
}

-(void)addTapGestures {
  UITapGestureRecognizer *singleFingerTap =
  [[UITapGestureRecognizer alloc] initWithTarget:self
                                          action:@selector(handleSingleTap:)];
  myTapGestures = [NSMutableArray new];
  [myTapGestures addObject:singleFingerTap];
  [self addGestureRecognizer:singleFingerTap];
}

-(void)removeTapGestures {
  for (UISwipeGestureRecognizer *g in myTapGestures) {
    [self removeGestureRecognizer:g];
  }
  
  myTapGestures = nil;
}

-(void)addSwipeGestures {
  [self addGestures:@[@(UISwipeGestureRecognizerDirectionLeft),
                      @(UISwipeGestureRecognizerDirectionRight),
                      @(UISwipeGestureRecognizerDirectionDown),
                      @(UISwipeGestureRecognizerDirectionUp)]];
}

-(void)removeSwipeGestures {
  for (UISwipeGestureRecognizer *g in mySwipeGestures) {
    [self removeGestureRecognizer:g];
  }
  
  mySwipeGestures = nil;
}

-(void)addGestures:(NSArray<NSNumber *> *)gestures {
  id<Gesturing> protocolSelf = (id<Gesturing>)self;
  
  mySwipeGestures = [NSMutableArray new];
  
  for (NSNumber *n in gestures) {
    UISwipeGestureRecognizerDirection d = (UISwipeGestureRecognizerDirection)[n integerValue];
    UISwipeGestureRecognizer * swipe;
    switch (d) {
      case UISwipeGestureRecognizerDirectionRight:
        swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:protocolSelf action:@selector(swipeLeft:)];
        break;
      case UISwipeGestureRecognizerDirectionLeft:
        swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:protocolSelf action:@selector(swipeRight:)];
        break;
      case UISwipeGestureRecognizerDirectionUp:
        swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:protocolSelf action:@selector(swipeUp:)];
        break;
      case UISwipeGestureRecognizerDirectionDown:
        swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:protocolSelf action:@selector(swipeDown:)];
        break;
    }
    swipe.direction = d;
    [mySwipeGestures addObject:swipe];
    [self addGestureRecognizer:swipe];
  }
}



-(void)swipeLeft:(UISwipeGestureRecognizer *)gestureRecognizer {
  [self.gestureDelegate swipeLeft];
}

-(void)swipeUp:(UISwipeGestureRecognizer *)gestureRecognizer {
  [self.gestureDelegate swipeUp];
}

-(void)swipeDown:(UISwipeGestureRecognizer *)gestureRecognizer {
  [self.gestureDelegate swipeDown];
}

-(void)swipeRight:(UISwipeGestureRecognizer *)gestureRecognizer {
  [self.gestureDelegate swipeRight];
}

-(void)handleSingleTap:(UISwipeGestureRecognizer *)gestureRecognizer {
  [self.gestureDelegate handleSingleTap:self];
}

-(void)holdDown {
  if (!timer) {
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(handleHold:) userInfo:self repeats:YES];
  }
}

-(void)holdReleased {
  [self.gestureDelegate handleRelease:(UIButton *)self];
  [timer invalidate];
  timer = nil;
}

-(void)handleHold:(NSTimer *)timer {
  [self.gestureDelegate handleHold:(UIButton *)self];
}
@end
