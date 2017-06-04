//
//  MyGalleryItemView.m
//  wowtalkbiz
//
//  Created by wowtech on 2017/5/4.
//  Copyright © 2017年 wowtech. All rights reserved.
//

#import "MyGalleryItemView.h"
#import "MyCommonHeaders.h"

@interface MyGalleryItemView () <UIScrollViewDelegate>

@end

@implementation MyGalleryItemView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.ivContent = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        self.ivContent.contentMode=UIViewContentModeScaleAspectFit;
        self.ivContent.backgroundColor=[UIColor blackColor];
        [self addSubview:self.ivContent];
        
        self.maximumZoomScale = 3.f;
        self.minimumZoomScale = 1.f;
        self.delegate = self;
        self.userInteractionEnabled = TRUE;
        
        self.multipleTouchEnabled = YES;
        
        UITapGestureRecognizer *singleTapGestuerRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHandle:)];
        singleTapGestuerRecognizer.numberOfTapsRequired=1;
        [self addGestureRecognizer:singleTapGestuerRecognizer];
        
        UITapGestureRecognizer *doubleTapGestuerRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapHandle:)];
        doubleTapGestuerRecognizer.numberOfTapsRequired=2;
        [self addGestureRecognizer:doubleTapGestuerRecognizer];
        
        [singleTapGestuerRecognizer requireGestureRecognizerToFail:doubleTapGestuerRecognizer];
    }
    return self;
}

-(void)singleTapHandle:(UITapGestureRecognizer *)tapGesture
{
    if (nil != self.galleryItemActionDelegate && [self.galleryItemActionDelegate respondsToSelector:@selector(myGalleryItem_singleTapWithItem:)]) {
        [self.galleryItemActionDelegate myGalleryItem_singleTapWithItem:self];
    }
}

-(void)doubleTapHandle:(UITapGestureRecognizer *)tapGesture
{
    CGPoint tapPoint=[tapGesture locationInView:self.ivContent];
    CGFloat newScale = [self nextScale];
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:tapPoint];
    [self zoomToRect:zoomRect animated:YES];
}

- (CGRect)zoomRectForScale:(CGFloat)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    
    // scaleで割ることで、ズーム対象となる矩形のサイズを決める
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width  = self.frame.size.width  / scale;
    
    // 矩形の中心をズームの中心にする
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

-(CGFloat)nextScale {
    if (self.zoomScale < 1.75)
        return 1.75;
    
    if (self.zoomScale >= 1.75 && self.zoomScale < self.maximumZoomScale)
        return self.maximumZoomScale;
    
    return self.minimumZoomScale;
}

-(void)resetZoom
{
    if (self.zoomScale != 1.0) {
        [self setZoomScale:self.minimumZoomScale animated:NO];
        [self zoomToRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height ) animated:NO];
        self.contentSize = CGSizeMake(self.frame.size.width * self.zoomScale, self.frame.size.height * self.zoomScale );
    }
}

#pragma mark UIScrollViewDelegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.ivContent;
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    
}

-(void)dealloc
{
    self.delegate = nil;
    self.ivContent=nil;
    
//    [super dealloc];
}
@end
