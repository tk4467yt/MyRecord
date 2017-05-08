//
//  TextContentCollectionReusableView.h
//  xbb
//
//  Created by  qin on 2017/3/26.
//  Copyright © 2017年  qin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CV_TEXT_CONTENT_REUSABLE_VIEW_CELL_ID @"text_content_cv_reusable_cell_id"

@interface TextContentCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *lblContent;

@end
