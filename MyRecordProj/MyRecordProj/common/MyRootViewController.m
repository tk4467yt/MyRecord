//
//  MyRootViewController.m
//  xbb
//
//  Created by  qin on 2017/3/5.
//  Copyright © 2017年  qin. All rights reserved.
//

#import "MyRootViewController.h"

@interface MyRootViewController ()

@end

@implementation MyRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    [self screenOrientationChangedHandle];
}

-(void)screenOrientationChangedHandle
{
    
}

@end
