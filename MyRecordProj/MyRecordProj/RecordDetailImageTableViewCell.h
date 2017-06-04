//
//  RecordDetailImageTableViewCell.h
//  MyRecordProj
//
//  Created by  qin on 2017/6/2.
//  Copyright © 2017年  qin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordDetailImageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *cvImage;

@property (nonatomic,strong) NSArray *recordSectionItemArr;
@property (nonatomic,weak) UIViewController *parentVC;
@end
