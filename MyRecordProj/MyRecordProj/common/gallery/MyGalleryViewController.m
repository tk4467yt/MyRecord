//
//  MyGalleryViewController.m
//  wowtalkbiz
//
//  Created by wowtech on 2017/4/24.
//  Copyright © 2017年 wowtech. All rights reserved.
//

#import "MyGalleryViewController.h"
#import "MyGalleryItemView.h"
#import "MyCommonHeaders.h"

#define TAG_FOR_DEFAULT_IMG_SET 1034

@interface MyGalleryViewController () <MyGalleryItemActionDelegate>
@property (retain, nonatomic) IBOutlet UIScrollView *svContainer;
@property (nonatomic, assign) NSInteger oldPhotoIdx;
@end

@implementation MyGalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.oldPhotoIdx=self.curPhotoIdx;
    [self updateNavTitle];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_close.png"]
                                                                           style:(UIBarButtonItemStylePlain)
                                                                          target:self
                                                                          action:@selector(dismissViewController)];
    if (self.withDeleteAction || self.withDownloadAction) {
        UIBarButtonItem *rightbutton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_more"] style:UIBarButtonItemStylePlain target:self action:@selector(showActionForGallery)];
        self.navigationItem.rightBarButtonItem=rightbutton;
    }
    
    [self updateScrollviewContent:true];
}

-(void)dismissViewController
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)showActionForGallery
{
    UIAlertController *menuAlertVC=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionForDelete=nil;
    if (self.withDeleteAction) {
        actionForDelete=[UIAlertAction actionWithTitle:NSLocalizedString(@"Delete",nil)
                                                                style:UIAlertActionStyleDestructive
                                                              handler:^(UIAlertAction *action) {
                                                                  [self deleteCurrentPhoto];
                                                              }];
    }
    
    UIAlertAction *actionForDownload=nil;
    if (self.withDownloadAction) {
        actionForDownload=[UIAlertAction actionWithTitle:NSLocalizedString(@"save photo to local",nil)
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction *action) {
                                                                    [self savePhoto2local];
                                                                }];
    }
    
    UIAlertAction *actionForCancel=[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel",nil)
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction *action) {
                                                              
                                                          }];
    
    if (nil != actionForDownload) {
        [menuAlertVC addAction:actionForDownload];
    }
    if (nil != actionForDelete) {
        [menuAlertVC addAction:actionForDelete];
    }
    
    [menuAlertVC addAction:actionForCancel];
    
    menuAlertVC.popoverPresentationController.barButtonItem=self.navigationItem.rightBarButtonItem;
    
    [self presentViewController:menuAlertVC animated:YES completion:nil];
}

-(void)savePhoto2local
{
    self.navigationItem.rightBarButtonItem.enabled=false;
    
    NSString *imgPath2save=nil;
    NSInteger photoIdx=self.curPhotoIdx;
    if (photoIdx < self.imageInfoArr.count) {
        GalleryImageInfo *imgInfo2update=self.imageInfoArr[photoIdx];
        
        if ([MyUtility isFileExistAtPath:imgInfo2update.orgImagePath]) {
            imgPath2save=imgInfo2update.orgImagePath;
        } else if ([MyUtility isFileExistAtPath:imgInfo2update.thumbPath]) {
            imgPath2save=imgInfo2update.thumbPath;
        } else {
            
        }
    }
    
    if (nil != imgPath2save) {
        if ([@"gif" isEqualToString:imgPath2save.pathExtension]) {
//            NSData *data = [[NSFileManager defaultManager] contentsAtPath:imgPath2save];
//            UIImageWriteToSavedPhotosAlbum([UIImage animatedGIFWithData:data], self,@selector(image:didFinishSavingWithError:contextInfo:),NULL);
        } else {
            UIImage *image = [UIImage imageWithContentsOfFile:imgPath2save];
            UIImageWriteToSavedPhotosAlbum(image, self,@selector(image:didFinishSavingWithError:contextInfo:),NULL);
        }
    }
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    self.navigationItem.rightBarButtonItem.enabled=true;
//    if (nil != error) {
//        [[WarningView viewWithString:NSLocalizedString(@"save photo to album fail",nil )] showAlert:nil];
//    } else {
//        [[WarningView viewWithString:NSLocalizedString(@"save photo to album success",nil)] showAlert:nil];
//    }
}

-(void)deleteCurrentPhoto
{
    if (![self.galleryActionDelegate isImageDeletableFromGallery]) {
        return;
    }
    if (nil != self.galleryActionDelegate && [self.galleryActionDelegate respondsToSelector:@selector(imageDeleteWithInfo:)]) {
        GalleryImageInfo *imageInfo=nil;
        if (self.curPhotoIdx < self.imageInfoArr.count) {
            imageInfo=self.imageInfoArr[self.curPhotoIdx];
        }
        if (nil != imageInfo) {
            UIAlertController *alertVC=[UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"remind to delete photo",nil)
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionForOk=[UIAlertAction actionWithTitle:NSLocalizedString(@"OK",nil)
                                                                style:UIAlertActionStyleDestructive
                                                              handler:^(UIAlertAction *action) {
                                                                  if (self.imageInfoArr.count <= 1) {
                                                                      [self dismissViewController];
                                                                  } else {
                                                                      NSMutableArray *arrHandling=[NSMutableArray arrayWithArray:self.imageInfoArr];
                                                                      [arrHandling removeObject:imageInfo];
                                                                      self.imageInfoArr=[NSMutableArray arrayWithArray:arrHandling];
                                                                      
                                                                      if (self.curPhotoIdx >= self.imageInfoArr.count) {
                                                                          self.curPhotoIdx=self.imageInfoArr.count-1;
                                                                      }
                                                                      [self updateNavTitle];
                                                                      [self updateScrollviewContent:true];
                                                                  }
                                                                  [self.galleryActionDelegate imageDeleteWithInfo:imageInfo];
                                                              }];
            
            UIAlertAction *actionForCancel=[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel",nil)
                                                                    style:UIAlertActionStyleCancel
                                                                  handler:^(UIAlertAction *action) {
                                                                      
                                                                  }];
            
            [alertVC addAction:actionForOk];
            [alertVC addAction:actionForCancel];
            
            [self presentViewController:alertVC animated:YES completion:nil];
        }
    }
}

- (void)updateNavTitle
{
    self.navigationItem.title=[NSString stringWithFormat:@"%@ %d/%d",NSLocalizedString(@"Photo",nil),(int)self.curPhotoIdx+1,(int)self.imageInfoArr.count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)screenOrientationChangedHandle
{
    [self updateScrollviewContent:true];
}

-(void)updateScrollviewContent:(BOOL)force
{
    if (self.svContainer.subviews.count != self.imageInfoArr.count || force) {
        for (UIView *aSubView in self.svContainer.subviews) {
            [aSubView removeFromSuperview];
        }
        
        for (NSInteger idx=0; idx < self.imageInfoArr.count; ++idx) {
//            GalleryImageInfo *aImageInfo=self.imageInfoArr[idx];
            
            MyGalleryItemView* photoView = [[MyGalleryItemView alloc] initWithFrame:
                                           CGRectMake([MyUtility screenWidth]*idx, 0, [MyUtility screenWidth], [MyUtility screenHeight])];
//            photoView.nagationBarDelegate = self;
            photoView.tag=idx+1;
            photoView.galleryItemActionDelegate=self;
            
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                BOOL notifyNotExist=false;
//                UIImage *image2set=nil;
//                if ([NSFileManager hasFileAtPath:aImageInfo.orgImagePath]) {
//                    image2set = [UIImage imageWithContentsOfFile:aImageInfo.orgImagePath];
//                } else if ([NSFileManager hasFileAtPath:aImageInfo.thumbPath]) {
//                    image2set = [UIImage imageWithContentsOfFile:aImageInfo.thumbPath];
//                    notifyNotExist=true;
//                } else {
//                    image2set=[UIImage imageNamed:@"default_pic"];
//                    notifyNotExist=true;
//                }
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    photoView.image=image2set;
//                    if (notifyNotExist) {
//                        if (nil != self.galleryActionDelegate && [self.galleryActionDelegate respondsToSelector:@selector(imageNotExistWithInfo:)]) {
//                            [self.galleryActionDelegate imageNotExistWithInfo:aImageInfo];
//                        }
//                    }
//                });
//            });
            
            [self.svContainer addSubview:photoView];
            
            [self updateItemPhotoWithIndex:photoView.tag andForce:YES];
        }
    } else {
        for (UIView *aSubView in self.svContainer.subviews) {
            if ([aSubView isKindOfClass:[MyGalleryItemView class]]) {
                MyGalleryItemView *photoView=(MyGalleryItemView *)aSubView;
                [photoView resetZoom];
                photoView.frame=CGRectMake([MyUtility screenWidth]*(photoView.tag-1), 0, [MyUtility screenWidth], [MyUtility screenHeight]);
            }
        }
    }
    
    [self.svContainer setContentSize:CGSizeMake([MyUtility screenWidth]*self.imageInfoArr.count, [MyUtility screenHeight])];
    [self.svContainer setContentOffset:CGPointMake([MyUtility screenWidth]*self.curPhotoIdx, 0)];
    
    [self.svContainer setNeedsLayout];
    [self.svContainer setNeedsUpdateConstraints];
}

- (void)dealloc {
    for(UIView* subview in [self.svContainer subviews]){
        [subview removeFromSuperview];
    }
//    for(UIView* subview in [self.view subviews]){
//        [subview removeFromSuperview];
//    }
    self.svContainer.delegate=nil;
    self.imageInfoArr=nil;
//    [_svContainer release];
//    [super dealloc];
}

#pragma mark UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.curPhotoIdx = scrollView.contentOffset.x / [MyUtility screenWidth];
    [self updateNavTitle];
    
    [self updateItemPhotoWithIndex:self.curPhotoIdx+1 andForce:false];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.curPhotoIdx != self.oldPhotoIdx) {
        MyGalleryItemView* photoView = (MyGalleryItemView*)[self.svContainer viewWithTag:self.oldPhotoIdx+1];
        if ([photoView isKindOfClass:[MyGalleryItemView class]]) {
            [photoView resetZoom];
        }
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.oldPhotoIdx = scrollView.contentOffset.x / [MyUtility screenWidth];
}

#pragma mark MyGalleryItemActionDelegate
-(void)myGalleryItem_singleTapWithItem:(MyGalleryItemView *)item
{
    self.navigationController.navigationBarHidden = !self.navigationController.isNavigationBarHidden;
    [UIApplication sharedApplication].statusBarHidden = ![UIApplication sharedApplication].isStatusBarHidden;
}

#pragma mark override
- (void)didReceivecMyCustomNotification:(NSString *)key withDict:(NSDictionary *)dictData {
//    if ([NOTIFICATION_OBSERVER_FOR_MESSAGE_ALBUM_MEDIA_DOWNLOAD isEqualToString:key]) {
//        [self didDownloadAlbumMedia:dictData];
//    } else {
//        [super didReceivecMyCustomNotification:key withDict:dictData];
//    }
}

//-(void)didDownloadAlbumMedia:(NSDictionary*)dict
//{
//    NSInteger errorCode=[[dict objectForKey:NOTIFICATION_OBSERVER_RET_KEY_ERROR_CODE] integerValue];
//    if (NO_ERROR == errorCode) {
//        NSString *albumId=[PublicFunctions getStringFromDict:dict withKey:NOTIFICATION_OBSERVER_RET_KEY_DATA];
//        if ([PublicFunctions isObjectAnString:albumId]) {
//            BOOL shouldUpdate=false;
//            
//            for (NSInteger idx=0; idx < self.imageInfoArr.count; ++idx) {
//                GalleryImageInfo *aImageInfo=self.imageInfoArr[idx];
//                MessageAlbumMedia *albumMedia=(MessageAlbumMedia *)aImageInfo.orgModelForMediaInfo;
//                if ([albumMedia isKindOfClass:[MessageAlbumMedia class]] && [albumMedia.albumId isEqualToString:albumId]) {
//                    shouldUpdate=true;
//                    break;
//                }
//            }
//            
//            if (shouldUpdate) {
//                [self updateItemPhotoWithIndex:self.curPhotoIdx+1 andForce:YES];
//            }
//        }
//    }
//}

-(void)updateItemPhotoWithIndex:(NSInteger)viewIdx andForce:(BOOL)force
{
    MyGalleryItemView* photoView = (MyGalleryItemView*)[self.svContainer viewWithTag:viewIdx];
    if ([photoView isKindOfClass:[MyGalleryItemView class]]) {
        if (force || TAG_FOR_DEFAULT_IMG_SET == photoView.ivContent.tag) {
            if (viewIdx <= self.imageInfoArr.count && viewIdx > 0) {
                GalleryImageInfo *imgInfo2update=self.imageInfoArr[viewIdx-1];
                
                BOOL notifyNotExist=false;
                photoView.ivContent.tag=TAG_FOR_DEFAULT_IMG_SET;
                
                if ([MyUtility isFileExistAtPath:imgInfo2update.orgImagePath]) {
                    [photoView.ivContent setImage:[UIImage imageWithContentsOfFile:imgInfo2update.orgImagePath]];
                    photoView.ivContent.tag=0;
                } else if ([MyUtility isFileExistAtPath:imgInfo2update.thumbPath]) {
                    [photoView.ivContent setImage:[UIImage imageWithContentsOfFile:imgInfo2update.thumbPath]];
                    notifyNotExist=true;
                } else {
                    [photoView.ivContent setImage:[UIImage imageNamed:@"default_pic"]];
                    notifyNotExist=true;
                }
                
                if (notifyNotExist) {
                    if (nil != self.galleryActionDelegate && [self.galleryActionDelegate respondsToSelector:@selector(imageNotExistWithInfo:)]) {
                        [self.galleryActionDelegate imageNotExistWithInfo:imgInfo2update];
                    }
                }
            }
        }
    }
}
@end
