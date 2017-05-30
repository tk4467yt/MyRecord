//
//  RecordBriefTableViewCell.h
//  MyRecordProj
//
//  Created by  qin on 2017/5/30.
//  Copyright © 2017年  qin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCommonHeaders.h"

@protocol RecordBriefActionDelegate <NSObject>

-(void)recordBriefActionForViewDetail:(NSString *)recordInfoId;
-(void)recordBriefActionForEdit:(NSString *)recordInfoId;
-(void)recordBriefActionForDelete:(NSString *)recordInfoId;

@end

@interface RecordBriefTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ivBkgView;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UICollectionView *cvThumb;

@property (weak, nonatomic) IBOutlet UIView *btnHolder;
@property (weak, nonatomic) IBOutlet UIButton *btnDetail;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;

@property (nonatomic,strong) NSArray *recordSectionItemArr;
@property (nonatomic,copy) NSString  *recordInfoId;
@property (weak, nonatomic) id<RecordBriefActionDelegate> actionDelegate;

- (IBAction)btnDetailTapped:(UIButton *)sender;
- (IBAction)btnEditTapped:(UIButton *)sender;
- (IBAction)btnDeleteTapped:(UIButton *)sender;

+(CGFloat)cellHeightWithRecordInfo:(RecordInfo *)recordInfo;
@end
