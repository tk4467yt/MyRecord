//
//  RecordBriefTableViewCell.h
//  MyRecordProj
//
//  Created by  qin on 2017/5/30.
//  Copyright © 2017年  qin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordBriefTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UICollectionView *cvThumb;

@end
