//
//  MyGalleryItemView.h
//  wowtalkbiz
//
//  Created by wowtech on 2017/5/4.
//  Copyright © 2017年 wowtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyGalleryItemView;

@protocol MyGalleryItemActionDelegate <NSObject>

-(void)myGalleryItem_singleTapWithItem:(MyGalleryItemView *)item;

@end

@interface MyGalleryItemView : UIScrollView
@property (nonatomic,retain) UIImageView *ivContent;

@property (nonatomic,assign) id<MyGalleryItemActionDelegate> galleryItemActionDelegate;

-(void)resetZoom;
@end
