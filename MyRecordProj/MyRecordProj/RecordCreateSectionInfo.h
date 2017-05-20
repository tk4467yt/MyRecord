//
//  RecordCreateSectionInfo.h
//  MyRecordProj
//
//  Created by  qin on 2017/5/20.
//  Copyright © 2017年  qin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    SectionTypeTitle,
    SectionTypeTxt,
    SectionTypeImg,
} SectionType;

@interface RecordCreateSectionInfo : NSObject
@property (nonatomic,assign) SectionType type;

@property (nonatomic,copy) NSString *txtContent;

@property (nonatomic,retain) NSMutableArray *imgThumbArr;
@property (nonatomic,retain) NSMutableArray *imgOrgArr;

+(RecordCreateSectionInfo *)infoForTitle;
+(RecordCreateSectionInfo *)infoForText;
+(RecordCreateSectionInfo *)infoForImage;
@end
