//
//  CreateSectionImgTableViewCell.m
//  MyRecordProj
//
//  Created by  qin on 2017/5/20.
//  Copyright © 2017年  qin. All rights reserved.
//

#import "CreateSectionImgTableViewCell.h"
#import "MyCommonHeaders.h"

@implementation CreateSectionImgTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.cvImgs.layer.masksToBounds=true;
    self.cvImgs.layer.cornerRadius=5.0;
    self.cvImgs.layer.borderWidth=1;
    self.cvImgs.layer.borderColor=[[MyColor orangeColor] CGColor];
    
    self.lblImgDesc.textColor=[MyColor orangeColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
