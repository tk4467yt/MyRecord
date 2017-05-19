//
//  CategoryInfo.m
//  MyRecordProj
//
//  Created by  qin on 2017/5/16.
//  Copyright © 2017年  qin. All rights reserved.
//

#import "CategoryInfo.h"

NSString *kDefaultCategoryId=@"def_category_id";

@implementation CategoryInfo
+(CategoryInfo *)getDefaultCategoryInfo
{
    CategoryInfo *info2ret=[CategoryInfo new];
    info2ret.categoryId=kDefaultCategoryId;
    info2ret.categoryTitle=NSLocalizedString(@"def_category_name", @"");
    info2ret.createTime=0;
    
    return info2ret;
}
@end
