//
//  SettingsSwitchTableViewCell.h
//  MyRecordProj
//
//  Created by  qin on 2017/6/5.
//  Copyright © 2017年  qin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsSwitchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblSettingDesc;
@property (weak, nonatomic) IBOutlet UISwitch *settingSwitch;
@property (weak, nonatomic) IBOutlet UIImageView *ivBottom;

- (IBAction)settingSwitchValueDidChange:(UISwitch *)sender;

@property (nonatomic, copy) NSString *settingKey;
@end
