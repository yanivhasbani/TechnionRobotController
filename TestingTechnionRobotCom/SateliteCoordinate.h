//
//  SateliteCoordinate.h
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 6/30/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SateliteCoordinate : NSObject

@property (nonatomic, assign) double x;
@property (nonatomic, assign) double y;
@property (nonatomic, assign) double degree;

+(instancetype)newWithJson:(NSDictionary *)dictionary;

@end
