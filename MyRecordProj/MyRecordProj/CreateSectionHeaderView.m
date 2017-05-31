//
//  CreateSectionHeaderView.m
//  MyRecordProj
//
//  Created by  qin on 2017/5/28.
//  Copyright © 2017年  qin. All rights reserved.
//

#import "CreateSectionHeaderView.h"
#import "MyCommonHeaders.h"

@implementation CreateSectionHeaderView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.btnCategory.lineBreakMode=NSLineBreakByTruncatingTail;
    
    self.bkgView.layer.masksToBounds=true;
    self.bkgView.layer.cornerRadius=5.0;
    self.bkgView.layer.borderWidth=1;
    self.bkgView.layer.borderColor=[[MyColor defBackgroundColor] CGColor];
}

- (IBAction)btnCategoryTapped:(id)sender {
    if (nil != self.headerActionDelegate && [self.headerActionDelegate respondsToSelector:@selector(headerButtonDidTappedWithButton:)]) {
        [self.headerActionDelegate headerButtonDidTappedWithButton:self.btnCategory];
    }
}
@end
