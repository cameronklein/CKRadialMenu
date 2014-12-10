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
  CKRadialMenu *radialView = [[CKRadialMenu alloc] initWithFrame:CGRectMake(self.view.center.x-25, self.view.frame.size.height - 70, 50, 50)];
  radialView.delegate = self;
  radialView.centerView.backgroundColor = [UIColor grayColor];
  [radialView addPopoutView:nil withIndentifier:@"ONE"];
  [radialView addPopoutView:nil withIndentifier:@"TWO"];
  [radialView addPopoutView:nil withIndentifier:@"THREE"];
  [radialView addPopoutView:nil withIndentifier:@"FOUR"];
  [self.view addSubview:radialView];
  [radialView enableDevelopmentMode];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

-(void)radialMenu:(CKRadialMenu *)radialMenu didSelectPopoutWithIndentifier:(NSString *)identifier{
  NSLog(@"DELEGATE CALLED");
  
}

@end
