//
//  MovementConsts.h
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 6/24/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SateliteCommand) {
  SateliteCommandStop,
  SateliteCommandUp,
  SateliteCommandDown,
  SateliteCommandLeft,
  SateliteCommandRight,
  SateliteCommandRotateLeft,
  SateliteCommandRotateRight
};

static inline NSString * cmdToString(SateliteCommand cmd) {
  switch (cmd) {
    case SateliteCommandStop:
      return @"Stop";
    case SateliteCommandUp:
      return @"Up";
    case SateliteCommandDown:
      return @"Down";
    case SateliteCommandLeft:
      return @"Left";
    case SateliteCommandRight:
      return @"Right";
    case SateliteCommandRotateLeft:
      return @"RotateLeft";
    case SateliteCommandRotateRight:
      return @"RotateRight";
  }
}
