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

@interface MapModel()

@end

@implementation MapModel



-(void)currentLocation {
  id<UDPPacketProtocol> p = [[UDPManager getPackets] lastObject];
  if (p) {
    _myLocation = [p generatePacket][@"myLocation"];
    _otherLocations = [p generatePacket][@"otherLocations"];
    [self.delegate mapModelLoadedData:self];
    return;
  }
  
  [self.delegate mapModelLoadedData:nil];
}

-(void)historyOfLocations {
//  NSArray<UDPPacketProtocol> *packets = [UDPManager getPackets];
//  for (id<UDPPacketProtocol> p in packets) {
//    
//  }
//  
//  updateUIBlock(NO);

}

@end
