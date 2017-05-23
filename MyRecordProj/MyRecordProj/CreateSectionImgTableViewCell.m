//
//  CreateSectionImgTableViewCell.m
//  MyRecordProj
//
//  Created by  qin on 2017/5/20.
//  Copyright © 2017年  qin. All rights reserved.
//

#import "CreateSectionImgTableViewCell.h"
#import "MyCommonHeaders.h"
#import "ImageCollectionViewCell.h"

@interface CreateSectionImgTableViewCell () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) NSMutableArray *imgArr;
@end

@implementation CreateSectionImgTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.cvImgs.layer.masksToBounds=true;
    self.cvImgs.layer.cornerRadius=5.0;
    self.cvImgs.layer.borderWidth=1;
    self.cvImgs.layer.borderColor=[[MyColor orangeColor] CGColor];
    
    self.lblImgDesc.textColor=[MyColor orangeColor];
    
    self.imgArr=[NSMutableArray new];
    
    [self.cvImgs registerNib:[UINib nibWithNibName:@"ImageCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:[CellIdInfo cellIdForImageCVCellId]];
    self.cvImgs.delegate=self;
    self.cvImgs.dataSource=self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.cvImgs reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item >= self.imgArr.count) {
        
    } else {
        
    }
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imgArr.count+1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionViewCell *imgCell=[collectionView dequeueReusableCellWithReuseIdentifier:[CellIdInfo cellIdForImageCVCellId] forIndexPath:indexPath];
    if (indexPath.item >= self.imgArr.count) {
        imgCell.ivImage.image=[UIImage imageNamed:@"timeline_new_pic_add"];
    } else {
        
    }
    return imgCell;
}

#pragma mark UICollectionViewDelegateFlowLayout
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}
@end
