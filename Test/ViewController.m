//
//  ViewController.m
//  RadialMenuTest
//
//  Created by Cameron Klein on 12/7/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  NSLog(@"View did load called");
  
  //radialView.backgroundColor = [UIColor blueColor];
}

-(void) viewWillAppear:(BOOL)animated {
  
}

-(void)viewDidAppear:(BOOL)animated {
  NSLog(@"View did appear called");
  [super viewDidAppear:animated];
  CKRadialView *radialView = [[CKRadialView alloc] initWithFrame:CGRectMake(100, 300, 40, 40)];
  radialView.delegate = self;
  //radialView.stagger = 0.5;
  [radialView addPopoutView:nil withIndentifier:@"ONE"];
  [radialView addPopoutView:nil withIndentifier:@"TWO"];
  [radialView addPopoutView:nil withIndentifier:@"THREE"];
  [self.view addSubview:radialView];
  [radialView enablePositioningMode];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

-(void)radialMenu:(CKRadialView *)radialMenu didSelectPopoutWithIndentifier:(NSString *)identifier{
  NSLog(@"DELEGATE CALLED");
  
}

@end
