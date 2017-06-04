//
//  MyGalleryViewController.h
//  wowtalkbiz
//
//  Created by wowtech on 2017/4/24.
//  Copyright © 2017年 wowtech. All rights reserved.
//

#import "MyRootViewController.h"
#import "GalleryImageInfo.h"

@protocol MyGalleryActionDelegate <NSObject>

-(void)imageNotExistWithInfo:(GalleryImageInfo *)info;
-(BOOL)isImageDeletableFromGallery;

@optional
-(void)imageDeleteWithInfo:(GalleryImageInfo *)info;

@end

@interface MyGalleryViewController : MyRootViewController
@property (nonatomic,retain) NSArray *imageInfoArr;
@property (nonatomic,assign) BOOL withDeleteAction;
@property (nonatomic,assign) BOOL withDownloadAction;

@property (nonatomic,assign) id<MyGalleryActionDelegate> galleryActionDelegate;
@property (nonatomic, assign) NSInteger curPhotoIdx;
@end
