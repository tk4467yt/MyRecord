//
//  CategoryInfo.m
//  MyRecordProj
//
//  Created by  qin on 2017/5/16.
//  Copyright © 2017年  qin. All rights reserved.
//

#import "CategoryInfo.h"
#import "MyCommonHeaders.h"

NSString *kDefaultCategoryId=@"def_category_id";

@implementation CategoryInfo
+(CategoryInfo *)getDefaultCategoryInfo
{
    CategoryInfo *info2ret=[CategoryInfo new];
    info2ret.categoryId=kDefaultCategoryId;
    info2ret.categoryTitle=NSLocalizedString(@"def_category_name", @"");
    info2ret.createTime=0;
    
    info2ret.recordCount=[DbHandler getRecordInfoCountForCategory:info2ret.categoryId];
    
    return info2ret;
}
-(BOOL)isDefaultCategory
{
    return [self.categoryId isEqualToString:kDefaultCategoryId];
}
@end
