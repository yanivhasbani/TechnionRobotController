//
//  MapModel.m
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 6/30/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import "UDPManager.h"
#import "MapModel.h"
#import "SateliteLocation.h"
#import "ReceivedPacketModel.h"
#import "UIAlertController+MyAlertController.h"
#import "NSDictionary+Utils.h"


const int HISTORY_THRESHOLD = 30;

typedef NS_ENUM(NSUInteger, MapModelState) {
  MapModelStateCurrent,
  MapModelStateHistory
};

@interface MapModel()

@property (nonatomic, assign) MapModelState state;

@end

@implementation MapModel



-(void)currentLocation {
  _state = MapModelStateCurrent;
  id<UDPPacketProtocol> p = [[UDPManager getReceivedPackets] lastObject];
  if (p) {
    NSDictionary *json = [p generatePacket];
    _myLocation = json[@"myLocation"];
    _otherLocations = json[@"otherLocations"];
    [self.delegate mapModelLoadedData:self];
    return;
  }
  
  [self.delegate mapModelLoadedData:nil];
}

-(void)historyOfLocations {
  _state = MapModelStateHistory;
  __block UDPDictionary *packets = [[UDPManager getReceivedPackets] returnOnlyLast:HISTORY_THRESHOLD];
  __block NSArray<NSNumber *> *keysArray = [[packets allKeys] sortedArrayUsingComparator:^(NSNumber *a1, NSNumber *a2) {
    if ([a1 doubleValue] > [a2 doubleValue]) {
      
      return (NSComparisonResult)NSOrderedDescending;
    }
    if ([a1 doubleValue] < [a2 doubleValue]) {
      
      return (NSComparisonResult)NSOrderedAscending;
    }
    
    return (NSComparisonResult)NSOrderedSame;
  }];
  for (int i = 0; i < [keysArray count]; i++) {
    if (i) {
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_state == MapModelStateHistory) {
          NSNumber *k = keysArray[i];
          id<UDPPacketProtocol> p = packets[k];
          _myLocation = [p generatePacket][@"myLocation"];
          _otherLocations = [p generatePacket][@"otherLocations"];
          [self.delegate mapModelLoadedData:self];
        }
      });
    } else {
      NSNumber *k = keysArray[i];
      id<UDPPacketProtocol> p = packets[k];
      _myLocation = [p generatePacket][@"myLocation"];
      _otherLocations = [p generatePacket][@"otherLocations"];
      [self.delegate mapModelLoadedData:self];
    }
  }
}

@end
