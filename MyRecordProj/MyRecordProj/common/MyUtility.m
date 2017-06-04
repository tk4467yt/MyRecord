//
//  MyUtility.m
//  xbb
//
//  Created by  qin on 2017/3/3.
//  Copyright © 2017年  qin. All rights reserved.
//

#import "MyUtility.h"

@implementation MyUtility

+(UIImage *)makeMaskImageForFrame:(UIImage *)img2use
{
    return [img2use resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 30, 30) resizingMode:UIImageResizingModeStretch];
}
+(UIImage *)makeResizeableImage:(UIImage *)img2use withCapInset:(UIEdgeInsets)capInset
{
    return [img2use resizableImageWithCapInsets:capInset resizingMode:UIImageResizingModeStretch];
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
    if (nil == img2write || [MyUtility isStringNilOrZeroLength:dirInDoc]) {
        return @"";
    }
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

+(void)deleteFileWithName:(NSString *)fileName inDirectory:(NSString *)dirInDoc
{
    if ([MyUtility isStringNilOrZeroLength:fileName] || [MyUtility isStringNilOrZeroLength:dirInDoc]) {
        return;
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    
    NSString *dirPath=[docDir stringByAppendingPathComponent:dirInDoc];
    NSString *filePath=[dirPath stringByAppendingPathComponent:fileName];
    
    NSFileManager *defManager=[NSFileManager defaultManager];
    if ([defManager fileExistsAtPath:dirPath]) {
        [defManager removeItemAtPath:filePath error:nil];
    }
}

+(UIImage *)scaleImage:(UIImage *)img2scale toSize:(CGSize)targetSize
{
    if (targetSize.width >= img2scale.size.width &&
        targetSize.height >= img2scale.size.height) {
        return img2scale;
    }
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
    
    UIGraphicsBeginImageContext(CGSizeMake(scaledWidth, scaledHeight));
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = CGPointZero;
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

+(NSString *)getFilePathWithName:(NSString *)fileName inDirectory:(NSString *)dirInDoc
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    
    NSString *dirPath=[docDir stringByAppendingPathComponent:dirInDoc];
    
    NSString *imgFullName=[dirPath stringByAppendingPathComponent:fileName];
    
    return imgFullName;
}

+(BOOL)isFileExistAtPath:(NSString *)filePath
{
    NSFileManager *defManager=[NSFileManager defaultManager];
    if (![defManager fileExistsAtPath:filePath]) {
        return false;
    }
    
    return true;
}

+(CGSize)maxSizeOfImage2handle
{
    return CGSizeMake(1024, 1024);
}

+(NSString *)matchedDynamicTypeTextStyleForFontSize:(CGFloat)fontSize
{
    NSString *textStyle=UIFontTextStyleHeadline;
    
    // be careful: UIFontTextStyleTitle1,UIFontTextStyleTitle2,UIFontTextStyleTitle3,UIFontTextStyleCallout is avaliable on ios9 and later
    if (fontSize > 17) {
        if (IS_IOS9) {
            textStyle = UIFontTextStyleTitle1;
        } else {
            textStyle = UIFontTextStyleHeadline;
        }
    } else if (17 == fontSize) {
        textStyle = UIFontTextStyleHeadline;
    } else if (16 == fontSize) {
        if (IS_IOS9) {
            textStyle = UIFontTextStyleCallout;
        } else {
            textStyle = UIFontTextStyleSubheadline;
        }
    } else if (15 == fontSize) {
        textStyle = UIFontTextStyleSubheadline;
    } else if (14 == fontSize) {
        textStyle = UIFontTextStyleSubheadline;
    } else if (13 == fontSize) {
        textStyle = UIFontTextStyleFootnote;
    } else if (12 == fontSize) {
        textStyle = UIFontTextStyleCaption1;
    } else if (fontSize <= 11) {
        textStyle = UIFontTextStyleCaption2;
    }
    
    return textStyle;
}

+(CGFloat)getFontPointSizeForDynamicTypeTextWithOriginalSize:(CGFloat)originalPointSize
{
    NSString *style=[MyUtility matchedDynamicTypeTextStyleForFontSize:originalPointSize];
    if ([MyUtility isStringNilOrZeroLength:style]) {
        style = UIFontTextStyleBody;
    }
    UIFontDescriptor *bodyFontDesciptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:style];
    
    CGFloat sizeRatio=1;
    if (originalPointSize < 11) {
        sizeRatio = originalPointSize/11;
    }
    
    return bodyFontDesciptor.pointSize*sizeRatio;
}

+(void)showAllDynamicTypeFontSize
{
    UIFontDescriptor *bodyFontDesciptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleTitle1];
    NSLog(@"%@: %f",@"title1",bodyFontDesciptor.pointSize);
    
    bodyFontDesciptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleTitle2];
    NSLog(@"%@: %f",@"title2",bodyFontDesciptor.pointSize);
    
    bodyFontDesciptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleTitle3];
    NSLog(@"%@: %f",@"title3",bodyFontDesciptor.pointSize);
    
    bodyFontDesciptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleHeadline];
    NSLog(@"%@: %f",@"headline",bodyFontDesciptor.pointSize);
    
    bodyFontDesciptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleSubheadline];
    NSLog(@"%@: %f",@"subheadline",bodyFontDesciptor.pointSize);
    
    bodyFontDesciptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    NSLog(@"%@: %f",@"body",bodyFontDesciptor.pointSize);
    
    bodyFontDesciptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleCallout];
    NSLog(@"%@: %f",@"callout",bodyFontDesciptor.pointSize);
    
    bodyFontDesciptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleFootnote];
    NSLog(@"%@: %f",@"footnote",bodyFontDesciptor.pointSize);
    
    bodyFontDesciptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleCaption1];
    NSLog(@"%@: %f",@"caption1",bodyFontDesciptor.pointSize);
    
    bodyFontDesciptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleCaption2];
    NSLog(@"%@: %f",@"caption2",bodyFontDesciptor.pointSize);
}

+(BOOL)appFollowSystemDynamicType
{
    return false;
}

+(CGFloat)pointSizeAdjustForDynamicTypeWithOriginalSize:(CGFloat)originalPointSize
{
    CGFloat curDynamicTypeSize=[MyUtility getFontPointSizeForDynamicTypeTextWithOriginalSize:originalPointSize];
    return (curDynamicTypeSize-originalPointSize);
}

+(void)prensentAlertVCFromSourceVC:(UIViewController *)fromVC withAnim:(BOOL)animation andContent:(NSString *)content
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:content
                                                                      preferredStyle:UIAlertControllerStyleAlert];
//    alertController.view.frame = [[UIScreen mainScreen] bounds];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"ok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }]];
    
    [fromVC presentViewController:alertController animated:YES completion:nil];
}

+ (NSString *)getTimeDescFromSeconds:(int)seconds
{
    int minute = seconds/60;
    int second = seconds - minute *60;
    
    return [NSString stringWithFormat:@"%02d : %02d", minute, second];
}

+(BOOL)isDeviceIpad
{
    return UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom;
}

@end
