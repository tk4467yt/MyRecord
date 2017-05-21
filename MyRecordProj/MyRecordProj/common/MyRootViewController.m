//
//  MyRootViewController.m
//  xbb
//
//  Created by  qin on 2017/3/5.
//  Copyright © 2017年  qin. All rights reserved.
//

#import "MyRootViewController.h"

@interface MyRootViewController ()
@property (nonatomic,assign) CGFloat kbHeight;
@end

@implementation MyRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([self isBeingDismissed] || [self isMovingFromParentViewController]) {
        [[MyCustomNotificationObserver sharedObserver] removeCustomObserverForDelegate:self andKey:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    self.kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    [self actionForKeyboardHeightDidChange];
    
}
- (void)keyboardWillHide:(NSNotification *)info
{
    self.kbHeight=0;
    
    [self actionForKeyboardHeightDidChange];
}
- (void)actionForKeyboardHeightDidChange
{
    NSLog(@"keyboard height did change to: %f",self.kbHeight);
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
