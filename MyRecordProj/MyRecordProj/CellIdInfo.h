//
//  CellIdInfo.h
//  MyRecordProj
//
//  Created by  qin on 2017/5/20.
//  Copyright © 2017年  qin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellIdInfo : NSObject
+(NSString *)cellIdForRecordTopCategoryInfo;

+(NSString *)cellIdForCreateSectionTitle;
+(NSString *)cellIdForCreateSectionTxt;
+(NSString *)cellIdForCreateSectionImg;
+(NSString *)cellIdForImageCVCellId;
+(NSString *)cellIdForRecordBrief;

+(NSString *)cellIdForRecordDetailTitle;
+(NSString *)cellIdForRecordDetailTxt;
+(NSString *)cellIdForRecordDetailImage;
+(NSString *)cellIdForSettingSwitch;
@end
