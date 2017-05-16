//
//  CategoryInfo.h
//  MyRecordProj
//
//  Created by  qin on 2017/5/16.
//  Copyright © 2017年  qin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryInfo : NSObject
@property (nonatomic,copy) NSString *categoryId;
@property (nonatomic,copy) NSString *categoryTitle;
@property (nonatomic,assign) UInt64 createTime;
@end
