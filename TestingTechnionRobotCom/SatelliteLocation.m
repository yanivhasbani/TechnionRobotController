//
//  SatelliteLocation.m
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 6/30/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import "SatelliteLocation.h"
#import "SatelliteCoordinate.h"
#import "udpPacketProtocol.h"
#import "ParseJSONProtocol.h"
#import "NSDictionary+Utils.h"

@interface SatelliteLocation() <ParseJSONProtocol>

@end

@implementation SatelliteLocation

-(NSDictionary *)json {
  return @{
    @"satelliteNumber" : _satelliteNumber,
    @"coordinates" : [_coordinates json]
    };
}

-(NSString *)description {
  return [self debugDescription];
}

-(NSString *)debugDescription {
  return [@{
           @"satelliteNumber" : _satelliteNumber,
           @"coordinates" : [_coordinates json],
           @"data" : _data
           } json];
}

+(BOOL)validateJSON:(NSDictionary *)dictionary {
  if (!dictionary || ![dictionary isKindOfClass:[NSDictionary class]]) {
    return NO;
  }
  
  if (!dictionary[@"satelliteNumber"] ||
      ![dictionary[@"satelliteNumber"] isKindOfClass:[NSNumber class]]) {
    return NO;
  }
  
  return YES;
}

+(instancetype)newWithJson:(NSDictionary *)dictionary {
  if (![self validateJSON:dictionary]) {
    NSLog(@"Error while validating SatelliteLocation. returning nil");
    return nil;
  }
  
  SatelliteLocation *s = [SatelliteLocation new];
  
  s.coordinates = [SatelliteCoordinate newWithJson:dictionary[@"coordinates"]];
  s.satelliteNumber = dictionary[@"satelliteNumber"];
  s.data = dictionary[@"data"];
  
  return s;
}

@end
