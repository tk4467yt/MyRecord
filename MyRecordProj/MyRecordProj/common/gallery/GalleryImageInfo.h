//
//  GalleryImageInfo.h
//  wowtalkbiz
//
//  Created by wowtech on 2017/4/24.
//  Copyright © 2017年 wowtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GalleryImageInfo : NSObject
@property (nonatomic,copy) NSString *thumbPath;
@property (nonatomic,copy) NSString *orgImagePath;

@property (nonatomic,retain) id orgModelForMediaInfo;

+(NSArray *)makeImageInfoFromRecordSectionItems:(NSArray *)sectionItems;
@end
