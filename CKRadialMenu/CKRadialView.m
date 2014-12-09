//
//  CKRadialView.m
//  CKRadialMenu
//
//  Created by Cameron Klein on 12/7/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

#import "CKRadialView.h"

@interface CKRadialView()

@property (nonatomic, strong) NSMutableDictionary *poputIDs;
@property (nonatomic, strong) UIView *positionView;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *distanceBetweenLabel;
@property (nonatomic, strong) UILabel *angleLabel;
@property (nonatomic, strong) UILabel *staggerLabel;

@end

@implementation CKRadialView

#pragma mark Initalizer

-(id)initWithCoder:(NSCoder *)aDecoder{
  NSLog(@"InitWithCoderCalled");
  return self;
}

-(instancetype)init{
  NSLog(@"InitWithCoderCalled");
  return self;
}

- (id)initWithFrame:(CGRect)frame
{
  NSLog(@"InitWithFrameCalled");
  self = [super initWithFrame:frame];
  if (self) {
    self.popoutViews = [NSMutableArray new];
    self.poputIDs = [NSMutableDictionary new];
    self.menuIsExpanded = false;
    self.centerView = [self makeDefaultCenterView];
    self.centerView.frame = self.bounds;
    self.distanceBetweenPopouts = 45;
    self.distanceFromCenter = 55;
    self.stagger = 0.06;
    [self addSubview:self.centerView];
  }
  return self;
}

#pragma mark Setters

- (void) setCenterView:(UIView *)centerView {
  if (!centerView) {
    centerView = [self makeDefaultCenterView];
  }
  _centerView = centerView;
  UIGestureRecognizer *tap = [UITapGestureRecognizer new];
  [tap addTarget:self action:@selector(didTapCenterView:)];
  [self.centerView addGestureRecognizer:tap];
}

#pragma mark Gesture Recognizers

- (void) didTapCenterView: (UITapGestureRecognizer *) sender {
  if (self.menuIsExpanded) {
    [self retract];
  } else {
    [self expand];
  }
}

- (void) expand {
  NSInteger i = 0;
  for (UIView *subView in self.popoutViews) {
    subView.alpha = 0;
    [UIView animateWithDuration:0.4
                          delay:self.stagger*i
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.4
                        options:UIViewAnimationOptionAllowUserInteraction animations:^{
                          subView.alpha = 1;
                          subView.transform = [self getTransformForPopupViewAtIndex:i];
                        } completion:^(BOOL finished) {
                          
                        }];
    i++;
  }
  self.menuIsExpanded = true;
}

- (void) retract {
  NSInteger i = 0;
  for (UIView *subView in self.popoutViews) {
    
    [UIView animateWithDuration:0.4
                          delay:self.stagger*i
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.4
                        options:UIViewAnimationOptionAllowUserInteraction animations:^{
                          subView.transform = CGAffineTransformIdentity;
                        } completion:^(BOOL finished) {
                          
                        }];
    i++;
  }
  self.menuIsExpanded = false;
}

- (void) didTapPopoutView: (UITapGestureRecognizer *) sender {
  UIView *view = sender.view;
  NSString * key = [self.poputIDs allKeysForObject:view][0];
  [self.delegate radialMenu:self didSelectPopoutWithIndentifier:key];
}

#pragma mark Add Popout View

- (void) addPopoutView: (UIView *) popoutView withIndentifier: (NSString *) identifier {
  if (!popoutView){
    popoutView = [self makeDefaultPopupView];
  }
  [self.popoutViews addObject:popoutView];
  [self.poputIDs setObject:popoutView forKey:identifier];
  UIGestureRecognizer *tap = [UITapGestureRecognizer new];
  [tap addTarget:self action:@selector(didTapPopoutView:)];
  [popoutView addGestureRecognizer:tap];
  
  [self addSubview:popoutView];
  [self sendSubviewToBack:popoutView];
  popoutView.center = CGPointMake(self.bounds.origin.x + self.bounds.size.width/2,self.bounds.origin.y + self.bounds.size.height/2);
}

#pragma mark Make Default Views

- (UIView *) makeDefaultCenterView {
  UIView *view = [UIView new];
  view.layer.cornerRadius = self.frame.size.width/2;
  view.backgroundColor = [UIColor redColor];
  view.layer.shadowColor = [[UIColor blackColor] CGColor];
  view.layer.shadowOpacity = 0.6;
  view.layer.shadowRadius = 2.0;
  view.layer.shadowOffset = CGSizeMake(0, 3);
  return view;
}

- (UIView *) makeDefaultPopupView {
  UIView *view = [UIView new];
  view.frame = CGRectMake(0, 0, self.frame.size.width/1.5, self.frame.size.height / 1.5);
  view.layer.cornerRadius = view.frame.size.width/2;
  view.backgroundColor = [UIColor blueColor];
  view.layer.shadowColor = [[UIColor blackColor] CGColor];
  view.layer.shadowOpacity = 0.6;
  view.layer.shadowRadius = 3.0;
  view.layer.shadowOffset = CGSizeMake(0, 3);
  return view;
}

#pragma mark Helper Methods

- (CGAffineTransform) getTransformForPopupViewAtIndex: (NSInteger) index {
  CGFloat newAngle = self.startAngle + (self.distanceBetweenPopouts * index);
  NSLog(@"%f", newAngle);
  CGFloat deltaY = -self.distanceFromCenter * cos(newAngle/ 180.0 * M_PI);
  CGFloat deltaX = self.distanceFromCenter * sin(newAngle/ 180.0 * M_PI);
  return CGAffineTransformMakeTranslation(deltaX, deltaY);
  
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
  if (CGRectContainsPoint(self.bounds, point)) {
    return true;
  }
  for (UIView *subView in self.popoutViews) {
    if (CGRectContainsPoint(subView.frame, point)) {
      return true;
    }
  }
  return false;
}

- (void) enablePositioningMode {
  
  UIView *positionView = [UIView new];
  CGRect screenRect = [UIScreen mainScreen].bounds;
  positionView.frame = CGRectMake(screenRect.origin.x, screenRect.origin.y, screenRect.size.width,100);
  [[[[UIApplication sharedApplication] delegate] window] addSubview:positionView];
  [[[[UIApplication sharedApplication] delegate] window] bringSubviewToFront:positionView];
  positionView.backgroundColor = [UIColor greenColor];
  
  self.distanceLabel = [UILabel new];
  self.distanceLabel.frame = CGRectMake(10, 20, 300, 20);
  [positionView addSubview:self.distanceLabel];
  self.distanceLabel.text = [NSString stringWithFormat:@"Distance From Center: %.02f", self.distanceFromCenter];
  self.distanceLabel.font = [UIFont fontWithName:@"Avenir" size:14];
  
  self.angleLabel = [UILabel new];
  self.angleLabel.frame = CGRectMake(10, 40, 300, 20);
  [positionView addSubview:self.angleLabel];
  self.angleLabel.text = [NSString stringWithFormat:@"Start Angle: %.02f", self.startAngle];
  self.angleLabel.font = [UIFont fontWithName:@"Avenir" size:14];
  
  self.distanceBetweenLabel = [UILabel new];
  self.distanceBetweenLabel.frame = CGRectMake(10, 60, 200, 20);
  [positionView addSubview:self.distanceBetweenLabel];
  self.distanceBetweenLabel.text = [NSString stringWithFormat:@"Distance Between: %.02f", self.distanceBetweenPopouts];
  self.distanceBetweenLabel.font = [UIFont fontWithName:@"Avenir" size:14];
  UISlider *distanceSlider = [UISlider new];
  distanceSlider.frame = CGRectMake(300, 60, self.positionView.bounds.size.width - 100, 20);
  [positionView addSubview:distanceSlider];
  distanceSlider.maximumValue = 180;
  distanceSlider.minimumValue = 0;
  distanceSlider.value = self.distanceBetweenPopouts;
  [distanceSlider addTarget:self action:@selector(distanceSliderChanged:) forControlEvents:UIControlEventValueChanged];
  
  self.staggerLabel = [UILabel new];
  self.staggerLabel.frame = CGRectMake(10, 80, 200, 20);
  [positionView addSubview:self.staggerLabel];
  self.staggerLabel.text = [NSString stringWithFormat:@"Stagger in Seconds: %.02f", self.stagger];
  self.staggerLabel.font = [UIFont fontWithName:@"Avenir" size:14];
  UISlider *staggerSlider = [UISlider new];
  staggerSlider.frame = CGRectMake(300, 80, self.positionView.bounds.size.width - 100, 20);
  [positionView addSubview:staggerSlider];
  staggerSlider.maximumValue = 1;
  staggerSlider.minimumValue = 0;
  staggerSlider.value = self.distanceBetweenPopouts;
  [staggerSlider addTarget:self action:@selector(staggerSliderChanged:) forControlEvents:UIControlEventValueChanged];
  
  
  for (UIView *subView in self.popoutViews) {
    [subView removeGestureRecognizer:[subView gestureRecognizers][0]];
    UIPanGestureRecognizer *panner = [UIPanGestureRecognizer new];
    [panner addTarget:self action:@selector(didPanPopout:)];
    [subView addGestureRecognizer:panner];
  }
  
}

-(void) didPanPopout:(UIPanGestureRecognizer *)sender {
  UIView *view = sender.view;
  CGPoint point = [sender locationInView:self];
  CGFloat centerX = self.bounds.origin.x + self.bounds.size.width/2;
  CGFloat centerY = self.bounds.origin.y + self.bounds.size.height/2;
  if (sender.state == UIGestureRecognizerStateChanged) {
    
    // Do Calculations
    CGFloat deltaX = point.x - centerX;
    CGFloat deltaY = point.y - centerY;
    CGFloat angle = atan2(deltaX, -deltaY) * 180.0 / M_PI ;
    CGFloat distanceFromCenter = sqrt(pow(point.x - centerX, 2) + pow(point.y - centerY, 2));
    
    // Assign Results
    self.distanceFromCenter = distanceFromCenter;
    self.startAngle = angle;
    
    // Change Labels
    self.distanceLabel.text = [NSString stringWithFormat:@"Distance From Center: %.02f", self.distanceFromCenter];
    self.angleLabel.text = [NSString stringWithFormat:@"Start Angle: %.02f", angle];
    
    // Change Position of Views
    view.center = point;
    view.transform = CGAffineTransformIdentity;

    NSInteger i = 0;
    for (UIView *subView in self.popoutViews) {
      if (subView != view) {
        subView.transform = [self getTransformForPopupViewAtIndex:i];
      }
      i++;
    }
    
  } else if (sender.state == UIGestureRecognizerStateEnded) {
    view.center = CGPointMake(centerX, centerY);
    NSInteger i = 0;
    for (UIView *subView in self.popoutViews) {
        subView.transform = [self getTransformForPopupViewAtIndex:i];
      i++;
    }
  }
}

- (void)distanceSliderChanged:(UISlider *)sender {
  if (!self.menuIsExpanded){
    [self expand];
  }
  self.distanceBetweenPopouts = sender.value;
  self.distanceBetweenLabel.text = [NSString stringWithFormat:@"Distance Between: %.02f", self.distanceBetweenPopouts];
  NSInteger i = 0;
  for (UIView *subView in self.popoutViews) {
    subView.transform = [self getTransformForPopupViewAtIndex:i];
    i++;
  }
}

- (void)staggerSliderChanged:(UISlider *)sender {
  self.stagger = sender.value;
  self.staggerLabel.text = [NSString stringWithFormat:@"Stagger In Seconds: %.02f", self.stagger];
}

@end
