//
//  MyRootViewController.h
//  xbb
//
//  Created by  qin on 2017/3/5.
//  Copyright © 2017年  qin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCustomNotificationObserver.h"

@interface MyRootViewController : UIViewController <MyCustomNotificationActionDelegate>
@property (nonatomic,assign) CGFloat kbHeight;

-(void)screenOrientationChangedHandle;

- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)info;
- (void)actionForKeyboardHeightDidChange;
@end
