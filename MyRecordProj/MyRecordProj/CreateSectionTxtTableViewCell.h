//
//  CreateSectionTxtTableViewCell.h
//  MyRecordProj
//
//  Created by  qin on 2017/5/20.
//  Copyright © 2017年  qin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreateSectionTextActionDelegate <NSObject>

-(void)textActionForDelSectionWithCellIndex:(NSInteger)cellIdx;

@end

@interface CreateSectionTxtTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTxtDesc;
@property (weak, nonatomic) IBOutlet UITextView *tvTxtContent;
@property (weak, nonatomic) IBOutlet UILabel *lblLimit;
@property (weak, nonatomic) IBOutlet UIImageView *ivDel;

@property (assign, nonatomic) NSInteger cellIndex;
@property (weak, nonatomic) id<CreateSectionTextActionDelegate> actionDelegate;
@end
