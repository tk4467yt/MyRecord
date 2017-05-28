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
@end

@implementation PhotoSelectionAlbumDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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
        
        for (NSIndexPath *indexPath in self.selectedImageIndexpathArr) {
            [[PHImageManager defaultManager] requestImageForAsset:[self.assetsImgArr2use objectAtIndex:indexPath.item]
                                                       targetSize:PHImageManagerMaximumSize
                                                      contentMode:PHImageContentModeDefault
                                                          options:nil
                                                    resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                        if (nil != result) {
                                                            UIImage *img2use=[MyUtility scaleImage:result toSize:CGSizeMake(1024, 1024)];
                                                            if (nil != img2use) {
                                                                [imgArr addObject:img2use];
                                                            }
                                                        } else {
                                                            //show alert
                                                        }
                                                    }];
        }
        
        PhotoSelectionContainerNavVC *containerVC=(PhotoSelectionContainerNavVC *)self.rootVC.parentViewController;
        [containerVC.photoSelectionDelegate photoSelectionFinishWithImageArr:imgArr];
    }
}

- (void)updateRightNavBarStatus
{
    if (self.selectedImageIndexpathArr.count > 0) {
        self.navigationItem.rightBarButtonItem.enabled=true;
    } else {
        self.navigationItem.rightBarButtonItem.enabled=false;
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
    [self.selectedImageIndexpathArr addObject:indexPath];
    
    [self updateRightNavBarStatus];
    
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

@end
