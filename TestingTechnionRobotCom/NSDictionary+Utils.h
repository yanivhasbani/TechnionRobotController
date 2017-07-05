//
//  NSDictionary+Utils.h
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 6/30/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Utils)

-(id)firstObject;
-(id)lastObject;

-(id)firstKey;
-(id)lastKey;

-(NSString *)json;

@end
