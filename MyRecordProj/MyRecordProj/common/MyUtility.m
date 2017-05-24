//
//  MyUtility.m
//  xbb
//
//  Created by  qin on 2017/3/3.
//  Copyright © 2017年  qin. All rights reserved.
//

#import "MyUtility.h"

@implementation MyUtility

+(UIImage *)makeMaskImageFroFrame:(UIImage *)img2use
{
    return [img2use resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 30, 30) resizingMode:UIImageResizingModeStretch];
}

+(BOOL)isStringNilOrZeroLength:(NSString *)str2check
{
    return nil == str2check || str2check == NULL || [str2check isKindOfClass:[NSNull class]] || str2check.length == 0;
}

+(void)pushViewControllerFromNav:(UINavigationController *)navVC withTargetVC:(UIViewController *)targetVC animated:(BOOL)anim
{
    targetVC.hidesBottomBarWhenPushed=true;
    [navVC pushViewController:targetVC animated:anim];
}

+(CGFloat)screenWidth
{
    return [UIScreen mainScreen].bounds.size.width;
}
+(CGFloat)screenHeight
{
    return [UIScreen mainScreen].bounds.size.height;
}
+(CGFloat)heightOfStatusBar
{
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    
    return rectStatus.size.height;
}

+(CGFloat)layoutMarginForLeftAndRightForView:(UIView *)view2check
{
    return view2check.layoutMargins.left+view2check.layoutMargins.right;
}

+(void)applyMaskImageToImageView:(UIImageView *)iv2mask withImage:(UIImage *)img2mask
{
    CALayer* maskLayer = [CALayer layer];
    maskLayer.frame = CGRectMake(0, 0, iv2mask.frame.size.width, iv2mask.frame.size.height);
    maskLayer.contents = (id)[img2mask CGImage];
    [iv2mask.layer setMask:maskLayer];
    iv2mask.layer.masksToBounds=true;
}

+ (CGFloat)getLabelHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont*)font
{
    static UILabel *label = nil;
    if (nil == label) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    label.frame=CGRectMake(0, 0, width, 0);
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    
    CGFloat height = label.frame.size.height;
    return height;
}

+(UIViewController *)getInitViewControllerFromSB:(NSString *)storyBoard withBundle:(NSBundle *)bundle
{
    if ([MyUtility isStringNilOrZeroLength:storyBoard]) {
        return nil;
    }
    if (nil == bundle) {
        bundle=[NSBundle mainBundle];
    }
    UIStoryboard *sb=[UIStoryboard storyboardWithName:storyBoard bundle:bundle];
    if (nil != sb) {
        return sb.instantiateInitialViewController;
    }
    
    return nil;
}

+(NSString *)makeUniqueIdWithMaxLength:(NSInteger)maxLen
{
    NSString *str2ret=[[[UIDevice currentDevice] identifierForVendor] UUIDString];
    str2ret=[NSString stringWithFormat:@"%@_%f",str2ret,[[NSDate date] timeIntervalSince1970]];
    if (str2ret.length > maxLen) {
        str2ret=[str2ret substringToIndex:maxLen-1];
    }
    return str2ret;
}

+(BOOL)isObjectAnString:(id)obj2check
{
    if ([obj2check isKindOfClass:NSString.class] || [obj2check isKindOfClass:NSMutableString.class]) {
        return true;
    }
    
    return false;
}

+(NSString *)writeImage:(UIImage *)img2write intoDirectory:(NSString *)dirInDoc
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    
    NSString *dirPath=[docDir stringByAppendingPathComponent:dirInDoc];
    
    NSFileManager *defManager=[NSFileManager defaultManager];
    if (![defManager fileExistsAtPath:dirPath]) {
        [defManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *imgName=[NSString stringWithFormat:@"%@.jpg",[MyUtility makeUniqueIdWithMaxLength:128]];
    NSData *imgData=UIImageJPEGRepresentation(img2write, 0.75);
    [imgData writeToFile:[dirPath stringByAppendingPathComponent:imgName] atomically:YES];
    
    return imgName;
}
+(NSString *)writeImageThumb:(UIImage *)img2write intoDirectory:(NSString *)dirInDoc
{
    UIImage *imgScaled=[MyUtility scaleImage:img2write toSize:CGSizeMake(200, 200)];
    return [MyUtility writeImage:imgScaled intoDirectory:dirInDoc];
}

+(UIImage *)scaleImage:(UIImage *)img2scale toSize:(CGSize)targetSize
{
    UIImage *sourceImage = img2scale;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (!CGSizeEqualToSize(imageSize, targetSize)) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    
    return newImage ;
}

+(UIImage *)getImageWithName:(NSString *)imgName andDir:(NSString *)dirInDoc
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    
    NSString *dirPath=[docDir stringByAppendingPathComponent:dirInDoc];
    
    NSFileManager *defManager=[NSFileManager defaultManager];
    if (![defManager fileExistsAtPath:dirPath]) {
        [defManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *imgFullName=[dirPath stringByAppendingPathComponent:imgName];
    
    return [UIImage imageWithContentsOfFile:imgFullName];
}

@end
