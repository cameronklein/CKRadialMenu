//
//  CKRadialMenuDelegate.h
//  CKRadialMenu
//
//  Created by Cameron Klein on 12/7/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CKRadialView;

@protocol CKRadialMenuDelegate <NSObject>

@optional

-(void)radialMenu:(CKRadialView *)radialMenu didSelectPopoutWithIndentifier: (NSString *) identifier;

-(BOOL)radialMenuShouldExpand:(CKRadialView *)radialMenu;
-(void)radialMenuDidExpand:(CKRadialView *)radialMenu;

-(BOOL)radialMenuShouldRetract:(CKRadialView *)radialMenu;
-(void)radialMenuDidRetract:(CKRadialView *)radialMenu;

@end
