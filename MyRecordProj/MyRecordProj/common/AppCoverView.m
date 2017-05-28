//
//  AppCoverView.m
//  MyRecordProj
//
//  Created by  qin on 2017/5/26.
//  Copyright © 2017年  qin. All rights reserved.
//

#import "AppCoverView.h"
#import "MyCommonHeaders.h"

static __strong AppCoverView *retainedCoverView;

@implementation AppCoverView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor= [UIColor lightGrayColor];
    
    self.lblContent.text=@"";
    self.contentContainer.layer.masksToBounds=true;
    self.contentContainer.layer.cornerRadius = 10;
}

+(AppCoverView *)getAppCoverView
{
    if (nil == retainedCoverView) {
        NSArray *topLevelObject = [[NSBundle mainBundle] loadNibNamed:@"AppCoverView" owner:nil options:nil];
        retainedCoverView = [topLevelObject objectAtIndex:0];
    }
    
    return retainedCoverView;
}

-(void)showInView:(UIView *)parentView withText:(NSString *)txt2show
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:GLOBAL_ALERT_WILL_APPEAR object:nil];
    
    [parentView addSubview:self];
    
    self.lblContent.text=txt2show;
    if ([MyUtility appFollowSystemDynamicType]) {
        self.lblContent.font = [UIFont systemFontOfSize:[MyUtility getFontPointSizeForDynamicTypeTextWithOriginalSize:14]];
    } else {
        self.lblContent.font = [UIFont systemFontOfSize:14];
    }
    
    self.frame=CGRectMake(0, 0, parentView.frame.size.width, parentView.frame.size.height);
    [self setNeedsUpdateConstraints];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}

-(void)hideFromSuperView
{
    [self removeFromSuperview];
    
    retainedCoverView=nil;
    
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

+(BOOL)isAppCoverViewShown
{
    return nil != retainedCoverView && nil != retainedCoverView.superview;
}

@end
