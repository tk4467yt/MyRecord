//
//  RecordInfo.h
//  MyRecordProj
//
//  Created by  qin on 2017/5/16.
//  Copyright © 2017年  qin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IMG_STORE_PATH_IN_DOC @"images"

@interface RecordInfo : NSObject
@property (nonatomic,copy) NSString *recordId;
@property (nonatomic,copy) NSString *recordTitle;
@property (nonatomic,assign) UInt64 createTime;
@property (nonatomic,copy) NSString *categoryId;

@property (nonatomic,strong) NSMutableArray *sectionArr;
@end
