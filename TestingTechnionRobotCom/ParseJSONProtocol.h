//
//  ParseJSONProtocol.h
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 7/2/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#ifndef ParseJSONProtocol_h
#define ParseJSONProtocol_h


@protocol ParseJSONProtocol <NSObject>

@required
-(NSDictionary *)json;
+(instancetype)newWithJson:(NSDictionary *)dictionary;
+(BOOL)validateJSON:(NSDictionary *)dictionary;

@end

#endif /* ParseJSONProtocol_h */
