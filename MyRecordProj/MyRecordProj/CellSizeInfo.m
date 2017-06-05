//
//  CellSizeInfo.m
//  MyRecordProj
//
//  Created by  qin on 2017/6/2.
//  Copyright © 2017年  qin. All rights reserved.
//

#import "CellSizeInfo.h"
#import "DbHandler.h"
#import "MyUtility.h"

@implementation CellSizeInfo
+(CGSize)sizeForImageCVItem
{
    BOOL isOn=[DbHandler getIntSettingWithKey:SETTING_KEY_4_THUMB_WITH_LARGE_SIZE andDefValue:0];
    if (isOn) {
        if ([MyUtility isDeviceIpad]) {
            return CGSizeMake(320, 320);
        } else {
            return CGSizeMake(180, 180);
        }
    } else {
        if ([MyUtility isDeviceIpad]) {
            return CGSizeMake(120, 120);
        } else {
            return CGSizeMake(100, 100);
        }
    }
}
@end
