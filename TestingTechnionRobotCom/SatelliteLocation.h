//
//  SatelliteLocation.h
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 6/30/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SatelliteCoordinate;

@interface SatelliteLocation : NSObject

@property (nonatomic, strong) SatelliteCoordinate *coordinates;
@property (nonatomic, strong) NSNumber *satelliteNumber;
@property (nonatomic, strong) NSDictionary *data;

-(NSDictionary *)json;
+(instancetype)newWithJson:(NSDictionary *)dictionary;

@end
