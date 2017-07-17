//
//  CKRadialView.m
//  CKRadialMenu
//
//  Created by Cameron Klein on 12/7/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

#import "CKRadialMenu.h"

@interface CKRadialMenu()

@property (nonatomic, strong) NSMutableDictionary *poputIDs;
@property (nonatomic, strong) UIView *positionView;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *distanceBetweenLabel;
@property (nonatomic, strong) UILabel *angleLabel;
@property (nonatomic, strong) UILabel *staggerLabel;
@property (nonatomic, strong) UILabel *animationLabel;

@end

@implementation CKRadialMenu

#pragma mark Initalizer

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self doInitialSetup];
    return self;
}

-(instancetype)init {
    self = [self initWithFrame:CGRectZero];
    [self doInitialSetup];
    return self;
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self doInitialSetup];
    return self;
}

-(void)doInitialSetup {
    self.popoutViews = [NSMutableArray new];
    self.poputIDs = [NSMutableDictionary new];
    self.isMenuExpanded = false;
    self.startAngle = -75;
    self.distanceBetweenPopouts = 50;
    self.distanceFromCenter = 61;
    self.stagger = 0.06;
    self.animationDuration = 0.4;
    
    self.centerView = [self makeDefaultCenterView];
    self.centerView.frame = self.bounds;
    [self addSubview:self.centerView];
}

#pragma mark Setters
- (void) setCenterView:(UIView *) centerView {
    if (!centerView) {
        centerView = [self makeDefaultCenterView];
    }
    _centerView = centerView;

    UIGestureRecognizer *tap = [UITapGestureRecognizer new];
    [tap addTarget:self action:@selector(didTapCenterView:)];
    [self.centerView addGestureRecognizer:tap];
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.centerView.frame = self.bounds;
    
}

-(void) setGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    _gestureRecognizer = gestureRecognizer;
    
    for (UIGestureRecognizer *gesture in self.centerView.gestureRecognizers) {
        [self.centerView removeGestureRecognizer:gesture];
    }
    
    [self.centerView addGestureRecognizer:_gestureRecognizer];
}


-(void) setMenuBackgroundColor:(UIColor *) menuBackgroundColor {
    _menuBackgroundColor = menuBackgroundColor;
    
    
    self.centerView.backgroundColor = _menuBackgroundColor;
    //TODO: add menubackground color to
}

-(void) setHasShadow:(BOOL)hasShadow {
    _hasShadow = hasShadow;
    
    if (_hasShadow)
        [self addShadowToCenterView];
}

#pragma mark Gesture Recognizers
- (void) didTapCenterView: (UITapGestureRecognizer *) sender {
    if (self.isMenuExpanded) {
        [self retract];
    }
    
    else {
        [self expand];
    }
}

- (void) expand {
    if (![self.delegate respondsToSelector:@selector(radialMenuShouldExpand:)] || [self.delegate radialMenuShouldExpand:self]) {
        NSInteger i = 0;
        for (UIView *subView in self.popoutViews) {
            subView.alpha = 0;
            [UIView animateWithDuration:self.animationDuration
                                  delay:self.stagger*i
                 usingSpringWithDamping:0.7
                  initialSpringVelocity:0.4
                                options:UIViewAnimationOptionAllowUserInteraction animations:^{
                                    subView.alpha = 1;
                                    subView.transform = [self getTransformForPopupViewAtIndex:i];
                                } completion:^(BOOL finished) {
                                    if ([self.delegate respondsToSelector:@selector(radialMenuDidExpand:)]) {
                                        [self.delegate radialMenuDidExpand:self];
                                    }
                                }];
            i++;
        }
        self.isMenuExpanded = true;
    }
}

- (void) retract {
    if (![self.delegate respondsToSelector:@selector(radialMenuShouldRetract:)] || [self.delegate radialMenuShouldRetract:self]) {
        NSInteger i = 0;
        for (UIView *subView in self.popoutViews) {
            
            [UIView animateWithDuration:self.animationDuration
                                  delay:self.stagger*i
                 usingSpringWithDamping:0.7
                  initialSpringVelocity:0.4
                                options:UIViewAnimationOptionAllowUserInteraction animations:^{
                                    subView.transform = CGAffineTransformIdentity;
                                    subView.alpha = 0;
                                } completion:^(BOOL finished) {
                                    if ([self.delegate respondsToSelector:@selector(radialMenuDidRetract:)]) {
                                        [self.delegate radialMenuDidRetract:self];
                                    }
                                }];
            i++;
        }
        self.isMenuExpanded = false;
    }
}

- (void) didTapPopoutView: (UITapGestureRecognizer *) sender {
    UIView *view = sender.view;
    NSString * key = [self.poputIDs allKeysForObject:view][0];
    [self.delegate radialMenu:self didSelectPopoutWithIndentifier:key];
}

#pragma mark Popout Views

- (void) addPopoutView: (UIView *) popoutView withIndentifier: (NSString *) identifier {
    if (!popoutView){
        popoutView = [self makeDefaultPopupView];
    }
    [self.popoutViews addObject:popoutView];
    [self.poputIDs setObject:popoutView forKey:identifier];
    UIGestureRecognizer *tap = [UITapGestureRecognizer new];
    [tap addTarget:self action:@selector(didTapPopoutView:)];
    [popoutView addGestureRecognizer:tap];
    popoutView.alpha = 0;
    [self addSubview:popoutView];
    [self sendSubviewToBack:popoutView];
    popoutView.center = CGPointMake(self.bounds.origin.x + self.bounds.size.width/2,self.bounds.origin.y + self.bounds.size.height/2);
}

-(UIView *)getPopoutViewWithIndentifier:(NSString *)identifier {
    
    return [self.poputIDs objectForKey:identifier];
    
}

#pragma mark Make Default Views

- (UIView *) makeDefaultCenterView {
    UIView *view = [UIView new];
    view.layer.cornerRadius = self.frame.size.width/2;
    view.backgroundColor = [UIColor redColor];
    
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

-(void) addShadowToCenterView {
    self.centerView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.centerView.layer.shadowOpacity = 0.6;
    self.centerView.layer.shadowRadius = 2.0;
    self.centerView.layer.shadowOffset = CGSizeMake(0, 3);
}

- (CGAffineTransform) getTransformForPopupViewAtIndex: (NSInteger) index {
    CGFloat newAngle = self.startAngle + (self.distanceBetweenPopouts * index);
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

- (void) enableDevelopmentMode {
    
    UIView *positionView = [UIView new];
    CGRect screenRect = [UIScreen mainScreen].bounds;
    positionView.frame = CGRectMake(screenRect.origin.x, screenRect.origin.y, screenRect.size.width,110);
    [[[[UIApplication sharedApplication] delegate] window] addSubview:positionView];
    [[[[UIApplication sharedApplication] delegate] window] bringSubviewToFront:positionView];
    
    self.distanceLabel = [UILabel new];
    self.distanceLabel.frame = CGRectMake(10, 20, 300, 20);
    [positionView addSubview:self.distanceLabel];
    self.distanceLabel.text = [NSString stringWithFormat:@"Distance From Center: %.02f", self.distanceFromCenter];
    self.distanceLabel.font = [UIFont fontWithName:@"Avenir" size:16];
    
    self.angleLabel = [UILabel new];
    self.angleLabel.frame = CGRectMake(10, 40, 300, 20);
    [positionView addSubview:self.angleLabel];
    self.angleLabel.text = [NSString stringWithFormat:@"Start Angle: %.02f", self.startAngle];
    self.angleLabel.font = [UIFont fontWithName:@"Avenir" size:16];
    
    self.distanceBetweenLabel = [UILabel new];
    self.distanceBetweenLabel.frame = CGRectMake(10, 60, 200, 20);
    [positionView addSubview:self.distanceBetweenLabel];
    self.distanceBetweenLabel.text = [NSString stringWithFormat:@"Distance Between: %.02f", self.distanceBetweenPopouts];
    self.distanceBetweenLabel.font = [UIFont fontWithName:@"Avenir" size:16];
    UISlider *distanceSlider = [UISlider new];
    distanceSlider.frame = CGRectMake(200, 60, screenRect.size.width - 225, 20);
    [positionView addSubview:distanceSlider];
    distanceSlider.maximumValue = 180;
    distanceSlider.minimumValue = 0;
    distanceSlider.value = self.distanceBetweenPopouts;
    [distanceSlider addTarget:self action:@selector(distanceSliderChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.staggerLabel = [UILabel new];
    self.staggerLabel.frame = CGRectMake(10, 100, 200, 20);
    [positionView addSubview:self.staggerLabel];
    self.staggerLabel.text = [NSString stringWithFormat:@"Stagger in Seconds: %.02f", self.stagger];
    self.staggerLabel.font = [UIFont fontWithName:@"Avenir" size:16];
    UISlider *staggerSlider = [UISlider new];
    staggerSlider.frame = CGRectMake(200, 100, screenRect.size.width - 225, 20);
    [positionView addSubview:staggerSlider];
    staggerSlider.maximumValue = 1;
    staggerSlider.minimumValue = 0;
    staggerSlider.value = self.stagger;
    [staggerSlider addTarget:self action:@selector(staggerSliderChanged:) forControlEvents:UIControlEventValueChanged];
    
    for (UIView *subView in self.popoutViews) {
        //[subView removeGestureRecognizer:[subView gestureRecognizers][0]];
        UIPanGestureRecognizer *panner = [UIPanGestureRecognizer new];
        [panner addTarget:self action:@selector(didPanPopout:)];
        [subView addGestureRecognizer:panner];
    }
    
}

-(void) didPanPopout:(UIPanGestureRecognizer *)sender {
    UIView *view = sender.view;
    NSInteger i = [self.popoutViews indexOfObject:view];
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
        self.startAngle = angle - self.distanceBetweenPopouts * i;
        
        // Change Labels
        self.distanceLabel.text = [NSString stringWithFormat:@"Distance From Center: %.02f", self.distanceFromCenter];
        self.angleLabel.text = [NSString stringWithFormat:@"Start Angle: %.02f", self.startAngle];
        
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
    
    if (!self.isMenuExpanded){
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

- (void)durationSliderChanged:(UISlider *)sender {
    self.animationDuration = sender.value;
    self.animationLabel.text = [NSString stringWithFormat:@"Duration In Seconds: %.02f", self.animationDuration];
}


@end
