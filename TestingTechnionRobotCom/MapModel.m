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

@interface MapModel() <UDPDelegate>

@property (atomic, assign) BOOL readyToReceiveData;

@end

@implementation MapModel

+(instancetype)new {
  MapModel *m = [[MapModel alloc] init];
  
  [UDPManager sharedManager].delegate = m;
  
  return m;
}

-(void)gotPacket:(id<UDPPacketProtocol>)packet {
  if (packet) {
    NSDictionary *json = [packet generatePacket];
    _myLocation = json[@"myLocation"];
    _otherLocations = json[@"otherLocations"];
    [self.delegate mapModelLoadedData:self];
    return;
  }
}

-(void)currentLocation {
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
//  __block UDPDictionary *packets = [[UDPManager getReceivedPackets] returnOnlyLast:HISTORY_THRESHOLD];
//  __block NSArray<NSNumber *> *keysArray = [[packets allKeys] sortedArrayUsingComparator:^(NSNumber *a1, NSNumber *a2) {
//    if ([a1 doubleValue] > [a2 doubleValue]) {
//      
//      return (NSComparisonResult)NSOrderedDescending;
//    }
//    if ([a1 doubleValue] < [a2 doubleValue]) {
//      
//      return (NSComparisonResult)NSOrderedAscending;
//    }
//    
//    return (NSComparisonResult)NSOrderedSame;
//  }];
//  for (int i = 0; i < [keysArray count]; i++) {
//    if (i) {
//      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if (_state == MapModelStateHistory) {
//          NSNumber *k = keysArray[i];
//          id<UDPPacketProtocol> p = packets[k];
//          _myLocation = [p generatePacket][@"myLocation"];
//          _otherLocations = [p generatePacket][@"otherLocations"];
//          [self.delegate mapModelLoadedData:self];
//        }
//      });
//    } else {
//      NSNumber *k = keysArray[i];
//      id<UDPPacketProtocol> p = packets[k];
//      _myLocation = [p generatePacket][@"myLocation"];
//      _otherLocations = [p generatePacket][@"otherLocations"];
//      [self.delegate mapModelLoadedData:self];
//    }
//  }
}

@end
