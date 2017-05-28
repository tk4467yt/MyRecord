//
//  AppCoverView.h
//  MyRecordProj
//
//  Created by  qin on 2017/5/26.
//  Copyright © 2017年  qin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppCoverView : UIView
@property (weak, nonatomic) IBOutlet UIView *contentContainer;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;

+(AppCoverView *)getAppCoverView;
-(void)showInView:(UIView *)parentView withText:(NSString *)txt2show;
-(void)hideFromSuperView;
+(BOOL)isAppCoverViewShown;
@end
