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
