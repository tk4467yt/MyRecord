//
//  PhotoSelectionAlbumTableViewCell.h
//  MyRecordProj
//
//  Created by  qin on 2017/5/28.
//  Copyright © 2017年  qin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoSelectionAlbumTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ivThumb;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblNumber;
@property (weak, nonatomic) IBOutlet UIImageView *ivRightInd;
@property (weak, nonatomic) IBOutlet UIImageView *ivBottomSep;

@end
