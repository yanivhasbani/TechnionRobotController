//
//  SateliteLocation.h
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 6/30/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SateliteCoordinate;

@interface SateliteLocation : NSObject

@property (nonatomic, strong) SateliteCoordinate *coordinates;
@property (nonatomic, strong) NSNumber *sateliteNumber;

+(instancetype)newWithJson:(NSDictionary *)dictionary;

@end
