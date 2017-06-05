//
//  SettingsSwitchTableViewCell.m
//  MyRecordProj
//
//  Created by  qin on 2017/6/5.
//  Copyright © 2017年  qin. All rights reserved.
//

#import "SettingsSwitchTableViewCell.h"
#import "MyCommonHeaders.h"

@implementation SettingsSwitchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.ivBottom.backgroundColor=[MyColor defBackgroundColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)settingSwitchValueDidChange:(UISwitch *)sender {
    if (![MyUtility isStringNilOrZeroLength:self.settingKey]) {
        [DbHandler setSettingWithKey:self.settingKey withValue:[NSString stringWithFormat:@"%d",sender.on]];
    }
}
@end
