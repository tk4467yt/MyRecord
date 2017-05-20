//
//  MyCustomTabbarViewController.m
//  MyRecordProj
//
//  Created by  qin on 2017/5/12.
//  Copyright © 2017年  qin. All rights reserved.
//

#import "MyCustomTabbarViewController.h"

@interface MyCustomTabbarViewController ()

@end

@implementation MyCustomTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    for (UITabBarItem *aItem in self.tabBar.items) {
        if (1 == aItem.tag) {
            aItem.title=NSLocalizedString(@"tabbar_title_records", @"");
            aItem.image=[UIImage imageNamed:@"nav_edit"];
            aItem.selectedImage=[UIImage imageNamed:@"nav_edit_p"];
        } else if (2 == aItem.tag) {
            aItem.title=NSLocalizedString(@"tabbar_title_settings", @"");
            aItem.image=[UIImage imageNamed:@"nav_settings"];
            aItem.selectedImage=[UIImage imageNamed:@"nav_settings_p"];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
