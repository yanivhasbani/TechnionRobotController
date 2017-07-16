//
//  udpPacketProtocol.h
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 6/30/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#ifndef NetworkProtocol_h
#define NetworkProtocol_h

@protocol UDPPacketProtocol <NSObject>

@required
-(NSDictionary *)generatePacket;
-(NSString *)debugDescription;

@optional
-(NSDictionary *)json;

@end

#endif /* NetworkProtocol_h */
