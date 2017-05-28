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

@interface PhotoSelectionAlbumDetailViewController ()
@property (nonatomic,strong) NSMutableArray *assetsImgArr2use;
@property (nonatomic,assign) BOOL shoudScrollBottom;
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
    
    self.shoudScrollBottom=true;
    
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
    //    PHImageRequestOptions *options = [[[PHImageRequestOptions alloc] init] autorelease];
    //    options.synchronous = YES;
    [[PHImageManager defaultManager] requestImageForAsset:[self.assetsImgArr2use objectAtIndex:indexPath.row]
                                               targetSize:PHImageManagerMaximumSize
                                              contentMode:PHImageContentModeDefault
                                                  options:nil
                                            resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                if (nil != result) {
                                                    [self showImageEditorWithImage:result];
                                                } else {
                                                    //show alert
                                                }
                                            }];
}

-(void)showImageEditorWithImage:(UIImage *)img2use
{
//    if (img2use.size.width > PhotoMaxWidth || img2use.size.height > PhotoMaxHeight) {
//        CGSize targetSize = [img2use calculateTheScaledSize:CGSizeMake(img2use.size.width, img2use.size.height) withMaxSize: CGSizeMake(PhotoMaxWidth, PhotoMaxHeight)];
//        img2use = [img2use resizeToSize:targetSize];
//    }
//    
//    CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:img2use];
//    editor.delegate = self;
//    //                                                            editor.imgIdx2ret=indexPath.row-1;
//    [PublicFunctions presentViewControllerOnVC:self targetVC:editor animated:YES completion:nil];
//    [editor release];
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
    
    PHAsset *asset2use=[self.assetsImgArr2use objectAtIndex:indexPath.row];
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
