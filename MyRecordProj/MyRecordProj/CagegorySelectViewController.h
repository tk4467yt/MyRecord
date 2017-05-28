//
//  CagegorySelectViewController.h
//  MyRecordProj
//
//  Created by  qin on 2017/5/28.
//  Copyright © 2017年  qin. All rights reserved.
//

#import "MyRootViewController.h"
#import "MyCommonHeaders.h"

@protocol CategorySelectActionDelegate <NSObject>

-(void)didSelectCategory:(CategoryInfo *)categoryInfo;

@end

@interface CagegorySelectViewController : MyRootViewController
@property (weak, nonatomic) id<CategorySelectActionDelegate> actionDelegate;
@end
