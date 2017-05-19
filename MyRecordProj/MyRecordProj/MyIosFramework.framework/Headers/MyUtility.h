//
//  MyUtility.h
//  xbb
//
//  Created by  qin on 2017/3/3.
//  Copyright © 2017年  qin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MyUtility : NSObject
+(UIImage *)makeMaskImageFroFrame:(UIImage *)img2use;

+(BOOL)isStringNilOrZeroLength:(NSString *)str2check;
+(void)pushViewControllerFromNav:(UINavigationController *)navVC withTargetVC:(UIViewController *)targetVC animated:(BOOL)anim;

+(CGFloat)screenWidth;
+(CGFloat)screenHeight;
+(CGFloat)heightOfStatusBar;
+(CGFloat)layoutMarginForLeftAndRightForView:(UIView *)view2check;

+(void)applyMaskImageToImageView:(UIImageView *)iv2mask withImage:(UIImage *)img2mask;

+ (CGFloat)getLabelHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont*)font;

+(UIViewController *)getInitViewControllerFromSB:(NSString *)storyBoard withBundle:(NSBundle *)bundle;

+(NSString *)makeUniqueIdWithMaxLength:(NSInteger)maxLen;
@end
