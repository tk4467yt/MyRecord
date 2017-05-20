//
//  RecordCreateSectionInfo.m
//  MyRecordProj
//
//  Created by  qin on 2017/5/20.
//  Copyright © 2017年  qin. All rights reserved.
//

#import "RecordCreateSectionInfo.h"

@implementation RecordCreateSectionInfo
+(RecordCreateSectionInfo *)infoForTitle
{
    RecordCreateSectionInfo *info2ret=[RecordCreateSectionInfo new];
    info2ret.type=SectionTypeTitle;
    info2ret.txtContent=@"";
    info2ret.imgThumbArr=nil;
    info2ret.imgOrgArr=nil;
    
    return info2ret;
}
+(RecordCreateSectionInfo *)infoForText
{
    RecordCreateSectionInfo *info2ret=[RecordCreateSectionInfo new];
    info2ret.type=SectionTypeTxt;
    info2ret.txtContent=@"";
    info2ret.imgThumbArr=nil;
    info2ret.imgOrgArr=nil;
    
    return info2ret;
}
+(RecordCreateSectionInfo *)infoForImage
{
    RecordCreateSectionInfo *info2ret=[RecordCreateSectionInfo new];
    info2ret.type=SectionTypeImg;
    info2ret.txtContent=@"";
    info2ret.imgThumbArr=[NSMutableArray new];
    info2ret.imgOrgArr=[NSMutableArray new];
    
    return info2ret;
}
@end
