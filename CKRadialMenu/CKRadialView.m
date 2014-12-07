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

- (instancetype)init
{
  self = [super init];
  if (self) {
    self.menuIsExpanded = false;
    self.centerView = [UIView new];
    self.centerView.frame = self.frame;
    [self addSubview:self.centerView];
  }
  return self;
}

#pragma mark Setters

- (void) setCenterView:(UIView *)centerView {
  _centerView = centerView;
  UIGestureRecognizer *tap = [UITapGestureRecognizer new];
  [tap addTarget:self action:@selector(didTapCenterView:)];
  [centerView addGestureRecognizer:tap];
}

#pragma mark Gesture Recognizers

- (void) didTapCenterView: (UITapGestureRecognizer *) sender {
  if (self.menuIsExpanded) {
    
  } else {
    NSInteger i = 0;
    for (UIView *subView in self.popoutViews) {
      [self addSubview:subView];
      subView.center = self.center;
      [UIView animateWithDuration:0.4
                            delay:0.0
           usingSpringWithDamping:0.7
            initialSpringVelocity:0.4
                          options:UIViewAnimationOptionAllowUserInteraction animations:^{
                            subView.transform = [self getTransformForPopupViewAtIndex:i];
                          } completion:^(BOOL finished) {
                          
                          }];
      i++;
    }
  }
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
}

#pragma mark Make Default Views

- (UIView *) makeDefaultCenterView {
  UIView *view = [UIView new];
  view.frame = self.frame;
  view.layer.cornerRadius = self.frame.size.width/2;
  return view;
  
}

- (UIView *) makeDefaultPopupView {
  UIView *view = [UIView new];
  view.frame = CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height / 2);
  view.layer.cornerRadius = self.frame.size.width/2;
  return view;
}

- (CGAffineTransform) getTransformForPopupViewAtIndex: (NSInteger) index {
  
  CGFloat deltaX = self.distanceFromCenter * cos(self.startAngle + (self.distanceBetweenPopouts * index));
  CGFloat deltaY = self.distanceFromCenter * sin(self.startAngle + (self.distanceBetweenPopouts * index));
  
  return CGAffineTransformMakeTranslation(deltaX, deltaY);
  
}

@end
