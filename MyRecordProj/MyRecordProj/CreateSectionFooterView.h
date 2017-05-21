//
//  CreateSectionFooterView.h
//  MyRecordProj
//
//  Created by  qin on 2017/5/21.
//  Copyright © 2017年  qin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreateSectionFooterViewActionDelegate <NSObject>

-(void)footerButtonDidTappedWithButton:(UIButton *)btnTapped;

@end

@interface CreateSectionFooterView : UIView
@property (weak, nonatomic) IBOutlet UIButton *btnAddSection;
- (IBAction)addBtnDidTap:(id)sender;

@property (weak, nonatomic) id<CreateSectionFooterViewActionDelegate> actionDelegate;
@end
