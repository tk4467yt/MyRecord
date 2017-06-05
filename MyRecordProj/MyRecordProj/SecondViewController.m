//
//  SecondViewController.m
//  MyRecordProj
//
//  Created by  qin on 2017/5/8.
//  Copyright © 2017年  qin. All rights reserved.
//

#import "SecondViewController.h"
#import "SettingsSwitchTableViewCell.h"

@interface SecondViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tbSettings;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title=NSLocalizedString(@"nav_title_settings", @"");
    
    [self.tbSettings registerNib:[UINib nibWithNibName:@"SettingsSwitchTableViewCell" bundle:[NSBundle mainBundle]]
          forCellReuseIdentifier:[CellIdInfo cellIdForSettingSwitch]];
    
    [self addObserverInfo];
}

-(void)addObserverInfo
{
    [[MyCustomNotificationObserver sharedObserver] addCustomOvserverWithDelegate:self andKey:CUSTOM_NOTIFICATION_FOR_SETTING_VALUE_DID_CHANGE];
}

#pragma mark override
-(void)screenOrientationChangedHandle
{
    [self.tbSettings reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark MyCustomNotificationActionDelegate
-(void)didReceivecMyCustomNotification:(NSDictionary *)notificationDict
{
    if (nil == notificationDict) {
        return;
    }
    NSString *key2check=notificationDict[MyCustomNotificationContent_key];
    if ([key2check isEqualToString:CUSTOM_NOTIFICATION_FOR_SETTING_VALUE_DID_CHANGE]) {
        [self.tbSettings reloadData];
    } else {
        [super didReceivecMyCustomNotification:notificationDict];
    }
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        return 50;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view2ret=[UIView new];
    view2ret.backgroundColor=self.tbSettings.backgroundColor;
    
    return view2ret;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell2ret=nil;
    
    if (0 == indexPath.section) {
        if (0 == indexPath.row) {
            SettingsSwitchTableViewCell *topCatInfoCell=[tableView dequeueReusableCellWithIdentifier:[CellIdInfo cellIdForSettingSwitch] forIndexPath:indexPath];
            topCatInfoCell.lblSettingDesc.text=NSLocalizedString(@"view_thumb_with_large_size", @"");
            topCatInfoCell.settingKey=SETTING_KEY_4_THUMB_WITH_LARGE_SIZE;
            
            BOOL isOn=[DbHandler getIntSettingWithKey:topCatInfoCell.settingKey andDefValue:0];
            topCatInfoCell.settingSwitch.on=isOn;
            
            cell2ret=topCatInfoCell;
        }
    }
    
    [cell2ret setNeedsLayout];
    return cell2ret;
}

@end
