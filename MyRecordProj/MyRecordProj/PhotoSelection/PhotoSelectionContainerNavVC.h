//
//  PhotoSelectionContainerNavVC.h
//  MyRecordProj
//
//  Created by  qin on 2017/5/25.
//  Copyright © 2017年  qin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoSelectionActionDelegate

- (void)photoSelectionFinishWithImageArr:(NSArray *)imgArr;
- (void)photoSelectionCancel;

@end

@interface PhotoSelectionContainerNavVC : UINavigationController
@property (nonatomic, weak) id<PhotoSelectionActionDelegate> photoSelectionDelegate;
@end
