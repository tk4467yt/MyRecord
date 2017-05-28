//
//  PhotoSelectionRootViewController.m
//  MyRecordProj
//
//  Created by  qin on 2017/5/25.
//  Copyright © 2017年  qin. All rights reserved.
//

#import <Photos/Photos.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "PhotoSelectionRootViewController.h"
#import "PhotoSelectionContainerNavVC.h"
#import "PhotoSelectionAlbumTableViewCell.h"
#import "PhotoSelectionAlbumDetailViewController.h"
#import "MyCommonHeaders.h"

@interface PhotoSelectionRootViewController () <UITableViewDelegate,UITableViewDataSource,PHPhotoLibraryChangeObserver>
@property (weak, nonatomic) IBOutlet UITableView *tbAlbums;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *aidLoading;

@property (nonatomic, strong) NSMutableArray *albumArr;
@property (nonatomic, strong) NSMutableDictionary *thumbDict;
@end

@implementation PhotoSelectionRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.albumArr=[[NSMutableArray alloc] init];
    
    [self.tbAlbums registerNib:[UINib nibWithNibName:@"PhotoSelectionAlbumTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"photo_selection_album_cell_id"];
    
    [self configNav];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (PHAuthorizationStatusNotDetermined == [PHPhotoLibrary authorizationStatus]) {
        //request
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
            if (PHAuthorizationStatusRestricted == status || PHAuthorizationStatusDenied == status) {
                //cannot access photo
                [self showAlertCannotAccessPhoto];
            } else if (PHAuthorizationStatusAuthorized == status) {
                //can access
                [self reloadPhotosAssetsInfo];
            }
        }];
    } else if (PHAuthorizationStatusRestricted == [PHPhotoLibrary authorizationStatus] || PHAuthorizationStatusDenied == [PHPhotoLibrary authorizationStatus]) {
        //cannot access photo
        [self showAlertCannotAccessPhoto];
    } else if (PHAuthorizationStatusAuthorized == [PHPhotoLibrary authorizationStatus]) {
        //can access
        [self reloadPhotosAssetsInfo];
    }
    
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

#pragma mark override
-(void)screenOrientationChangedHandle
{
    [self.tbAlbums reloadData];
}

#pragma mark PHPhotoLibraryChangeObserver
- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    //must called on main
    dispatch_async(dispatch_get_main_queue(), ^{
        PHAuthorizationStatus status=[PHPhotoLibrary authorizationStatus];
        if (PHAuthorizationStatusAuthorized == status) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadPhotosAssetsInfo) object:nil];
            [self performSelector:@selector(reloadPhotosAssetsInfo) withObject:nil afterDelay:0.3];
        }
    });
}

-(void)showAlertCannotAccessPhoto
{
    [MyUtility prensentAlertVCFromSourceVC:self withAnim:YES andContent:NSLocalizedString(@"Not have access privileges", @"Not have access privileges")];
    
    [self.tbAlbums reloadData];
}

-(void)reloadPhotosAssetsInfo
{
    if (nil == self.albumArr) {
        self.albumArr=[[NSMutableArray alloc] init];
    } else {
        [self.albumArr removeAllObjects];
    }
    
    [self fetchCollectionWithType:PHAssetCollectionTypeSmartAlbum andSubType:PHAssetCollectionSubtypeSmartAlbumUserLibrary];
    
    [self fetchCollectionWithType:PHAssetCollectionTypeAlbum andSubType:PHAssetCollectionSubtypeAny];
    
    //    [self fetchCollectionWithType:PHAssetCollectionTypeMoment andSubType:PHAssetCollectionSubtypeAny];
    
    [self fetchAlbumThumbs];
    
    [self.tbAlbums reloadData];
}

-(void)fetchCollectionWithType:(PHAssetCollectionType)type andSubType:(PHAssetCollectionSubtype)subType
{
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"localizedTitle" ascending:YES],];
    PHFetchResult<PHAssetCollection *> *fetchResultArr=[PHAssetCollection fetchAssetCollectionsWithType:type subtype:subType options:fetchOptions];
    for (NSInteger i = 0; i < fetchResultArr.count; i++) {
        PHCollection *collection = fetchResultArr[i];
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            [self.albumArr addObject:assetCollection];
        }
    }
}

-(void)fetchAlbumThumbs
{
    if (nil == self.thumbDict) {
        self.thumbDict=[[NSMutableDictionary alloc] init];
    } else {
        [self.thumbDict removeAllObjects];
    }
    
    PHFetchOptions *fetchOption=[[PHFetchOptions alloc] init];
    fetchOption.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    if (IS_IOS9) {
        fetchOption.fetchLimit=1;
    }
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    
    for (PHAssetCollection *assetCollection in self.albumArr) {
        PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:fetchOption];
        if (assets.count > 0) {
            for (PHAsset *asset in assets) {
                CGSize size = CGSizeMake(80, 80);
                
                [[PHImageManager defaultManager] requestImageForAsset:asset
                                                           targetSize:size
                                                          contentMode:PHImageContentModeAspectFill
                                                              options:options
                                                        resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                            if (nil != result) {
                                                                [self.thumbDict setObject:result forKey:assetCollection.localIdentifier];
                                                            } else {
                                                                [self.thumbDict setObject:[UIImage imageNamed:@"default_pic"] forKey:assetCollection.localIdentifier];
                                                            }
                                                            
                                                            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(triggerRoloadTableData) object:nil];
                                                            [self performSelector:@selector(triggerRoloadTableData) withObject:nil afterDelay:0.3];
                                                            
                                                            [self.aidLoading stopAnimating];
                                                            self.aidLoading.hidden=true;
                                                        }];
                break;
            }
        } else {
            [self.thumbDict setObject:[UIImage imageNamed:@"default_pic"] forKey:assetCollection.localIdentifier];
        }
    }
}

- (void)triggerRoloadTableData
{
    [self.tbAlbums reloadData];
}

- (void)configNav
{
    self.navigationItem.title=NSLocalizedString(@"Album",nil);
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"cancel", nil) style:UIBarButtonItemStylePlain target:self action:@selector(selectCancelHandle)];
    
    self.navigationItem.leftBarButtonItem = leftBarButton;
}

- (void)selectCancelHandle
{
    PhotoSelectionContainerNavVC *containerVC=(PhotoSelectionContainerNavVC *)self.parentViewController;
    [containerVC.photoSelectionDelegate photoSelectionCancel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PhotoSelectionAlbumDetailViewController *ablumDetailVC = [[PhotoSelectionAlbumDetailViewController alloc] init];
    ablumDetailVC.assetCollection=[self.albumArr objectAtIndex:indexPath.row];
    ablumDetailVC.rootVC=self;
    
    [MyUtility pushViewControllerFromNav:self.navigationController withTargetVC:ablumDetailVC animated:YES];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.albumArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoSelectionAlbumTableViewCell *albumCell = [tableView dequeueReusableCellWithIdentifier:@"photo_selection_album_cell_id"];
    
    PHAssetCollection *assetCollection=[self.albumArr objectAtIndex:indexPath.row];
    albumCell.lblName.text=assetCollection.localizedTitle;
    
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    NSUInteger assetCount=[assets countOfAssetsWithMediaType:PHAssetMediaTypeImage];
    albumCell.lblNumber.text=[NSString stringWithFormat:@"%d",(int)assetCount];
    albumCell.ivThumb.image=[self.thumbDict objectForKey:assetCollection.localIdentifier];
    
    return albumCell;
}

- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

@end
