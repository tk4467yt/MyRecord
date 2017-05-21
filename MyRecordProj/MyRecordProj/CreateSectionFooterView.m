//
//  CreateSectionFooterView.m
//  MyRecordProj
//
//  Created by  qin on 2017/5/21.
//  Copyright © 2017年  qin. All rights reserved.
//

#import "CreateSectionFooterView.h"

@implementation CreateSectionFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)addBtnDidTap:(id)sender {
    if (nil != self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(footerButtonDidTappedWithButton:)]) {
        [self.actionDelegate footerButtonDidTappedWithButton:self.btnAddSection];
    }
}
@end
