//
//  CagegorySelectViewController.m
//  MyRecordProj
//
//  Created by  qin on 2017/5/28.
//  Copyright © 2017年  qin. All rights reserved.
//

#import "CagegorySelectViewController.h"
#import "RecordsTopCategoryInfoTableViewCell.h"

@interface CagegorySelectViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tbCategory;

@property (strong, nonatomic) NSMutableArray *categoryArr;
@end

@implementation CagegorySelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title=NSLocalizedString(@"nav_title_records", @"");
    
    [self.tbCategory registerNib:[UINib nibWithNibName:@"RecordsTopCategoryInfoTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[CellIdInfo cellIdForRecordTopCategoryInfo]];
    
    [self updateRecordsInfo];
}

-(void)updateRecordsInfo
{
    self.categoryArr=[DbHandler getAllCategoryInfo];
    [self.categoryArr insertObject:[CategoryInfo getDefaultCategoryInfo] atIndex:0];
    
    [self.tbCategory reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark override
-(void)screenOrientationChangedHandle
{
    [self.tbCategory reloadData];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CategoryInfo *curCategory=self.categoryArr[indexPath.section];
    if (nil != self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(didSelectCategory:)]) {
        [self.actionDelegate didSelectCategory:curCategory];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.categoryArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell2ret=nil;
    
    CategoryInfo *curCategory=self.categoryArr[indexPath.section];
    if (0 == indexPath.row) {
        RecordsTopCategoryInfoTableViewCell *topCatInfoCell=[tableView dequeueReusableCellWithIdentifier:[CellIdInfo cellIdForRecordTopCategoryInfo] forIndexPath:indexPath];
        topCatInfoCell.lblCategoryName.text=curCategory.categoryTitle;
        topCatInfoCell.categoryId=curCategory.categoryId;
        topCatInfoCell.actionDelegate=nil;
        
        topCatInfoCell.isDefaultCategory=true;//hide all ivInd
        topCatInfoCell.lblCategoryName.userInteractionEnabled=false;
        
        cell2ret=topCatInfoCell;
    }
    
    [cell2ret setNeedsLayout];
    return cell2ret;
}

@end
