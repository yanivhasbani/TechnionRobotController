//
//  ReceivedPacketModel.m
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 7/2/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import "ReceivedPacketModel.h"
#import "parseJSONProtocol.h"
#import "SateliteLocation.h"

@interface ReceivedPacketModel() <parseJSONProtocol>

@property (nonatomic, strong) SateliteLocation *myLocation;
@property (nonatomic, strong) NSArray<SateliteLocation *> *otherLocations;

@end

@implementation ReceivedPacketModel

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
  
  if (!dictionary[@"sateliteLocations"]) {
    NSLog(@"No other satelites location on object");
  }
  
  if (![dictionary[@"sateliteLocations"] isKindOfClass:[NSArray class]]) {
    NSLog(@"Other satelites object is not an array. Obj = %@", dictionary);
  }
  
  return YES;
}

+(instancetype)newWithJson:(NSDictionary *)dictionary {
  if (![self validateJSON:dictionary]) {
    return nil;
  }
  
  ReceivedPacketModel *m = [ReceivedPacketModel new];
  m.myLocation = [SateliteLocation newWithJson:dictionary[@"myLocation"]];
  
  NSMutableArray *others = [NSMutableArray new];
  for (NSDictionary *d in dictionary[@"sateliteLocations"]) {
    SateliteLocation *l = [SateliteLocation newWithJson:d];
    
    [others addObject:l];
  }
  
  m.otherLocations = [others copy];
  
  return m;
}


-(NSDictionary *)generatePacket {
  return @{
           @"myLocation" : _myLocation ? : [NSNull null],
           @"otherLocations" : _otherLocations ? : [NSNull null],
           };
}

-(NSString *)debugDescription {
  return [NSString stringWithFormat:@"%@", [self generatePacket]];
}

@end
