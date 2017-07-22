//
//  MovementConsts.h
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 6/24/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SatelliteCommand) {
  SatelliteCommandStop,
  SatelliteCommandUp,
  SatelliteCommandDown,
  SatelliteCommandLeft,
  SatelliteCommandRight,
  SatelliteCommandRotateLeft,
  SatelliteCommandRotateRight
};

static inline NSString * cmdToString(SatelliteCommand cmd) {
  switch (cmd) {
    case SatelliteCommandStop:
      return @"Stop";
    case SatelliteCommandUp:
      return @"Up";
    case SatelliteCommandDown:
      return @"Down";
    case SatelliteCommandLeft:
      return @"Left";
    case SatelliteCommandRight:
      return @"Right";
    case SatelliteCommandRotateLeft:
      return @"RotateLeft";
    case SatelliteCommandRotateRight:
      return @"RotateRight";
  }
}
