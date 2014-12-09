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
  CKRadialView *radialView = [[CKRadialView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 -  25, 400, 50, 50)];
  radialView.delegate = self;
  radialView.centerView.backgroundColor = [UIColor grayColor];
  [radialView addPopoutView:nil withIndentifier:@"ONE"];
  UIView *viewOne = [radialView getPopoutViewWithIndentifier:@"ONE"];
  UILabel *labelOne = [[UILabel alloc] init];
  viewOne.backgroundColor = [UIColor blueColor];
  [viewOne addSubview:labelOne];
  [radialView addPopoutView:nil withIndentifier:@"TWO"];
  UIView *viewTwo = [radialView getPopoutViewWithIndentifier:@"TWO"];
  UILabel *labelTwo = [[UILabel alloc] init];
  viewTwo.backgroundColor = [UIColor redColor];
  [viewTwo addSubview:labelTwo];
  [radialView addPopoutView:nil withIndentifier:@"THREE"];
  UIView *viewThree = [radialView getPopoutViewWithIndentifier:@"THREE"];
  UILabel *labelThree = [[UILabel alloc] init];
  viewThree.backgroundColor = [UIColor purpleColor];
  [viewThree addSubview:labelThree];
  [self.view addSubview:radialView];
  [radialView enableDevelopmentMode];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

-(void)radialMenu:(CKRadialView *)radialMenu didSelectPopoutWithIndentifier:(NSString *)identifier{
  NSLog(@"DELEGATE CALLED");
  
}

@end
