//
//  CreateSectionHeaderView.h
//  MyRecordProj
//
//  Created by  qin on 2017/5/28.
//  Copyright © 2017年  qin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreateSectionHeaderViewActionDelegate <NSObject>

-(void)headerButtonDidTappedWithButton:(UIButton *)btnTapped;

@end

@interface CreateSectionHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;
@property (weak, nonatomic) IBOutlet UIButton *btnCategory;
- (IBAction)btnCategoryTapped:(id)sender;

@property (weak, nonatomic) id<CreateSectionHeaderViewActionDelegate> headerActionDelegate;
@end
