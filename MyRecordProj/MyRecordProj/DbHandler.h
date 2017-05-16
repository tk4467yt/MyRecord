//
//  DbHandler.h
//  MyRecordProj
//
//  Created by  qin on 2017/5/14.
//  Copyright © 2017年  qin. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSInteger kDbIdDefaultSize;
extern const NSInteger kDbIdRecordTitleSize;
extern const NSInteger kDbIdRecordItemTxtSize;
extern const NSInteger kDbIdCategoryTitleSize;

@interface DbHandler : NSObject
+(void)initLocalDatabase;
+(void)closeLocalDatabase;

+(NSArray *)getAllCategoryInfo;
+(NSArray *)getRecordInfoWithCategoryId:(NSString *)categoryId;

+(NSString *)getStrSettingWithKey:(NSString *)key andDefValue:(NSString *)defStr;
+(NSInteger)getIntSettingWithKey:(NSString *)key andDefValue:(NSInteger)defInt;
@end
