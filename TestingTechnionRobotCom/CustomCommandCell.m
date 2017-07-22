//
//  CustomCommandCell.m
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 6/27/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "CustomCommandCell.h"
#import "SendPacketModel.h"
#import "UDPManager.h"

@interface CustomCommandCell()

@property (strong, nonatomic) IBOutlet UILabel *commandLabel;
@end

@implementation CustomCommandCell

-(void)configureCell:(NSString *)cmdName {
  self.commandLabel.text = cmdName;
  
  self.layer.cornerRadius = 2.5;
}

-(void)sendCmdToServer {
  SendPacketModel *p = [SendPacketModel newWithMessage:self.commandLabel.text];
  
  [UDPManager sendPacket:p];
}

@end
