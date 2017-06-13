//
//  PhotoSelectionAlbumDetailViewController.m
//  MyRecordProj
//
//  Created by  qin on 2017/5/28.
//  Copyright © 2017年  qin. All rights reserved.
//

#import "PhotoSelectionAlbumDetailViewController.h"
#import "PhotoSelectionItemCollectionViewCell.h"
#import "PhotoSelectionItemFooterReusableView.h"
#import "MyCommonHeaders.h"
#import "PhotoSelectionContainerNavVC.h"

@interface PhotoSelectionAlbumDetailViewController ()
@property (nonatomic,strong) NSMutableArray *assetsImgArr2use;

@property (nonatomic,strong) NSMutableArray *selectedImageIndexpathArr;
@property (nonatomic,assign) BOOL shoudScrollBottom;
@end

@implementation PhotoSelectionAlbumDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.shoudScrollBottom=true;
    
    [self.cvAlbumItems registerNib:[UINib nibWithNibName:@"PhotoSelectionItemCollectionViewCell" bundle:nil]
         forCellWithReuseIdentifier:@"photo_selection_album_detail_cv_cell_id"];
    [self.cvAlbumItems registerNib:[UINib nibWithNibName:@"PhotoSelectionItemFooterReusableView" bundle:nil]
         forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"photo_selection_album_detail_footer_id"];
    //    self.cvDetailItems.scrollsToTop=false;
    
    self.selectedImageIndexpathArr=[NSMutableArray new];
    
    self.assetsImgArr2use=[NSMutableArray new];
    PHFetchResult<PHAsset *> *assetsArr = [PHAsset fetchAssetsInAssetCollection:self.assetCollection options:nil];
    //filter video
    for (PHAsset *aAsset in assetsArr) {
        if (aAsset.mediaType == PHAssetMediaTypeImage) {
            [self.assetsImgArr2use addObject:aAsset];
        }
    }
    
    [self configNav];
}

- (void)configNav
{
    self.navigationItem.title=NSLocalizedString(@"Select",nil);
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionDoneForSelectPhoto)];
    self.navigationItem.rightBarButtonItem.enabled=false;
}

- (void)actionDoneForSelectPhoto
{
    if (nil != self.rootVC) {
        NSMutableArray *imgArr=[NSMutableArray new];
        
        [[AppCoverView getAppCoverView] showInView:self.view withText:NSLocalizedString(@"handling",nil)];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.synchronous = YES;
            for (NSIndexPath *indexPath in self.selectedImageIndexpathArr) {
                [[PHImageManager defaultManager] requestImageForAsset:[self.assetsImgArr2use objectAtIndex:indexPath.item]
                                                           targetSize:PHImageManagerMaximumSize
                                                          contentMode:PHImageContentModeDefault
                                                              options:options
                                                        resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                            if (nil != result) {
                                                                UIImage *img2use=[MyUtility scaleImage:result toSize:[MyUtility maxSizeOfImage2handle]];
                                                                if (nil != img2use) {
                                                                    [imgArr addObject:img2use];
                                                                }
                                                            } else {
                                                                //show alert
                                                            }
                                                        }];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[AppCoverView getAppCoverView] hideFromSuperView];
                
                PhotoSelectionContainerNavVC *containerVC=(PhotoSelectionContainerNavVC *)self.rootVC.parentViewController;
                [containerVC.photoSelectionDelegate photoSelectionFinishWithImageArr:imgArr];
            });
        });
    }
}

- (BOOL)isItemSelectedByIndexpath:(NSIndexPath *)indexPath
{
    BOOL isExist=false;
    
    for (NSIndexPath *aIndexPath in self.selectedImageIndexpathArr) {
        if (aIndexPath.section == indexPath.section &&
            aIndexPath.item == indexPath.item) {
            isExist=true;
        }
    }
    
    return isExist;
}

- (void)updateRightNavBarStatus
{
    if (self.selectedImageIndexpathArr.count > 0) {
        self.navigationItem.rightBarButtonItem.enabled=true;
    } else {
        self.navigationItem.rightBarButtonItem.enabled=false;
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (self.shoudScrollBottom && self.assetsImgArr2use.count > 0) {
        self.shoudScrollBottom=false;
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:(self.assetsImgArr2use.count - 1) inSection:0];
        [self.cvAlbumItems scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    }
}

#pragma mark override
-(void)screenOrientationChangedHandle
{
    [self.cvAlbumItems reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isItemSelectedByIndexpath:indexPath]) {
        NSIndexPath *indexPaht2del=nil;
        
        for (NSIndexPath *aIndexPath in self.selectedImageIndexpathArr) {
            if (aIndexPath.section == indexPath.section &&
                aIndexPath.item == indexPath.item) {
                indexPaht2del=aIndexPath;
            }
        }
        
        if (nil != indexPaht2del) {
            [self.selectedImageIndexpathArr removeObject:indexPaht2del];
        }
    } else {
        [self.selectedImageIndexpathArr addObject:indexPath];
    }
    
    [self updateRightNavBarStatus];
    
    [self.cvAlbumItems reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assetsImgArr2use.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"photo_selection_album_detail_cv_cell_id" forIndexPath:indexPath];
    
    PhotoSelectionItemCollectionViewCell *photoCVCell=(PhotoSelectionItemCollectionViewCell *)cell;
    
    PHAsset *asset2use=[self.assetsImgArr2use objectAtIndex:indexPath.item];
    if (asset2use.mediaType == PHAssetMediaTypeVideo) {
        photoCVCell.ivVideoInd.hidden=false;
        photoCVCell.lblVideoDuration.hidden=false;
        
        photoCVCell.lblVideoDuration.text=[MyUtility getTimeDescFromSeconds:(asset2use.duration<1?1:asset2use.duration)];
    } else {
        photoCVCell.ivVideoInd.hidden=true;
        photoCVCell.lblVideoDuration.hidden=true;
    }
    
    if ([self isItemSelectedByIndexpath:indexPath]) {
        photoCVCell.ivSelect.image=[UIImage imageNamed:@"table_checked"];
    } else {
        photoCVCell.ivSelect.image=[UIImage imageNamed:@"table_unchecked"];
    }
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    [[PHImageManager defaultManager] requestImageForAsset:asset2use
                                               targetSize:CGSizeMake(77, 77)
                                              contentMode:PHImageContentModeAspectFill
                                                  options:options
                                            resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                photoCVCell.ivThumb.image=result;
                                            }];
    
    [cell setNeedsLayout];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    NSString *reuseIdentifier=nil;
    if ([kind isEqualToString: UICollectionElementKindSectionFooter]){
        reuseIdentifier = @"photo_selection_album_detail_footer_id";
    }
    
    UICollectionReusableView *view2ret=nil;
    if (nil != reuseIdentifier) {
        view2ret =  [collectionView dequeueReusableSupplementaryViewOfKind :kind
                                                        withReuseIdentifier:reuseIdentifier   forIndexPath:indexPath];
        
        PhotoSelectionItemFooterReusableView *itemFooter=(PhotoSelectionItemFooterReusableView *)view2ret;
        
        NSInteger videoCount=0;
        for (PHAsset *aAsset in self.assetsImgArr2use) {
            if (aAsset.mediaType == PHAssetMediaTypeVideo) {
                ++videoCount;
            }
        }
        itemFooter.lblCountStatus.text=[NSString stringWithFormat:NSLocalizedString(@"photo_selection_status_for_photo_video_count",nil),
                                        self.assetsImgArr2use.count-videoCount,videoCount];
    } else {
        view2ret=[[UICollectionReusableView alloc] init];
    }
    
    return view2ret;
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([MyUtility isDeviceIpad]) {
        return CGSizeMake(160, 160);
    } else {
        return CGSizeMake(77, 77);
    }
}

@end
