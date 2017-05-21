//
//  CreateSectionTitleTableViewCell.m
//  MyRecordProj
//
//  Created by  qin on 2017/5/20.
//  Copyright © 2017年  qin. All rights reserved.
//

#import "CreateSectionTitleTableViewCell.h"
#import "MyCommonHeaders.h"

@implementation CreateSectionTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.tvTitle.layer.masksToBounds=true;
    self.tvTitle.layer.cornerRadius=5.0;
    self.tvTitle.layer.borderWidth=1;
    self.tvTitle.layer.borderColor=[[MyColor defBackgroundColor] CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
