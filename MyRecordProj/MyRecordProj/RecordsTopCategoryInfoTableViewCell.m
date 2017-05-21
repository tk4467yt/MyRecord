//
//  RecordsTopCategoryInfoTableViewCell.m
//  MyRecordProj
//
//  Created by  qin on 2017/5/20.
//  Copyright © 2017年  qin. All rights reserved.
//

#import "RecordsTopCategoryInfoTableViewCell.h"
#import "MyCommonHeaders.h"

@implementation RecordsTopCategoryInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.backgroundColor=[MyColor defBackgroundColor];
    
    UITapGestureRecognizer *tapGestureLabel=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionForCategoryTap:)];
    [self.lblCategoryName addGestureRecognizer:tapGestureLabel];
    
    UITapGestureRecognizer *tapGestureImg=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionForCategoryTap:)];
    [self.ivActionInd addGestureRecognizer:tapGestureImg];
}

-(void)actionForCategoryTap:(UITapGestureRecognizer *)tapGesture
{
    if (!self.isDefaultCategory && nil != self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(recordTopCategoryInfoDidTapWithCategoryId:fromSourceView:)]) {
        [self.actionDelegate recordTopCategoryInfoDidTapWithCategoryId:self.categoryId fromSourceView:self.ivActionInd];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.isDefaultCategory) {
        self.ivActionInd.hidden=true;
    } else {
        self.ivActionInd.hidden=false;
    }
}

@end
