//
//  SateliteLocation.m
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 6/30/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import "SateliteLocation.h"
#import "SateliteCoordinate.h"
#import "udpPacketProtocol.h"
#import "ParseJSONProtocol.h"
#import "NSDictionary+Utils.h"

@interface SateliteLocation() <ParseJSONProtocol>

@end

@implementation SateliteLocation

-(NSDictionary *)json {
  return @{
    @"satelliteNumber" : _sateliteNumber,
    @"coordinates" : [_coordinates json]
    };
}

-(NSString *)description {
  return [self debugDescription];
}

-(NSString *)debugDescription {
  return [@{
           @"satelliteNumber" : _sateliteNumber,
           @"coordinates" : [_coordinates json]
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
    NSLog(@"Error while validating SateliteLocation. returning nil");
    return nil;
  }
  
  SateliteLocation *s = [SateliteLocation new];
  
  s.coordinates = [SateliteCoordinate newWithJson:dictionary[@"coordinates"]];
  s.sateliteNumber = dictionary[@"satelliteNumber"];
  
  return s;
}

@end
