//
//  RecordsTopCategoryInfoTableViewCell.h
//  MyRecordProj
//
//  Created by  qin on 2017/5/20.
//  Copyright © 2017年  qin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RecordTopCatInfoActionDelegate <NSObject>

-(void)recordTopCategoryInfoDidTapWithCategoryId:(NSString *)catId fromSourceView:(UIView *)sourceView;

@end

@interface RecordsTopCategoryInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblCategoryName;
@property (weak, nonatomic) IBOutlet UIImageView *ivActionInd;
@property (weak, nonatomic) IBOutlet UILabel *lblCount;

@property (copy, nonatomic) NSString *categoryId;
@property (weak, nonatomic) id<RecordTopCatInfoActionDelegate> actionDelegate;
@property (assign, nonatomic) BOOL isDefaultCategory;
@end
