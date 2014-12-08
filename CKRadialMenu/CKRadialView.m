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

@end

@implementation CKRadialView

#pragma mark Initalizer

//- (instancetype)init
//{
//  NSLog(@"Init");
//  self = [super init];
//  if (self) {
//    self.menuIsExpanded = false;
//    self.centerView = [self makeDefaultCenterView];
//    self.centerView.frame = self.frame;
//    [self addSubview:self.centerView];
//  }
//  return self;
//}

- (id)initWithFrame:(CGRect)frame
{
  NSLog(@"Init With Frame");
  self = [super initWithFrame:frame];
  if (self) {
    self.popoutViews = [NSMutableArray new];
    self.poputIDs = [NSMutableDictionary new];
    self.menuIsExpanded = false;
    self.centerView = [self makeDefaultCenterView];
    self.centerView.frame = self.bounds;
    self.distanceBetweenPopouts = 45;
    self.distanceFromCenter = 50;
    [self addSubview:self.centerView];
  }
  return self;
}

#pragma mark Setters

- (void) setCenterView:(UIView *)centerView {
  if (!centerView) {
    centerView = [self makeDefaultCenterView];
  }
  NSLog(@"Setter Called");
  _centerView = centerView;
  UIGestureRecognizer *tap = [UITapGestureRecognizer new];
  [tap addTarget:self action:@selector(didTapCenterView:)];
  [self.centerView addGestureRecognizer:tap];
}

#pragma mark Gesture Recognizers

- (void) didTapCenterView: (UITapGestureRecognizer *) sender {
  NSLog(@"%d", self.menuIsExpanded);
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
                          delay:0.0
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
  for (UIView *subView in self.popoutViews) {
    
    [UIView animateWithDuration:0.4
                          delay:0.0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.4
                        options:UIViewAnimationOptionAllowUserInteraction animations:^{
                          subView.transform = CGAffineTransformIdentity;
                        } completion:^(BOOL finished) {
                          
                        }];
  }
  self.menuIsExpanded = false;
}

- (void) didTapPopoutView: (UITapGestureRecognizer *) sender {
  NSLog(@"Received Tap On Popout");
  UIView *view = sender.view;
  NSString * key = [self.poputIDs allKeysForObject:view][0];
  [self.delegate radialMenu:self didSelectPopoutWithIndentifier:key];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  NSLog(@"%f %f", self.centerView.frame.origin.x, self.centerView.frame.origin.y);
  NSLog(@"%@", self.centerView.backgroundColor.description);
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
  NSLog(@"Making Default Center View");
  UIView *view = [UIView new];
  view.layer.cornerRadius = self.frame.size.width/2;
  view.clipsToBounds = true;
  view.backgroundColor = [UIColor redColor];
  return view;
  
}

- (UIView *) makeDefaultPopupView {
  NSLog(@"Making Default Popup View");
  UIView *view = [UIView new];
  view.frame = CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height / 2);
  view.layer.cornerRadius = view.frame.size.width/2;
  view.backgroundColor = [UIColor blueColor];
  return view;
}

#pragma mark Helper Methods

- (CGAffineTransform) getTransformForPopupViewAtIndex: (NSInteger) index {
  NSLog(@"%f",self.distanceBetweenPopouts);
  NSLog(@"%f",self.distanceBetweenPopouts);
  CGFloat deltaY = -self.distanceFromCenter * cos(self.startAngle + (self.distanceBetweenPopouts * index)/ 180.0 * M_PI);
  CGFloat deltaX = self.distanceFromCenter * sin(self.startAngle + (self.distanceBetweenPopouts * index)/ 180.0 * M_PI);
  NSLog(@"%f %f", deltaX, deltaY);
  return CGAffineTransformMakeTranslation(deltaX, deltaY);
  
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
  
  for (UIView *subView in self.popoutViews) {
    if (CGRectContainsPoint(subView.frame, point)) {
      return true;
    }
  }
  return false;
  
}

@end
