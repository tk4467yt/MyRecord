//
//  PhotoSelectionAlbumDetailViewController.h
//  MyRecordProj
//
//  Created by  qin on 2017/5/28.
//  Copyright © 2017年  qin. All rights reserved.
//

#import <Photos/Photos.h>
#import "MyRootViewController.h"

@interface PhotoSelectionAlbumDetailViewController : MyRootViewController <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *cvAlbumItems;

@property (nonatomic, weak)   UIViewController *rootVC;
@property (nonatomic, strong) PHAssetCollection *assetCollection;
@end
