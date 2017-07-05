//
//  SateliteCoordinate.m
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 6/30/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import "SateliteCoordinate.h"
#import "parseJSONProtocol.h"

@interface SateliteCoordinate()

@end

@interface SateliteCoordinate() <parseJSONProtocol>

+(BOOL)validateJSON:(NSDictionary *)dictionary;

@end

@implementation SateliteCoordinate

+(BOOL)validateJSON:(NSDictionary *)dictionary {
  if (!dictionary) {
    NSLog(@"No data for location");
    return nil;
  }
  
  if (![dictionary isKindOfClass:[NSDictionary class]]) {
    NSLog(@"Location data received is not a dictionary. data = %@", dictionary);
    return nil;
  }
  
  if(![dictionary[@"x"] isKindOfClass:[NSNumber class]] ||
     ![dictionary[@"y"] isKindOfClass:[NSNumber class]] ||
     ![dictionary[@"degree"] isKindOfClass:[NSNumber class]]) {
    return NO;
  }
  
  
  return YES;
}

+(instancetype)newWithJson:(NSDictionary *)dictionary {
  if (![self validateJSON:dictionary]) {
    return nil;
  }
  
  double x = [(NSNumber *)dictionary[@"x"] doubleValue];
  double y = [(NSNumber *)dictionary[@"y"] doubleValue];
  double degree = [(NSNumber *)dictionary[@"degree"] doubleValue];
  
  SateliteCoordinate *sl = [SateliteCoordinate new];
  sl.x = x;
  sl.y = y;
  sl.degree = degree;
  
  return sl;
}

@end
