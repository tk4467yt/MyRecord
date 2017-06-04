//
//  RecordDetailTitleTableViewCell.m
//  MyRecordProj
//
//  Created by  qin on 2017/6/2.
//  Copyright © 2017年  qin. All rights reserved.
//

#import "RecordDetailTitleTableViewCell.h"
#import "MyCommonHeaders.h"

@implementation RecordDetailTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.backgroundColor=[MyColor defBackgroundColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
