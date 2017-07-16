//
//  RuntimeUtils.m
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 7/5/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import "RuntimeUtils.h"

@interface DispatchToken : NSObject <DispatchToken>

@property (nonatomic, strong, readonly) dispatch_source_t timer;

@end

@implementation DispatchToken

-(void)cancel {
  dispatch_source_cancel(_timer);
}

-(void)dealloc {
  
}

-(instancetype)initWithBlock:(dispatch_block_t)block
                     onQueue:(dispatch_queue_t)queue
                performAfter:(uint64_t)after {
  self = [super init];
  
  _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
  
  __weak id welf = self;
  
  dispatch_time_t time = dispatch_walltime(DISPATCH_TIME_NOW, after * NSEC_PER_SEC);
  dispatch_source_set_timer(_timer, time,
                            //This is the time to wait in between 2 timer shots
                            //In reality, only called once
                            NSEC_PER_SEC * 1000,
                            NSEC_PER_SEC);
  dispatch_source_set_event_handler(_timer, ^{
    __strong id strongSelf = welf;
    NSLog(@"Fired %@", self);
    block();
    [strongSelf cancel];
  });
  
  dispatch_resume(_timer);
  
  return self;
}

@end


id <DispatchToken> my_dispatch_after(NSUInteger whenInSecondsFromNow,
                                      dispatch_queue_t queue,
                                      dispatch_block_t block) {
  return [[DispatchToken alloc] initWithBlock:block
                                      onQueue:queue
                                 performAfter:whenInSecondsFromNow];
}

