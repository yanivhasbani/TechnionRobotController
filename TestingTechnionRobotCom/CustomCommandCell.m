//
//  CustomCommandCell.m
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 6/27/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import "CustomCommandCell.h"

@interface CustomCommandCell()

@property (strong, nonatomic) IBOutlet UILabel *commandLabel;
@end

@implementation CustomCommandCell

-(void)configureCell:(NSString *)cmdName {
  self.commandLabel.text = cmdName;
}

@end
