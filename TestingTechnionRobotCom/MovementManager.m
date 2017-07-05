//
//  MovementManager.m
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 6/24/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import "MovementManager.h"
#import "MovementIdentifier.h"

@interface MovementManager() <MovementIdentifierDelegate>

//int =  SateliteCommand
@property (nonatomic, strong) NSNumber *lastMove;
@property (nonatomic, strong) MovementIdentifier *movementIdentifier;

@end

@implementation MovementManager

static MovementManager* movementManager;
+(instancetype)shared {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    movementManager = [MovementManager new];
  });
  
  return movementManager;
}

-(void)start {
  _movementIdentifier = [MovementIdentifier new];
  _movementIdentifier.delegate = self;
  [_movementIdentifier start];
}

-(void)stop {
  [_movementIdentifier stop];
  _movementIdentifier = nil;
}


#pragma mark -
#pragma mark CoordinateDelegate
-(void)S {
  if (![_lastMove isEqualToNumber:@(SateliteCommandStop)]) {
      [self.delegate movementOccured:SateliteCommandStop];
    _lastMove = @(SateliteCommandStop);
  }
}

-(void)RR {
  if ([_lastMove integerValue] == SateliteCommandLeft) {
    [self S];
  }
  
  [self R];
}
-(void)R {
  if ([_lastMove integerValue] == SateliteCommandLeft) {
    //If last position was left, stop
    return [self S];
  } else if ([_lastMove integerValue] == SateliteCommandRight) {
    return;
  }
  
  _lastMove = @(SateliteCommandRight);
  [self.delegate movementOccured:SateliteCommandRight];
}

-(void)L {
  if ([_lastMove integerValue] == SateliteCommandRight) {
    return [self S];
  } else if ([_lastMove integerValue] == SateliteCommandLeft) {
    return;
  }
  
  _lastMove = @(SateliteCommandLeft);
  [self.delegate movementOccured:SateliteCommandLeft];
}

-(void)LL {
  if ([_lastMove integerValue] == SateliteCommandRight) {
    [self S];
  }
  
  return [self L];
}

-(void)UU {
  if ([_lastMove integerValue] == SateliteCommandDown) {
    [self S];
  }
  
  return [self U];
}

-(void)U {
  if ([_lastMove integerValue] == SateliteCommandDown) {
    return [self S];
  } else if ([_lastMove integerValue] == SateliteCommandUp) {
    return;
  }
  
  [self.delegate movementOccured:SateliteCommandUp];
  _lastMove = @(SateliteCommandUp);
}

-(void)DD {
  if ([_lastMove integerValue] == SateliteCommandUp) {
    [self S];
  }
  
  return [self D];
}

-(void)D {
  if ([_lastMove integerValue] == SateliteCommandUp) {
    return [self S];
  } else if ([_lastMove integerValue] == SateliteCommandDown) {
    return;
  }
  
  
  _lastMove = @(SateliteCommandDown);
  [self.delegate movementOccured:SateliteCommandDown];
}

@end
