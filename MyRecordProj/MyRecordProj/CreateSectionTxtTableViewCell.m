//
//  CreateSectionTxtTableViewCell.m
//  MyRecordProj
//
//  Created by  qin on 2017/5/20.
//  Copyright © 2017年  qin. All rights reserved.
//

#import "CreateSectionTxtTableViewCell.h"
#import "MyCommonHeaders.h"

@implementation CreateSectionTxtTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.tvTxtContent.layer.masksToBounds=true;
    self.tvTxtContent.layer.cornerRadius=5.0;
    self.tvTxtContent.layer.borderWidth=1;
    self.tvTxtContent.layer.borderColor=[[MyColor defBackgroundColor] CGColor];
    
    UITapGestureRecognizer *tapGestureImg=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action4DelSection)];
    [self.ivDel addGestureRecognizer:tapGestureImg];
}

- (void)action4DelSection
{
    if (nil != self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(textActionForDelSectionWithCellIndex:)]) {
        [self.actionDelegate textActionForDelSectionWithCellIndex:self.cellIndex];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
