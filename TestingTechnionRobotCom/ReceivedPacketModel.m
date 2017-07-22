//
//  ReceivedPacketModel.m
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 7/2/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import "ReceivedPacketModel.h"
#import "ParseJSONProtocol.h"
#import "SatelliteLocation.h"
#import "NSArray+JSON.h"

@interface ReceivedPacketModel() <ParseJSONProtocol>

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) SatelliteLocation *myLocation;
@property (nonatomic, strong) NSArray<SatelliteLocation *> *otherLocations;

@end

@implementation ReceivedPacketModel

-(NSDictionary *)json {
  return @{
    @"myLocation" : _myLocation ? [_myLocation json] : [NSNull null],
    @"otherLocations" : _otherLocations ? [_otherLocations json] : [NSNull null],
    };
}

+(BOOL)validateJSON:(NSDictionary *)dictionary {
  if (!dictionary) {
    NSLog(@"No object");
    return NO;
  }
  
  if (![dictionary isKindOfClass:[NSDictionary class]]) {
    NSLog(@"Object received is not a dictionary. Obj = %@", dictionary);
    return NO;
  }
  
  if (![dictionary[@"myLocation"] isKindOfClass:[NSDictionary class]]) {
    NSLog(@"myLocation received is not a dictionary. Obj = %@",
          dictionary[@"Mylocation"] ? : [NSNull null]);
    return NO;
  }
  
  if (!dictionary[@"satelliteLocations"]) {
    NSLog(@"No other satellites location on object");
  }
  
  if (![dictionary[@"satelliteLocations"] isKindOfClass:[NSArray class]]) {
    NSLog(@"Other satellites object is not an array. Obj = %@", dictionary);
  }
  
  return YES;
}

+(instancetype)newWithJson:(NSDictionary *)dictionary {
  if (![self validateJSON:dictionary]) {
    return nil;
  }
  
  ReceivedPacketModel *m = [ReceivedPacketModel new];
  m.myLocation = [SatelliteLocation newWithJson:dictionary[@"myLocation"]];
  
  NSMutableArray *others = [NSMutableArray new];
  for (NSDictionary *d in dictionary[@"satelliteLocations"]) {
    SatelliteLocation *l = [SatelliteLocation newWithJson:d];
    if (l) {
      [others addObject:l];
    }
  }
  
  m.otherLocations = [others copy];
  m.id = @([[NSDate date] timeIntervalSince1970]);
  
  return m;
}


-(NSDictionary *)generatePacket {
  return @{
           @"myLocation" : _myLocation ? : [NSNull null],
           @"otherLocations" : _otherLocations ? : [NSNull null],
           };
}

-(NSString *)debugDescription {
  return [NSString stringWithFormat:@"%@", [self json]];
}

@end
