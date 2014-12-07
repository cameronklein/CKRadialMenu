//
//  CKRadialView.m
//  CKRadialMenu
//
//  Created by Cameron Klein on 12/7/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

#import "CKRadialView.h"

@implementation CKRadialView

- (instancetype)init
{
  self = [super init];
  if (self) {
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
  
}

- (void) didTapPopoutView (UIView) {
  
}

#pragma mark Adders

- (void) addPopoutView: (UIView *) popoutView {
  [self.popoutViews addObject:popoutView];
  UIGestureRecognizer *tap = [UITapGestureRecognizer new];
  [tap addTarget:self action:@selector(didTapPopoutView:)];
  [popoutView addGestureRecognizer:tap];
  
}

@end
