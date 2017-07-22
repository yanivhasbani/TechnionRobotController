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
  if (![_lastMove isEqualToNumber:@(SatelliteCommandStop)]) {
      [self.delegate movementOccured:SatelliteCommandStop];
    _lastMove = @(SatelliteCommandStop);
  }
}

-(void)R {
  if ([_lastMove integerValue] == SatelliteCommandLeft) {
    //If last position was left, stop
    return [self S];
  } else if ([_lastMove integerValue] == SatelliteCommandRight) {
    return;
  }
  
  _lastMove = @(SatelliteCommandRight);
  [self.delegate movementOccured:SatelliteCommandRight];
}

-(void)L {
  if ([_lastMove integerValue] == SatelliteCommandRight) {
    return [self S];
  } else if ([_lastMove integerValue] == SatelliteCommandLeft) {
    return;
  }
  
  _lastMove = @(SatelliteCommandLeft);
  [self.delegate movementOccured:SatelliteCommandLeft];
}

-(void)U {
  if ([_lastMove integerValue] == SatelliteCommandDown) {
    return [self S];
  } else if ([_lastMove integerValue] == SatelliteCommandUp) {
    return;
  }
  
  [self.delegate movementOccured:SatelliteCommandUp];
  _lastMove = @(SatelliteCommandUp);
}

-(void)D {
  if ([_lastMove integerValue] == SatelliteCommandUp) {
    return [self S];
  } else if ([_lastMove integerValue] == SatelliteCommandDown) {
    return;
  }
  
  
  _lastMove = @(SatelliteCommandDown);
  [self.delegate movementOccured:SatelliteCommandDown];
}

@end
