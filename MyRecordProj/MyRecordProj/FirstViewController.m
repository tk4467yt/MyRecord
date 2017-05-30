//
//  FirstViewController.m
//  MyRecordProj
//
//  Created by  qin on 2017/5/8.
//  Copyright © 2017年  qin. All rights reserved.
//

#import "FirstViewController.h"
#import "MyCommonHeaders.h"
#import "DbHandler.h"
#import "RecordsTopCategoryInfoTableViewCell.h"
#import "CreateCategoryViewController.h"
#import "RecordBriefTableViewCell.h"

@interface FirstViewController () <UITableViewDelegate,UITableViewDataSource,RecordTopCatInfoActionDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbAllRecords;
@property (weak, nonatomic) IBOutlet UILabel *lblEmptyContent;

@property (strong, nonatomic) NSMutableArray *categoryArr;
@property (strong, nonatomic) NSMutableDictionary *allRecordInfoDict;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title=NSLocalizedString(@"nav_title_records", @"");
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(action2create)];

    [self.tbAllRecords registerNib:[UINib nibWithNibName:@"RecordsTopCategoryInfoTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[CellIdInfo cellIdForRecordTopCategoryInfo]];
    [self.tbAllRecords registerNib:[UINib nibWithNibName:@"RecordBriefTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[CellIdInfo cellIdForRecordBrief]];
    
    self.allRecordInfoDict=[NSMutableDictionary new];
    
    [self updateRecordsInfo];
    
    [self addObserverInfo];
}

-(void)addObserverInfo
{
    [[MyCustomNotificationObserver sharedObserver] addCustomOvserverWithDelegate:self andKey:CUSTOM_NOTIFICATION_FOR_DB_CATEGORY_INFO_UPDATE];
    [[MyCustomNotificationObserver sharedObserver] addCustomOvserverWithDelegate:self andKey:CUSTOM_NOTIFICATION_FOR_DB_RECORD_INFO_UPDATE];
}

-(void)action2create
{
    UIAlertController *alertVC=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *createRecordAction=[UIAlertAction actionWithTitle:NSLocalizedString(@"title_create_record", @"")
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action){
                                                                 UIViewController *createRecordVC=[MyUtility getInitViewControllerFromSB:@"CreateRecord" withBundle:nil];
                                                                 if (nil != createRecordVC) {
                                                                     [MyUtility pushViewControllerFromNav:self.navigationController withTargetVC:createRecordVC animated:YES];
                                                                 }
                                                             }];
    UIAlertAction *createCategoryAction=[UIAlertAction actionWithTitle:NSLocalizedString(@"alert_create_category", @"")
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action){
                                                                 UIViewController *createCategoryVC=[MyUtility getInitViewControllerFromSB:@"CreateCategory" withBundle:nil];
                                                                 if (nil != createCategoryVC) {
                                                                     [MyUtility pushViewControllerFromNav:self.navigationController withTargetVC:createCategoryVC animated:YES];
                                                                 }
                                                             }];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", @"")
                                                                 style:UIAlertActionStyleCancel
                                                               handler:^(UIAlertAction *action){
                                                                   
                                                               }];
    
    [alertVC addAction:createRecordAction];
    [alertVC addAction:createCategoryAction];
    [alertVC addAction:cancelAction];
    
    alertVC.popoverPresentationController.barButtonItem=self.navigationItem.rightBarButtonItem;
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

-(void)updateRecordsInfo
{
    self.categoryArr=[DbHandler getAllCategoryInfo];
    UInt64 recordCount=[DbHandler getAllRecordInfoCount];
    
    [self.categoryArr insertObject:[CategoryInfo getDefaultCategoryInfo] atIndex:0];
    
    self.lblEmptyContent.text=NSLocalizedString(@"record_empty_desc", @"");
    if (self.categoryArr.count > 1 || recordCount > 0) {
        self.lblEmptyContent.hidden=true;
    } else {
        self.lblEmptyContent.hidden=false;
    }
    
    [self.tbAllRecords reloadData];
}

-(CategoryInfo *)getCategoryInfoWithId:(NSString *)catId
{
    for (CategoryInfo *aInfo in self.categoryArr) {
        if ([aInfo.categoryId isEqualToString:catId]) {
            return aInfo;
        }
    }
    
    return nil;
}

#pragma mark MyCustomNotificationActionDelegate
-(void)didReceivecMyCustomNotification:(NSDictionary *)notificationDict
{
    if (nil == notificationDict) {
        return;
    }
    NSString *key2check=notificationDict[MyCustomNotificationContent_key];
    if ([key2check isEqualToString:CUSTOM_NOTIFICATION_FOR_DB_CATEGORY_INFO_UPDATE]) {
        [self updateRecordsInfo];
    } else if ([key2check isEqualToString:CUSTOM_NOTIFICATION_FOR_DB_RECORD_INFO_UPDATE]) {
        [self updateRecordsInfo];
    } else {
        [super didReceivecMyCustomNotification:notificationDict];
    }
}

#pragma mark memoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        return 50;
    } else {
        return 80;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CategoryInfo *curCategory=self.categoryArr[section];
    return (NSInteger)(1+curCategory.recordCount);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell2ret=nil;
    
    CategoryInfo *curCategory=self.categoryArr[indexPath.section];
    if (0 == indexPath.row) {
        RecordsTopCategoryInfoTableViewCell *topCatInfoCell=[tableView dequeueReusableCellWithIdentifier:[CellIdInfo cellIdForRecordTopCategoryInfo] forIndexPath:indexPath];
        topCatInfoCell.lblCategoryName.text=curCategory.categoryTitle;
        topCatInfoCell.categoryId=curCategory.categoryId;
        topCatInfoCell.lblCount.text=[NSString stringWithFormat:@"%lld",curCategory.recordCount];
        topCatInfoCell.actionDelegate=self;
        
        if ([curCategory.categoryId isEqualToString:kDefaultCategoryId]) {
            topCatInfoCell.isDefaultCategory=true;
        } else {
            topCatInfoCell.isDefaultCategory=false;
        }
        
        cell2ret=topCatInfoCell;
    } else {
        NSArray *recordInfoArr=self.allRecordInfoDict[curCategory.categoryId];
        if (nil == recordInfoArr) {
            recordInfoArr=[DbHandler getRecordInfoWithCategoryId:curCategory.categoryId];
            self.allRecordInfoDict[curCategory.categoryId]=recordInfoArr;
        }
        
        RecordBriefTableViewCell *recordBriefCell=[tableView dequeueReusableCellWithIdentifier:[CellIdInfo cellIdForRecordBrief] forIndexPath:indexPath];
        
        NSInteger recordInfoIdx=indexPath.row-1;
        if (recordInfoIdx < recordInfoArr.count) {
            RecordInfo *recordInfo2use=recordInfoArr[recordInfoIdx];
            
        }
        
        cell2ret=recordBriefCell;
    }
    
    [cell2ret setNeedsLayout];
    return cell2ret;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.categoryArr.count;
}

#pragma mark RecordTopCatInfoActionDelegate
-(void)recordTopCategoryInfoDidTapWithCategoryId:(NSString *)catId fromSourceView:(UIView *)sourceView
{
    UIAlertController *alertVC=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *changeNameAction=[UIAlertAction actionWithTitle:NSLocalizedString(@"change_name", @"")
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action){
                                                                 CreateCategoryViewController *createCategoryVC=(CreateCategoryViewController *)[MyUtility getInitViewControllerFromSB:@"CreateCategory" withBundle:nil];
                                                                 if (nil != createCategoryVC) {
                                                                     CategoryInfo *info2use=[self getCategoryInfoWithId:catId];
                                                                     createCategoryVC.origInfo=info2use;
                                                                     [MyUtility pushViewControllerFromNav:self.navigationController withTargetVC:createCategoryVC animated:YES];
                                                                 }
                                                             }];
    UIAlertAction *deleteAction=[UIAlertAction actionWithTitle:NSLocalizedString(@"delete", @"")
                                                                 style:UIAlertActionStyleDestructive
                                                               handler:^(UIAlertAction *action){
                                                                   [DbHandler deleteCategoryWithId:catId];
                                                               }];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", @"")
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction *action){
                                                           
                                                       }];
    
    [alertVC addAction:changeNameAction];
    [alertVC addAction:deleteAction];
    [alertVC addAction:cancelAction];
    
    alertVC.popoverPresentationController.sourceView=sourceView;
    alertVC.popoverPresentationController.sourceRect=sourceView.bounds;
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark override
-(void)screenOrientationChangedHandle
{
    [self.tbAllRecords reloadData];
}
@end
