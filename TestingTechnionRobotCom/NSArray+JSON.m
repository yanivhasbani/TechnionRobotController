//
//  NSArray+JSON.m
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 7/10/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import "NSArray+JSON.h"

@implementation NSArray (JSON)

-(NSArray *)json {
  NSMutableArray *arr = [NSMutableArray new];
  for (id object in self) {
    if ([object respondsToSelector:NSSelectorFromString(@"json")]) {
      id json = [object json];
      if (json) {
        [arr addObject:[object json]];
      }
      
    }
  }
  return [arr copy];
}

@end
