//
//  PlayVC.m
//  TestingTechnionRobotCom
//
//  Created by Yaniv Hasbani on 6/24/17.
//  Copyright © 2017 Yaniv. All rights reserved.
//

#import "PlayVC.h"
#import "UDPManager.h"
#import "MovementManager.h"
#import "MovementConsts.h"
#import "UIView+ShakeProtocol.h"
#import "UIView+Gestures.h"
#import "UIView+InflateAnimation.h"
#import "SendPacketModel.h"
#import "CustomCommandVC.h"

typedef NS_ENUM(NSUInteger, ButtonType) {
  ButtonTypeUp,
  ButtonTypeDown,
  ButtonTypeLeft,
  ButtonTypeRight,
  ButtonTypeRotateLeft,
  ButtonTypeRotateRight,
  ButtonTypeNone
};

@interface PlayVC () <MovementDelegate, GestureDelegate>

@property (nonatomic, assign) NSInteger retryConnection;
@property (strong, nonatomic) IBOutlet UISegmentedControl *uiSegment;
@property (strong, nonatomic) IBOutlet UIButton *leftArrow;
@property (strong, nonatomic) IBOutlet UIButton *upArrow;
@property (strong, nonatomic) IBOutlet UIButton *downArrow;
@property (strong, nonatomic) IBOutlet UIButton *rightArrow;
@property (strong, nonatomic) IBOutlet UIButton *rotateLeft;
@property (strong, nonatomic) IBOutlet UIButton *rotateRight;
@property (strong, nonatomic) IBOutlet UIButton *redButtonImage;

@property (nonatomic, assign) UIType uiType;

@end

@implementation PlayVC
@synthesize uiType = _uiType;
-(UIType)uiType {
  return _uiType;
}

-(void)setUiType:(UIType)type {
  if (type == UITypeGyro) {
    //Start Gyro measurement
    [self.view removeSwipeGestures];
    [self.view removeTapGestures];
    self.view.gestureDelegate = nil;
    [self startGyro];
  } else if (type == UITypeSwipe) {
    [self stopGyro];
    [self.view addSwipeGestures];
    self.view.gestureDelegate = self;
  }
  
  
  [_rotateLeft addHoldGesture];
  [_rotateRight addHoldGesture];
  _rotateRight.gestureDelegate = self;
  _rotateLeft.gestureDelegate = self;
  
  [_leftArrow addHoldGesture];
  _leftArrow.gestureDelegate = self;
  [_rightArrow addHoldGesture];
  _rightArrow.gestureDelegate = self;
  [_upArrow addHoldGesture];
  _upArrow.gestureDelegate = self;
  [_downArrow addHoldGesture];
  _downArrow.gestureDelegate = self;
  
  
  [self showAllButtons];
  [self removeAllAnimations];
  
  _uiType = type;
}


- (void)viewDidLoad {
  [super viewDidLoad];
  
  //Open UDP connection
  _retryConnection = 5;
  [self openUDPConnection];
  
  self.uiType = _segueData;
  
  
  
  [_uiSegment setSelectedSegmentIndex:self.uiType];
}


#pragma mark -
#pragma mark UDP
//Init
-(void)openUDPConnection {
  static NSInteger retryCounter = 0;
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
    [UDPManager openConnectionForData:_ipAddress
                              udpPort:_udpPort
                         intervalTime:@(0.5)
                           completion:^(NSError * err) {
                             if (err) {
                               NSLog(@"Error in opening connection. err = %@", err);
                               retryCounter++;
                               if (retryCounter < _retryConnection) {
                                 return [self openUDPConnection];
                               }
                             } else {
                               //First command sent is stop
                               [self sendNextCommandToSatelite:SateliteCommandStop];
                             }
                           }];
  });
}

//API
//-(NSString *)receiveNextDataFromSatelite {
//  NSString *baseCmd = [UDPManager getPacket];
//  NSLog(@"Got cmd from base. cmd = %@", baseCmd);
//  
//  return baseCmd;
//}

-(void)sendNextCommandToSatelite:(SateliteCommand)cmd {
  SendPacketModel *p = [SendPacketModel newWithMessage:cmdToString(cmd) sateliteNumber:_sateliteNumber];
  [UDPManager  sendPacket:p];
}


#pragma mark -
#pragma mark UI Manipulation
-(void)removeAllAnimations {
  [UIView animateWithDuration:0.4 animations:^{
    [_leftArrow.layer removeAllAnimations];
    [_rightArrow.layer removeAllAnimations];
    [_upArrow.layer removeAllAnimations];
    [_downArrow.layer removeAllAnimations];
  }];
}

-(void)showAllButtons {
  [UIView animateWithDuration:0.4 animations:^{
    _rightArrow.hidden = NO;
    _upArrow.hidden = NO;
    _downArrow.hidden = NO;
    _rotateLeft.hidden = NO;
    _rotateRight.hidden = NO;
    _leftArrow.hidden = NO;
    //    _redButtonImage.hidden = YES;
  }];
}

-(void)hideButtonsExcept:(ButtonType)excludedButton {
  _rightArrow.hidden = YES;
  _upArrow.hidden = YES;
  _downArrow.hidden = YES;
  _rotateLeft.hidden = YES;
  _rotateRight.hidden = YES;
  _leftArrow.hidden = YES;
  //  _redButtonImage.hidden = NO;
  //  [_redButtonImage inflateDeflate];
  
  switch (excludedButton) {
    case ButtonTypeUp:
      _upArrow.hidden = NO;
      break;
    case ButtonTypeDown:
      _downArrow.hidden = NO;
      break;
    case ButtonTypeLeft:
      _leftArrow.hidden = NO;
      break;
    case ButtonTypeRight:
      _rightArrow.hidden = NO;
      break;
    case ButtonTypeRotateLeft:
      _rotateLeft.hidden = NO;
      break;
    case ButtonTypeRotateRight:
      _rotateRight.hidden = NO;
      break;
    default:
      break;
  }
}

#pragma mark -
#pragma mark Swipe - GestureDelegate
-(void)swipeRight {
  [self.view addTapGestures];
  [self.view removeSwipeGestures];
  
  //  [self hideButtonsExcept:ButtonTypeLeft];
  
  [self sendNextCommandToSatelite:SateliteCommandLeft];
  
  //  [_leftArrow shakeLeftArrow];
}

-(void)swipeLeft {
  [self.view addTapGestures];
  [self.view removeSwipeGestures];
  
  //  [self hideButtonsExcept:ButtonTypeRight];
  
  [self sendNextCommandToSatelite:SateliteCommandRight];
  
  //  [_rightArrow shakeRightArrow];
}

-(void)swipeUp {
  [self.view addTapGestures];
  [self.view removeSwipeGestures];
  
  //  [self hideButtonsExcept:ButtonTypeUp];
  
  [self sendNextCommandToSatelite:SateliteCommandUp];
  
  //  [_upArrow shakeUpArrow];
}

-(void)swipeDown {
  [self.view addTapGestures];
  [self.view removeSwipeGestures];
  
  //  [self hideButtonsExcept:ButtonTypeDown];
  
  [self sendNextCommandToSatelite:SateliteCommandDown];
  
  //  [_downArrow shakeDownArrow];
}

-(void)handleSingleTap:(UIView *)view {
  
  if ([self.view isEqual:view]) {
    [_upArrow setUserInteractionEnabled:YES];
    [_downArrow setUserInteractionEnabled:YES];
    [_leftArrow setUserInteractionEnabled:YES];
    [_rightArrow setUserInteractionEnabled:YES];
    [self removeAllAnimations];
    [self.view addSwipeGestures];
    
    [self sendNextCommandToSatelite:SateliteCommandStop];
    
    [self showAllButtons];
  }
}

-(void)handleHold:(UIButton *)sender {
  if (sender == _rotateLeft) {
    [self sendNextCommandToSatelite:SateliteCommandRotateLeft];
  } else if (sender == _rotateRight) {
    [self sendNextCommandToSatelite:SateliteCommandRotateRight];
  } else if ([_leftArrow isEqual:sender]) {
    [_leftArrow setUserInteractionEnabled:NO];
    [self.view removeSwipeGestures];
    [self swipeRight];
  } else if ([_rightArrow isEqual:sender]) {
    [_rightArrow setUserInteractionEnabled:NO];
    [self.view removeSwipeGestures];
    [self swipeLeft];
  }else if ([_upArrow isEqual:sender]) {
    [_upArrow setUserInteractionEnabled:NO];
    [self.view removeSwipeGestures];
    [self swipeUp];
  }else if ([_downArrow isEqual:sender]) {
    [_downArrow setUserInteractionEnabled:NO];
    [self.view removeSwipeGestures];
    [self swipeDown];
  }
}

-(void)handleRelease:(UIButton *)sender {
  
}

#pragma mark -
#pragma mark Gyro
-(void)startGyro {
  [MovementManager shared].delegate = self;
  [[MovementManager shared] start];
}

-(void)stopGyro {
  [[MovementManager shared] stop];
}

#pragma mark -
#pragma mark MovementDelegate
-(void)movementOccured:(SateliteCommand)cmd {
  [self sendNextCommandToSatelite:cmd];
  [self updateUI:cmd];
}

-(void)updateUI:(SateliteCommand)cmd {
  UIButton *shaker;
  SEL f;
  switch (cmd) {
    case SateliteCommandStop:
      [self removeAllAnimations];
      [self showAllButtons];
      shaker = nil;
      f = NULL;
      break;
    case SateliteCommandUp:
      [self hideButtonsExcept:ButtonTypeUp];
      shaker = _upArrow;
      f = @selector(shakeUpArrow);
      break;
    case SateliteCommandLeft:
      [self hideButtonsExcept:ButtonTypeLeft];
      shaker = _leftArrow;
      f = @selector(shakeLeftArrowFromCenter);
      break;
    case SateliteCommandRight:
      [self hideButtonsExcept:ButtonTypeRight];
      shaker = _rightArrow;
      f = @selector(shakeRightArrowFromCenter);
      break;
    case SateliteCommandDown:
      [self hideButtonsExcept:ButtonTypeDown];
      shaker = _downArrow;
      f = @selector(shakeDownArrowFromCenter);
      break;
    default:
      shaker = nil;
      f=  NULL;
      break;
  }
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    if (shaker) {
      [shaker performSelector:f withObject:nil afterDelay:0];
    }
  });
}

#pragma mark -
#pragma mark Picker
- (IBAction)segmentChange:(id)sender {
  if (_uiSegment.selectedSegmentIndex == 0) {
    self.uiType = UITypeGyro;
  } else if (_uiSegment.selectedSegmentIndex == 1) {
    self.uiType = UITypeSwipe;
  }
}

#pragma mark -
#pragma mark CustomCommandVC display
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSNumber *)sender {
  if ([segue.destinationViewController isKindOfClass:[CustomCommandVC class]]) {
    CustomCommandVC *ccvc = (CustomCommandVC *)segue.destinationViewController;
    ccvc.sateliteNumber = _sateliteNumber;
  }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches
           withEvent:(UIEvent *)event {
  UITouch *touch= [touches anyObject];
  if ([touch view] == self.view && touches.count > 1)
  {
    //More than two finger touched the screen, load configurator
    [self performSegueWithIdentifier:@"CustomCommandVC" sender:_sateliteNumber];
  }
}

#pragma mark -
#pragma mark LocationVC display


@end
