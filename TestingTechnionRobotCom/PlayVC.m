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

@property (nonatomic, strong) NSUUID *currentMovementID;

@property (nonatomic, assign) UIType uiType;

@end

static UIType savedSate;

@implementation PlayVC
@synthesize uiType = _uiType;
-(UIType)uiType {
  return _uiType;
}

-(void)setUiType:(UIType)type {
  if (type == UITypeAccelerator) {
    //Start Accelerometer measurement
    [self.view removeSwipeGestures];
    [self.view removeTapGestures];
    self.view.gestureDelegate = nil;
    [self startAccelerator];
  } else if (type == UITypeJoystick) {
    [self stopAccelerator];
    self.view.gestureDelegate = self;
    [self addAllHoldGestures];
  }
  
  [self showAllButtons];
  [self removeAllAnimations];
  
  _uiType = type;
}

#pragma mark -
#pragma mark Lifecycle
- (void)viewDidLoad {
  [super viewDidLoad];
  
  //Open UDP connection
  _retryConnection = 5;
  [self openUDPConnection];
  
  self.uiType = _segueData;
  
  [_uiSegment setSelectedSegmentIndex:(self.uiType - 1)];
}

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  if (savedSate != UITypeNone) {
    self.uiType = savedSate;
  }
}

-(void)viewWillDisappear:(BOOL)animated {
  if (_uiType == UITypeAccelerator) {
    [self stopAccelerator];
  } else if (_uiType == UITypeJoystick) {
    [self.view removeSwipeGestures];
    [self.view removeTapGestures];
    self.view.gestureDelegate = nil;;
  }
  
  savedSate = _uiType;
  
  [super viewWillDisappear:animated];
}


#pragma mark -
#pragma mark UDP
//Init
-(void)openUDPConnection {
  static NSInteger retryCounter = 0;
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
    [UDPManager openConnectionForData:_ipAddress
                              udpPort:_udpPort
                           resendTime:_sentFreq
                           completion:^(NSError * err) {
                             if (err) {
                               NSLog(@"Error in opening connection. err = %@", err);
                               retryCounter++;
                               if (retryCounter < _retryConnection) {
                                 return [self openUDPConnection];
                               }
                             } else {
                               //First command sent is stop
                               [self sendNextCommandToSatellite:SatelliteCommandStop];
                             }
                           }];
  });
}

-(void)sendNextCommandToSatellite:(SatelliteCommand)cmd {
  SendPacketModel *p = [SendPacketModel newWithMessage:cmdToString(cmd)];
  [UDPManager sendPacket:p];
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

-(void)addAllHoldGestures {
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
-(void)leftPressed {
  [self.view addTapGestures];
  [self sendNextCommandToSatellite:SatelliteCommandLeft];
}

-(void)rightPressed {
  [self.view addTapGestures];
  [self sendNextCommandToSatellite:SatelliteCommandRight];
}

-(void)upPressed {
  [self.view addTapGestures];
  [self sendNextCommandToSatellite:SatelliteCommandUp];
}

-(void)downPressed {
  [self.view addTapGestures];
  [self sendNextCommandToSatellite:SatelliteCommandDown];
}

-(void)handleSingleTap:(UIView *)view {
  
  if ([self.view isEqual:view]) {
    [_upArrow setUserInteractionEnabled:YES];
    [_downArrow setUserInteractionEnabled:YES];
    [_leftArrow setUserInteractionEnabled:YES];
    [_rightArrow setUserInteractionEnabled:YES];
    [self removeAllAnimations];
    
    [self sendNextCommandToSatellite:SatelliteCommandStop];
    
    [self showAllButtons];
  }
}

-(void)handleHold:(UIButton *)sender {
  if (sender == _rotateLeft) {
    [self sendNextCommandToSatellite:SatelliteCommandRotateLeft];
  } else if (sender == _rotateRight) {
    [self sendNextCommandToSatellite:SatelliteCommandRotateRight];
  } else if ([_leftArrow isEqual:sender]) {
    [_leftArrow setUserInteractionEnabled:NO];
    [self leftPressed];
  } else if ([_rightArrow isEqual:sender]) {
    [_rightArrow setUserInteractionEnabled:NO];
    [self rightPressed];
  }else if ([_upArrow isEqual:sender]) {
    [_upArrow setUserInteractionEnabled:NO];
    [self upPressed];
  }else if ([_downArrow isEqual:sender]) {
    [_downArrow setUserInteractionEnabled:NO];
    [self.view removeSwipeGestures];
    [self downPressed];
  }
}

-(void)handleRelease:(UIButton *)sender {
  
}

#pragma mark -
#pragma mark Accelerator
-(void)startAccelerator {
  [MovementManager shared].delegate = self;
  [[MovementManager shared] start];
}

-(void)stopAccelerator {
  [[MovementManager shared] stop];
}

#pragma mark -
#pragma mark MovementDelegate
-(void)repeatinglySend:(SatelliteCommand)cmd {
  __block NSUUID *blockCurrent = [NSUUID new];
  __block SatelliteCommand blockCMD = cmd;
  _currentMovementID = blockCurrent;
  [self sendNextCommandToSatellite:cmd];
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([_sentFreq doubleValue]/1000 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    if (blockCurrent == _currentMovementID) {
      if (blockCMD != SatelliteCommandStop) {
        [self repeatinglySend:blockCMD];
      }
    }
  });
}
-(void)movementOccured:(SatelliteCommand)cmd {
  [self repeatinglySend:cmd];
  [self updateUI:cmd];
}

-(void)updateUI:(SatelliteCommand)cmd {
  UIButton *shaker;
  SEL f;
  switch (cmd) {
    case SatelliteCommandStop:
      [self removeAllAnimations];
      [self showAllButtons];
      shaker = nil;
      f = NULL;
      break;
    case SatelliteCommandUp:
      [self hideButtonsExcept:ButtonTypeUp];
      shaker = _upArrow;
      f = @selector(shakeUpArrow);
      break;
    case SatelliteCommandLeft:
      [self hideButtonsExcept:ButtonTypeLeft];
      shaker = _leftArrow;
      f = @selector(shakeLeftArrowFromCenter);
      break;
    case SatelliteCommandRight:
      [self hideButtonsExcept:ButtonTypeRight];
      shaker = _rightArrow;
      f = @selector(shakeRightArrowFromCenter);
      break;
    case SatelliteCommandDown:
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
    self.uiType = UITypeAccelerator;
  } else if (_uiSegment.selectedSegmentIndex == 1) {
    self.uiType = UITypeJoystick;
  }
}

#pragma mark -
#pragma mark CustomCommandVC display
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSNumber *)sender {
  if ([segue.destinationViewController isKindOfClass:[CustomCommandVC class]]) {
    
  }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches
           withEvent:(UIEvent *)event {
  UITouch *touch= [touches anyObject];
  if ([touch view] == self.view && touches.count > 1)
  {
    //More than two finger touched the screen, load configurator
    [self performSegueWithIdentifier:@"CustomCommandVC" sender:nil];
  }
}

#pragma mark -
#pragma mark LocationVC display


@end
