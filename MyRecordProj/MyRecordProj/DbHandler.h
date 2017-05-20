//
//  DbHandler.h
//  MyRecordProj
//
//  Created by  qin on 2017/5/14.
//  Copyright © 2017年  qin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryInfo.h"
#import "RecordInfo.h"

extern const NSInteger kDbIdDefaultSize;
extern const NSInteger kDbIdRecordTitleSize;
extern const NSInteger kDbIdRecordItemTxtSize;
extern const NSInteger kDbIdCategoryTitleSize;

#define CUSTOM_NOTIFICATION_FOR_DB_CATEGORY_INFO_UPDATE @"custom_notification_for_db_category_info_update"
#define CUSTOM_NOTIFICATION_FOR_DB_RECORD_INFO_UPDATE @"custom_notification_for_db_record_info_update"

@interface DbHandler : NSObject
+(void)initLocalDatabase;
+(void)closeLocalDatabase;

+(NSMutableArray *)getAllCategoryInfo;
+(void)addOrUpdateCategoryInfo:(CategoryInfo *)info;
+(void)deleteCategoryWithId:(NSString *)categoryId;


+(NSArray *)getRecordInfoWithCategoryId:(NSString *)categoryId;
+(UInt64)getAllRecordInfoCount;

+(NSString *)getStrSettingWithKey:(NSString *)key andDefValue:(NSString *)defStr;
+(UInt64)getIntSettingWithKey:(NSString *)key andDefValue:(UInt64)defInt;
@end
