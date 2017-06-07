//
//  RecordInfo.m
//  MyRecordProj
//
//  Created by  qin on 2017/5/16.
//  Copyright © 2017年  qin. All rights reserved.
//

#import "RecordInfo.h"
#import "RecordSection.h"
#import "RecordSectionItem.h"

@implementation RecordInfo
- (NSArray *)getAllImageSectionItem
{
    NSMutableArray *imgArr2ret=[NSMutableArray new];
    
    for (RecordSection *aSection in self.sectionArr) {
        if ([SECTION_TYPE_IMAGE isEqualToString:aSection.sectionType]) {
            if (nil != aSection.sectionItemArr && aSection.sectionItemArr.count > 0) {
                for (RecordSectionItem *aItem in aSection.sectionItemArr) {
                    aItem.isLastItem=false;
                }
                RecordSectionItem *lastItem=aSection.sectionItemArr.lastObject;
                lastItem.isLastItem=true;
                
                [imgArr2ret addObjectsFromArray:aSection.sectionItemArr];
            }
        }
    }
    
    return imgArr2ret;
}
@end
