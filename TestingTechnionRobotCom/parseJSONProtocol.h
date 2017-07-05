//
//  parseJSONProtocol.h
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 7/2/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#ifndef parseJSONProtocol_h
#define parseJSONProtocol_h


@protocol parseJSONProtocol <NSObject>

@required
+(instancetype)newWithJson:(NSDictionary *)dictionary;
+(BOOL)validateJSON:(NSDictionary *)dictionary;

@end

#endif /* parseJSONProtocol_h */
