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

-(void)radialMenu:(CKRadialView *)radialMenu didSelectPopoutWithIndentifier: (NSString *) identifier;

@end
