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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([self isBeingDismissed] || [self isMovingFromParentViewController]) {
        [[MyCustomNotificationObserver sharedObserver] removeCustomObserverForDelegate:self andKey:nil];
    }
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

#pragma mark MyCustomNotificationActionDelegate
-(void)didReceivecMyCustomNotification:(NSDictionary *)notificationDict
{
    
}
@end
