//
//  ShakeProtocol.h
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 6/24/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#ifndef ShakeProtocol_h
#define ShakeProtocol_h


@protocol ShakeProtocol <NSObject>

-(void)shakeLeftArrow;
-(void)shakeRightArrow;
-(void)shakeUpArrow;
-(void)shakeDownArrow;
-(void)shakeLeftArrowFromCenter;
-(void)shakeRightArrowFromCenter;
//-(void)shakeUpArrowFromCenter;
-(void)shakeDownArrowFromCenter;

@end

#endif /* ShakeProtocol_h */
