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
#define CUSTOM_NOTIFICATION_FOR_SETTING_VALUE_DID_CHANGE @"custom_notification_for_setting_value_did_change"

#define SETTING_KEY_4_THUMB_WITH_LARGE_SIZE @"setting_key_4_thumb_with_large_size"

@interface DbHandler : NSObject
+(void)initLocalDatabase;
+(void)closeLocalDatabase;

+(NSMutableArray *)getAllCategoryInfo;
+(CategoryInfo *)getCategoryInfoWithId:(NSString *)categoryId;
+(void)addOrUpdateCategoryInfo:(CategoryInfo *)info;
+(void)deleteCategoryWithId:(NSString *)categoryId;


+(NSArray *)getRecordInfoWithCategoryId:(NSString *)categoryId;
+(RecordInfo *)getRecordInfoWithRecordId:(NSString *)recordId;
+(UInt64)getAllRecordInfoCount;
+(UInt64)getRecordInfoCountForCategory:(NSString *)categoryId;

+(void)storeRecordWithInfo:(RecordInfo *)record2store;
+(void)deleteRecordInfoWithId:(RecordInfo *)record2del andAutoDelMedia:(BOOL)autoDelMedia;

+(NSString *)getStrSettingWithKey:(NSString *)key andDefValue:(NSString *)defStr;
+(UInt64)getIntSettingWithKey:(NSString *)key andDefValue:(UInt64)defInt;
+(void)setSettingWithKey:(NSString *)key withValue:(NSString *)value;
@end
