//
//  RuntimeUtils.h
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 7/5/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Token that wraps a dispatch_after call
 */
@protocol DispatchToken <NSObject>
/**
 *  Cancels a iio_dispatch_after call. Thread safe
 */
-(void)cancel;
@end

/**
 *  Primitive wrapper around dispatch after which allows to cancel a block
 *
 *  @param whenInSecondsFromNow  The number of seconds you wish to delay this call
 *  @param queue The queue to call on
 *  @param block The block to perform
 *
 *  @return A token which can be used to cancel the dispatch block. The token is thread safe and can be called from multiple threads mutliple times
 *            Notice that since the wrapper creates an objective-c token, this is less accurate than a direct "dispatch_after" call
 */
id <DispatchToken> my_dispatch_after(NSUInteger whenInSecondsFromNow,
                                     dispatch_queue_t queue,
                                     dispatch_block_t block);
