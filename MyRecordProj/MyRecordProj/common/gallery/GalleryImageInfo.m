//
//  GalleryImageInfo.m
//  wowtalkbiz
//
//  Created by wowtech on 2017/4/24.
//  Copyright © 2017年 wowtech. All rights reserved.
//

#import "GalleryImageInfo.h"
#import "MyCommonHeaders.h"
#import "RecordSectionItem.h"

@implementation GalleryImageInfo
+(NSArray *)makeImageInfoFromRecordSectionItems:(NSArray *)sectionItems
{
    NSMutableArray *arr2ret=[NSMutableArray new];
    
    for (RecordSectionItem *aItem in sectionItems) {
        GalleryImageInfo *aImageInfo=[[GalleryImageInfo alloc] init];
        
        aImageInfo.thumbPath=[MyUtility getFilePathWithName:aItem.imgThumbId inDirectory:IMG_STORE_PATH_IN_DOC];
        
        aImageInfo.orgImagePath=[MyUtility getFilePathWithName:aItem.imgId inDirectory:IMG_STORE_PATH_IN_DOC];
        
        aImageInfo.orgModelForMediaInfo=aItem;
        
        [arr2ret addObject:aImageInfo];

    }
    
//    if([PublicFunctions isObjectAnArray:msgAlbumMediaArr]) {
//        for (MessageAlbumMedia *aMedia in msgAlbumMediaArr) {
//            GalleryImageInfo *aImageInfo=[[[GalleryImageInfo alloc] init] autorelease];
//            
//            NSString *filepath = [NSFileManager relativePathToDocumentFolderForFile:aMedia.mediaThumbId
//                                                                      WithSubFolder:SDK_MESSAGE_ALBUM_MEDIA_DIR
//                                                                      withExtention:aMedia.mediaExt];
//            NSString *absolutepath = [NSFileManager absolutePathForFileInDocumentFolder:filepath];
//            
//            aImageInfo.thumbPath=absolutepath;
//            
//            filepath = [NSFileManager relativePathToDocumentFolderForFile:aMedia.mediaFileId
//                                                            WithSubFolder:SDK_MESSAGE_ALBUM_MEDIA_DIR
//                                                            withExtention:aMedia.mediaExt];
//            absolutepath = [NSFileManager absolutePathForFileInDocumentFolder:filepath];
//            
//            aImageInfo.orgImagePath=absolutepath;
//            
//            aImageInfo.orgModelForMediaInfo=aMedia;
//            
//            [arr2ret addObject:aImageInfo];
////            UIImage *image = [UIImage imageWithContentsOfFile:absolutepath];
////            if (image) {
////                [contentCell.ivContent setImage:image];
////            } else {
////                [contentCell.ivContent setImage:[UIImage imageNamed:@"default_pic.png"]];
//        }
//    }
    
    return arr2ret;
}

@end
