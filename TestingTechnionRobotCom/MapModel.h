//
//  MapModel.h
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 6/30/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SatelliteLocation.h"

@protocol MapModelDelegate <NSObject>

-(void)mapModelLoadedData:(id)data;

@end

typedef void (^completionBlock)(BOOL);

@interface MapModel : NSObject

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) SatelliteLocation *myLocation;
@property (nonatomic, strong) NSArray<SatelliteLocation *> *otherLocations;

@property (nonatomic, strong) id<MapModelDelegate> delegate;

-(void)currentLocation;
-(void)historyOfLocations;

@end
