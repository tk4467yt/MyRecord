//
//  CreateSectionImgTableViewCell.h
//  MyRecordProj
//
//  Created by  qin on 2017/5/20.
//  Copyright © 2017年  qin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreateSectionImageActionDelegate <NSObject>

-(void)imageActionForAddImageWithCellIndex:(NSInteger)cellIdx andSourceView:(UIView *)sourceView;
-(void)imageActionForDelSectionWithCellIndex:(NSInteger)cellIdx;

@end

@interface CreateSectionImgTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblImgDesc;
@property (weak, nonatomic) IBOutlet UICollectionView *cvImgs;
@property (weak, nonatomic) IBOutlet UIImageView *ivDel;

@property (nonatomic,strong) NSMutableArray *thumbImgArr;
@property (nonatomic,strong) NSMutableArray *orgImgArr;
@property (assign, nonatomic) NSInteger cellIndex;
@property (weak, nonatomic) UIViewController<CreateSectionImageActionDelegate> *actionDelegate;
@end
