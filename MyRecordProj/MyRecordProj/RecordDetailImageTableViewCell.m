//
//  RecordDetailImageTableViewCell.m
//  MyRecordProj
//
//  Created by  qin on 2017/6/2.
//  Copyright © 2017年  qin. All rights reserved.
//

#import "RecordDetailImageTableViewCell.h"
#import "MyCommonHeaders.h"
#import "ImageCollectionViewCell.h"
#import "RecordSectionItem.h"

@interface RecordDetailImageTableViewCell () <UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation RecordDetailImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.cvImage.backgroundColor=[MyColor defBackgroundColor];
    
    [self.cvImage registerNib:[UINib nibWithNibName:@"ImageCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:[CellIdInfo cellIdForImageCVCellId]];
    self.cvImage.delegate=self;
    self.cvImage.dataSource=self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.cvImage reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item < self.recordSectionItemArr.count) {
        MyGalleryViewController *galleryVC=[MyGalleryViewController new];
        galleryVC.curPhotoIdx=indexPath.row;
        galleryVC.imageInfoArr=[GalleryImageInfo makeImageInfoFromRecordSectionItems:self.recordSectionItemArr];
        
        UINavigationController *navVC=[[UINavigationController alloc] initWithRootViewController:galleryVC];
        [self.parentVC presentViewController:navVC animated:YES completion:nil];
    }
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.recordSectionItemArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionViewCell *imgCell=[collectionView dequeueReusableCellWithReuseIdentifier:[CellIdInfo cellIdForImageCVCellId] forIndexPath:indexPath];
    RecordSectionItem *aItem=self.recordSectionItemArr[indexPath.row];
    imgCell.ivImage.image=[MyUtility getImageWithName:aItem.imgThumbId andDir:IMG_STORE_PATH_IN_DOC];
    
    return imgCell;
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [CellSizeInfo sizeForImageCVItem];
}

@end
