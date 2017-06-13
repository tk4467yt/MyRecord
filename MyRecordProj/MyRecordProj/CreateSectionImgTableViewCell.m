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
#import "RecordSectionItem.h"

@interface CreateSectionImgTableViewCell () <UICollectionViewDelegate,UICollectionViewDataSource,MyGalleryActionDelegate>

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
    
    self.thumbImgArr=[NSMutableArray new];
    self.orgImgArr=[NSMutableArray new];
    
    [self.cvImgs registerNib:[UINib nibWithNibName:@"ImageCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:[CellIdInfo cellIdForImageCVCellId]];
    self.cvImgs.delegate=self;
    self.cvImgs.dataSource=self;
    
    UITapGestureRecognizer *tapGestureImg=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action4DelSection)];
    [self.ivDel addGestureRecognizer:tapGestureImg];
}

- (void)action4DelSection
{
    if (nil != self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(imageActionForDelSectionWithCellIndex:)]) {
        [self.actionDelegate imageActionForDelSectionWithCellIndex:self.cellIndex];
    }
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

- (NSArray *)makeRecordSectionItemsArr
{
    NSMutableArray *arr2ret=[NSMutableArray new];
    
    for (int itemIdx=0; itemIdx<self.thumbImgArr.count; ++itemIdx) {
        RecordSectionItem *aItem=[RecordSectionItem new];
        aItem.recordId=0;
        aItem.sectionId=0;
        aItem.itemId=itemIdx;
        aItem.itemTxt=@"";
        aItem.imgId=self.orgImgArr[itemIdx];
        aItem.imgThumbId=self.thumbImgArr[itemIdx];
        
        [arr2ret addObject:aItem];
    }
    
    return arr2ret;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item >= self.thumbImgArr.count) {
        ImageCollectionViewCell *imgCell=(ImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if (nil != self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(imageActionForAddImageWithCellIndex:andSourceView:)]) {
            [self.actionDelegate imageActionForAddImageWithCellIndex:self.cellIndex andSourceView:imgCell.ivImage];
        }
    } else {
        MyGalleryViewController *galleryVC=[MyGalleryViewController new];
        galleryVC.curPhotoIdx=indexPath.row;
        galleryVC.imageInfoArr=[GalleryImageInfo makeImageInfoFromRecordSectionItems:[self makeRecordSectionItemsArr]];
        galleryVC.withDeleteAction=true;
        galleryVC.withDownloadAction=true;
        galleryVC.galleryActionDelegate=self;
        
        UINavigationController *navVC=[[UINavigationController alloc] initWithRootViewController:galleryVC];
        [self.actionDelegate presentViewController:navVC animated:YES completion:nil];
    }
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.thumbImgArr.count+1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionViewCell *imgCell=[collectionView dequeueReusableCellWithReuseIdentifier:[CellIdInfo cellIdForImageCVCellId] forIndexPath:indexPath];
    if (indexPath.item >= self.thumbImgArr.count) {
        imgCell.ivImage.image=[UIImage imageNamed:@"timeline_new_pic_add"];
    } else {
        NSString *imgName=self.thumbImgArr[indexPath.row];
        imgCell.ivImage.image=[MyUtility getImageWithName:imgName andDir:IMG_STORE_PATH_IN_DOC];
    }
    return imgCell;
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [CellSizeInfo sizeForImageCVItem];
}

#pragma mark MyGalleryActionDelegate
-(void)imageNotExistWithInfo:(GalleryImageInfo *)info
{
    
}
-(BOOL)isImageDeletableFromGallery
{
    return true;
}

-(void)imageDeleteWithInfo:(GalleryImageInfo *)info
{
    NSInteger item2delIdx=-1;
    for (int itemIdx=0; itemIdx<self.thumbImgArr.count; ++itemIdx) {
        RecordSectionItem *orgItem=(RecordSectionItem *)info.orgModelForMediaInfo;
        if ([orgItem.imgId isEqualToString:self.orgImgArr[itemIdx]] ||
            [orgItem.imgThumbId isEqualToString:self.thumbImgArr[itemIdx]]) {
            item2delIdx=itemIdx;
            break;
        }
    }
    
    if (item2delIdx >= 0) {
        [self.thumbImgArr removeObjectAtIndex:item2delIdx];
        
        [self.cvImgs reloadData];
    }
}
@end
