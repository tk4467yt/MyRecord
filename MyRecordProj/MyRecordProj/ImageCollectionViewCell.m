//
//  ImageCollectionViewCell.m
//  MyRecordProj
//
//  Created by  qin on 2017/5/23.
//  Copyright © 2017年  qin. All rights reserved.
//

#import "ImageCollectionViewCell.h"
#import "MyCommonHeaders.h"

@implementation ImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.ivLastInd.backgroundColor=[MyColor orangeColor];
}

@end
