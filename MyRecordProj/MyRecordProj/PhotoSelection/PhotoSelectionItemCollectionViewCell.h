//
//  PhotoSelectionItemCollectionViewCell.h
//  MyRecordProj
//
//  Created by  qin on 2017/5/28.
//  Copyright © 2017年  qin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoSelectionItemCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ivThumb;
@property (weak, nonatomic) IBOutlet UIImageView *ivVideoInd;
@property (weak, nonatomic) IBOutlet UILabel *lblVideoDuration;

@end
