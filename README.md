CKRadialMenu
============

An iOS framework for customizable radial popout menus.

Features
-------
* Easy to use - setup a basic radial menu in just a few lines of code.
* Works out of the box or customize to your heart's content.
* Full featured delegate protocol to react to or interrupt interactions.
* Interactive development mode - adjust menu inside your own app in real time

Preview
-------
![Preview](https://github.com/cameronklein/CKRadialMenu/blob/master/CKRadialMenu/CKRadialMenu.gif)

Installation
-------
Simply drag *CKRadialMenu.h* and *CKRadialMenu.m* into your project.

Cocoa pod support coming soon.

Setup
------
This sample setup initalizes the main view and two popout views -- one default and one custom.

    // Frame in initWithFrame will be the frame of the initial "center view"
    CKRadialMenu *radialMenu = [CKRadialMenu alloc] initWithFrame: CGRectMake(20,20,50,50)];
    
    // Add popout with nil parameter for default circle
    [radialMenu addPopoutView: nil withIdentifier:@"LOGIN"];
    
    // Or bring your own popout views!
    UIImageView *chat = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat"]];
    [radialMenu addPopoutView: foo withIdentifier:@"CHAT"];
    
Use
----
By default, the radial menu expands and retracts with a tap on the center view. You can override this by using radialMenuShouldExpand: or radialMenuShouldRetract: methods of the delegate.

If you want to expand or contract at some other time, simply call:

    [radialMenu expand];
    [radialMenu retract];
    
To get a popout view after you've set it, call:

    [radialView getPopoutViewWithIdentifier:@"Foo"];
    
This is useful to add/change labels to your view to react to changes in state.

CKRadialMenu comes with a few properties to change animations. See development mode below for interactive demonstration inside your app

**Properties:**

    // Distance from center of centerView and center of popoutViews
    CGFloat distanceFromCenter

    // Distance between popout views, in degrees
    CGFloat distanceBetweenPopouts;
    
    // Angle at which the first popout view exists, in degrees
    // 0 = straight up
    CGFloat startAngle;
    
    // Animation time in seconds
    CGFloat animationDuration;
    
    // Time in seconds to stagger the animation of popout views
    // At zero, all popout views will popout at once
    NSTimeInterval stagger;

CKRadialMenuDelegate
------
  Delegate has the following optional methods:
  
    -(void)radialMenu:(CKRadialView *)radialMenu didSelectPopoutWithIndentifier: (NSString *) identifier;
   
    -(BOOL)radialMenuShouldExpand:(CKRadialView *)radialMenu;
    -(void)radialMenuDidExpand:(CKRadialView *)radialMenu;
   
    -(BOOL)radialMenuShouldRetract:(CKRadialView *)radialMenu;
    -(void)radialMenuDidRetract:(CKRadialView *)radialMenu;

Development Mode
-----------

![Development Mode](https://github.com/cameronklein/CKRadialMenu/blob/master/CKRadialMenu/MKRadialMenuDevMode.gif)

By activating development mode, you can play with the positioning of popout views inside your own app. Invoke development mode **in viewDidAppear or later.**

    [radialMenu enableDevelopmentMode];
    
Once you have the perfect layout, simply plug the numbers into the correct properties of your radial menu.

Author
-------
Cameron Klein
