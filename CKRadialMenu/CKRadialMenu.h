//
//  CKRadialView.h
//  CKRadialMenu
//
//  Created by Cameron Klein on 12/7/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CKRadialMenu;
@protocol CKRadialMenuDelegate <NSObject>

@optional

-(void)radialMenu:(CKRadialMenu *)radialMenu didSelectPopoutWithIndentifier: (NSString *) identifier;

-(BOOL)radialMenuShouldExpand:(CKRadialMenu *)radialMenu;
-(void)radialMenuDidExpand:(CKRadialMenu *)radialMenu;

-(BOOL)radialMenuShouldRetract:(CKRadialMenu *)radialMenu;
-(void)radialMenuDidRetract:(CKRadialMenu *)radialMenu;

@end

@interface CKRadialMenu : UIView

- (void) addPopoutView: (UIView *) popoutView withIndentifier: (NSString *) identifier;
- (UIView *) getPopoutViewWithIndentifier: (NSString *) identifier;
- (void) expand;
- (void) retract;
- (void) enableDevelopmentMode;

@property (nonatomic, weak) NSObject<CKRadialMenuDelegate> *delegate;

@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) NSMutableArray *popoutViews;

@property CGFloat popoutViewSize;
@property CGFloat distanceFromCenter;
@property CGFloat distanceBetweenPopouts;
@property CGFloat startAngle;
@property CGFloat animationDuration;
@property NSTimeInterval stagger;

@property (nonatomic, strong) UIColor *menuBackgroundColor; /* if set will override default one */
@property (nonatomic, weak) UIGestureRecognizer *gestureRecognizer; /* if set will override default one */
@property (nonatomic) BOOL hasShadow;
@property BOOL isMenuExpanded;

@end


