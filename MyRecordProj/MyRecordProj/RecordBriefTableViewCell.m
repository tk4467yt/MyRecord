//
//  RecordBriefTableViewCell.m
//  MyRecordProj
//
//  Created by  qin on 2017/5/30.
//  Copyright © 2017年  qin. All rights reserved.
//

#import "RecordBriefTableViewCell.h"
#import "ImageCollectionViewCell.h"
#import "RecordSectionItem.h"
#import "MyCommonHeaders.h"

@interface RecordBriefTableViewCell () <UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation RecordBriefTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.ivBkgView.image=[MyUtility makeResizeableImage:[UIImage imageNamed:@"timeline_card_bg2"] withCapInset:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    self.btnDetail.layer.masksToBounds=true;
    self.btnDetail.layer.cornerRadius=3.0;
    self.btnDetail.layer.borderWidth=1;
    self.btnDetail.layer.borderColor=[[MyColor defBackgroundColor] CGColor];
    
    self.btnEdit.layer.masksToBounds=true;
    self.btnEdit.layer.cornerRadius=3.0;
    self.btnEdit.layer.borderWidth=1;
    self.btnEdit.layer.borderColor=[[MyColor defBackgroundColor] CGColor];
    
    self.btnDelete.layer.masksToBounds=true;
    self.btnDelete.layer.cornerRadius=3.0;
    self.btnDelete.layer.borderWidth=1;
    self.btnDelete.layer.borderColor=[[MyColor defBackgroundColor] CGColor];
    
    self.cvThumb.backgroundColor=[MyColor defBackgroundColor];
//    self.cvThumb.layer.masksToBounds=true;
//    self.cvThumb.layer.cornerRadius=5.0;
//    self.cvThumb.layer.borderWidth=1;
//    self.cvThumb.layer.borderColor=[[MyColor defBackgroundColor] CGColor];
    
    [self.cvThumb registerNib:[UINib nibWithNibName:@"ImageCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:[CellIdInfo cellIdForImageCVCellId]];
    self.cvThumb.delegate=self;
    self.cvThumb.dataSource=self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.btnDetail setTitle:NSLocalizedString(@"Detail", @"") forState:UIControlStateNormal];
    [self.btnEdit setTitle:NSLocalizedString(@"Edit", @"") forState:UIControlStateNormal];
    [self.btnDelete setTitle:NSLocalizedString(@"Delete", @"") forState:UIControlStateNormal];
    
    [self.cvThumb reloadData];
}

- (IBAction)btnDetailTapped:(UIButton *)sender {
    if (nil != self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(recordBriefActionForViewDetail:)]) {
        [self.actionDelegate recordBriefActionForViewDetail:self.recordInfoId];
    }
}

- (IBAction)btnEditTapped:(UIButton *)sender {
    if (nil != self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(recordBriefActionForEdit:)]) {
        [self.actionDelegate recordBriefActionForEdit:self.recordInfoId];
    }
}

- (IBAction)btnDeleteTapped:(UIButton *)sender {
    if (nil != self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(recordBriefActionForDelete:)]) {
        [self.actionDelegate recordBriefActionForDelete:self.recordInfoId];
    }
}

+(CGFloat)cellHeightWithRecordInfo:(RecordInfo *)recordInfo
{
    CGFloat thumbHeight=0;
    if (nil != recordInfo) {
        NSArray *imgItemArr=[recordInfo getAllImageSectionItem];
        if (imgItemArr.count > 0) {
            thumbHeight=[CellSizeInfo sizeForImageCVItem].height;
        }
    }
    
    return 42+5+thumbHeight+10+40+30;
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
        [self.actionDelegate presentViewController:navVC animated:YES completion:nil];
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
