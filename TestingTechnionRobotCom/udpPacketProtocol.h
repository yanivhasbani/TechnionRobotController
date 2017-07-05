//
//  udpPacketProtocol.h
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 6/30/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#ifndef NetworkProtocol_h
#define NetworkProtocol_h

@protocol  UDPPacketProtocol <NSObject>

-(NSDictionary *)generatePacket;
-(NSString *)debugDescription;

@end

#endif /* NetworkProtocol_h */
