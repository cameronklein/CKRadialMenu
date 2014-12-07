//
//  CKRadialView.h
//  CKRadialMenu
//
//  Created by Cameron Klein on 12/7/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKRadialMenuDataSource.h"
#import "CKRadialMenuDelegate.h"

@interface CKRadialView : UIView <UITableViewDelegate>

@property (nonatomic, strong) NSObject<CKRadialMenuDelegate> *delegate;
@property (nonatomic, strong) NSObject<CKRadialMenuDataSource> *dataSource;
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) NSMutableArray *popoutViews;


@property CGFloat popoutViewSize;
@property CGFloat distanceFromCenter;
@property CGFloat distanceBetweenPopouts;
@property CGFloat startAngle;

@property BOOL menuIsExpanded;

@end
