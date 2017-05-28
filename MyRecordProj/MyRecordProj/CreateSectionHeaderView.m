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
    
    self.layer.masksToBounds=true;
    self.layer.cornerRadius=5.0;
    self.layer.borderWidth=1;
    self.layer.borderColor=[[MyColor defBackgroundColor] CGColor];
}

- (IBAction)btnCategoryTapped:(id)sender {
    if (nil != self.headerActionDelegate && [self.headerActionDelegate respondsToSelector:@selector(headerButtonDidTappedWithButton:)]) {
        [self.headerActionDelegate headerButtonDidTappedWithButton:self.btnCategory];
    }
}
@end
