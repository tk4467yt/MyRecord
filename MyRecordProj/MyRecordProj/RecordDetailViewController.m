//
//  RecordDetailViewController.m
//  MyRecordProj
//
//  Created by  qin on 2017/6/1.
//  Copyright © 2017年  qin. All rights reserved.
//

#import "RecordDetailViewController.h"
#import "RecordDetailTitleTableViewCell.h"
#import "RecordDetailTxtTableViewCell.h"
#import "RecordDetailImageTableViewCell.h"
#import "RecordCreateSectionInfo.h"

@interface RecordDetailViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tbRecordDetail;

@property (strong, nonatomic) NSMutableArray *recordDetailSectionArr;
@end

@implementation RecordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title=NSLocalizedString(@"Detail", @"");
    
    [self.tbRecordDetail registerNib:[UINib nibWithNibName:@"RecordDetailTitleTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[CellIdInfo cellIdForRecordDetailTitle]];
    [self.tbRecordDetail registerNib:[UINib nibWithNibName:@"RecordDetailTxtTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[CellIdInfo cellIdForRecordDetailTxt]];
    [self.tbRecordDetail registerNib:[UINib nibWithNibName:@"RecordDetailImageTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[CellIdInfo cellIdForRecordDetailImage]];
    
    [self updateRecordSections];
}

- (void)updateRecordSections
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark override
-(void)screenOrientationChangedHandle
{
    [self.tbRecordDetail reloadData];
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
@end
