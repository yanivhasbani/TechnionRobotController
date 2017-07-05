//
//  NSDictionary+Utils.m
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 6/30/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import "NSDictionary+Utils.h"

@implementation NSDictionary (Utils)

-(id)firstObject {
  NSNumber *key = [[[self allKeys] sortedArrayUsingComparator: ^(id obj1, id obj2) {
    
    if ([obj1 integerValue] > [obj2 integerValue]) {
      
      return (NSComparisonResult)NSOrderedDescending;
    }
    if ([obj1 integerValue] < [obj2 integerValue]) {
      
      return (NSComparisonResult)NSOrderedAscending;
    }
    
    return (NSComparisonResult)NSOrderedSame;
  }] firstObject];
  
  return self[key];
}

-(id)lastObject {
  NSNumber *key = [[[self allKeys] sortedArrayUsingComparator:^(id obj1, id obj2) {
    
    if ([obj1 integerValue] > [obj2 integerValue]) {
      
      return (NSComparisonResult)NSOrderedDescending;
    }
    if ([obj1 integerValue] < [obj2 integerValue]) {
      
      return (NSComparisonResult)NSOrderedAscending;
    }
    
    return (NSComparisonResult)NSOrderedSame;
  }] lastObject];
  
  return self[key];
}

-(id)firstKey {
  return [[self allKeysForObject:[self firstObject]] firstObject];
}

-(id)lastKey {
  return [[self allKeysForObject:[self lastObject]] firstObject];
}

-(NSString *)json {
  NSError *error;
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                     options:NSJSONWritingPrettyPrinted
                                                       error:&error];
  
  if (error || !jsonData) {
    NSLog(@"json: error: %@", error.localizedDescription);
    return @"{}";
  } else {
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  }
}

@end
