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

@end

@interface CreateSectionImgTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblImgDesc;
@property (weak, nonatomic) IBOutlet UICollectionView *cvImgs;

@property (nonatomic,strong) NSMutableArray *imgArr;
@property (assign, nonatomic) NSInteger cellIndex;
@property (weak, nonatomic) id<CreateSectionImageActionDelegate> actionDelegate;
@end
