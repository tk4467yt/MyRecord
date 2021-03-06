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
#import "CreateRecordViewController.h"
#import "RecordDetailViewController.h"

@interface FirstViewController () <UITableViewDelegate,UITableViewDataSource,RecordTopCatInfoActionDelegate,RecordBriefActionDelegate>
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
    [[MyCustomNotificationObserver sharedObserver] addCustomOvserverWithDelegate:self andKey:CUSTOM_NOTIFICATION_FOR_SETTING_VALUE_DID_CHANGE];
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
    
    [self.categoryArr addObject:[CategoryInfo getDefaultCategoryInfo]];
    
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

-(NSArray *)getRecordInfoArrForCategory:(NSString *)categoryId
{
    NSArray *recordInfoArr=self.allRecordInfoDict[categoryId];
    if (nil == recordInfoArr) {
        recordInfoArr=[DbHandler getRecordInfoWithCategoryId:categoryId];
        self.allRecordInfoDict[categoryId]=recordInfoArr;
    }
    
    return recordInfoArr;
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
        NSString *recordId=notificationDict[MyCustomNotificationContent_content];
        if ([MyUtility isObjectAnString:recordId] && ![MyUtility isStringNilOrZeroLength:recordId]) {
            //update exist recordInfoDict
            NSString *existCategoryId=nil;
            for (NSString *categoryId in self.allRecordInfoDict.allKeys) {
                NSArray *recordInfoArr=self.allRecordInfoDict[categoryId];
                for (RecordInfo *aInfo in recordInfoArr) {
                    if ([aInfo.recordId isEqualToString:recordId]) {
                        existCategoryId=categoryId;
                        break;
                    }
                }
                if (nil != existCategoryId) {
                    break;
                }
            }
            if (nil != existCategoryId) {
                [self.allRecordInfoDict removeObjectForKey:existCategoryId];
            }
            
            //update new
            RecordInfo *record=[DbHandler getRecordInfoWithRecordId:recordId];
            if (nil != record) {
                [self.allRecordInfoDict removeObjectForKey:record.categoryId];
            }
        } else {
            [self.allRecordInfoDict removeAllObjects];
        }
        [self updateRecordsInfo];
    } else if ([key2check isEqualToString:CUSTOM_NOTIFICATION_FOR_SETTING_VALUE_DID_CHANGE]) {
        [self.tbAllRecords reloadData];
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
        CategoryInfo *curCategory=self.categoryArr[indexPath.section];
        NSArray *recordInfoArr=[self getRecordInfoArrForCategory:curCategory.categoryId];
        
        NSInteger recordInfoIdx=indexPath.row-1;
        RecordInfo *recordInfo2use=nil;
        if (recordInfoIdx < recordInfoArr.count) {
            recordInfo2use=recordInfoArr[recordInfoIdx];
        }
        
        return [RecordBriefTableViewCell cellHeightWithRecordInfo:recordInfo2use];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view2ret=[UIView new];
    view2ret.backgroundColor=self.tbAllRecords.backgroundColor;
    
    return view2ret;
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
        
        if ([curCategory isDefaultCategory]) {
            topCatInfoCell.isDefaultCategory=true;
        } else {
            topCatInfoCell.isDefaultCategory=false;
        }
        
        cell2ret=topCatInfoCell;
    } else {
        NSArray *recordInfoArr=[self getRecordInfoArrForCategory:curCategory.categoryId];
        
        RecordBriefTableViewCell *recordBriefCell=[tableView dequeueReusableCellWithIdentifier:[CellIdInfo cellIdForRecordBrief] forIndexPath:indexPath];
        recordBriefCell.actionDelegate=self;
        
        NSInteger recordInfoIdx=indexPath.row-1;
        RecordInfo *recordInfo2use=nil;
        if (recordInfoIdx < recordInfoArr.count) {
            recordInfo2use=recordInfoArr[recordInfoIdx];
        }
        if (nil != recordInfo2use) {
            recordBriefCell.lblTitle.text=recordInfo2use.recordTitle;
            
            recordBriefCell.recordSectionItemArr=[recordInfo2use getAllImageSectionItem];
            
            recordBriefCell.recordInfoId=recordInfo2use.recordId;
        } else {
            recordBriefCell.lblTitle.text=@"";
            recordBriefCell.recordSectionItemArr=nil;
            
            recordBriefCell.recordInfoId=nil;
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
    UIAlertAction *addAction=[UIAlertAction actionWithTitle:NSLocalizedString(@"title_create_record", @"")
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action){
                                                               UIViewController *initVC=[MyUtility getInitViewControllerFromSB:@"CreateRecord" withBundle:nil];
                                                               if (nil != initVC) {
                                                                   CreateRecordViewController *recordVC=(CreateRecordViewController *)initVC;
                                                                   recordVC.targetCategoryId=catId;
                                                                   [MyUtility pushViewControllerFromNav:self.navigationController withTargetVC:recordVC animated:YES];
                                                               }
                                                           }];
    UIAlertAction *deleteAction=[UIAlertAction actionWithTitle:NSLocalizedString(@"delete", @"")
                                                                 style:UIAlertActionStyleDestructive
                                                               handler:^(UIAlertAction *action){
                                                                   [self alert2deleteCategory:catId];
                                                               }];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", @"")
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction *action){
                                                           
                                                       }];
    
    [alertVC addAction:changeNameAction];
    [alertVC addAction:addAction];
    [alertVC addAction:deleteAction];
    [alertVC addAction:cancelAction];
    
    alertVC.popoverPresentationController.sourceView=sourceView;
    alertVC.popoverPresentationController.sourceRect=sourceView.bounds;
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

-(void)alert2deleteCategory:(NSString *)categoryId
{
    UIAlertController *alertVC=[UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Are you sure to delete this category?", @"") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction=[UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"")
                                                     style:UIAlertActionStyleDestructive
                                                   handler:^(UIAlertAction *action){
                                                       [DbHandler deleteCategoryWithId:categoryId];
                                                   }];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", @"")
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction *action){
                                                           
                                                       }];
    
    [alertVC addAction:okAction];
    [alertVC addAction:cancelAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark override
-(void)screenOrientationChangedHandle
{
    [self.tbAllRecords reloadData];
}

#pragma mark RecordBriefActionDelegate
-(void)recordBriefActionForViewDetail:(NSString *)recordInfoId
{
    UIViewController *initVC=[MyUtility getInitViewControllerFromSB:@"RecordDetail" withBundle:nil];
    if (nil != initVC) {
        RecordDetailViewController *recordVC=(RecordDetailViewController *)initVC;
        recordVC.recordInfo=[DbHandler getRecordInfoWithRecordId:recordInfoId];
        [MyUtility pushViewControllerFromNav:self.navigationController withTargetVC:recordVC animated:YES];
    }
}
-(void)recordBriefActionForEdit:(NSString *)recordInfoId
{
    UIViewController *initVC=[MyUtility getInitViewControllerFromSB:@"CreateRecord" withBundle:nil];
    if (nil != initVC) {
        CreateRecordViewController *recordVC=(CreateRecordViewController *)initVC;
        recordVC.editingRecordInfo=[DbHandler getRecordInfoWithRecordId:recordInfoId];
        [MyUtility pushViewControllerFromNav:self.navigationController withTargetVC:recordVC animated:YES];
    }
}
-(void)recordBriefActionForDelete:(NSString *)recordInfoId
{
    UIAlertController *alertVC=[UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Are you sure to delete this record?", @"") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction=[UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"")
                                                         style:UIAlertActionStyleDestructive
                                                       handler:^(UIAlertAction *action){
                                                           [DbHandler deleteRecordInfoWithId:[DbHandler getRecordInfoWithRecordId:recordInfoId] andAutoDelMedia:YES];
                                                       }];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", @"")
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction *action){
                                                           
                                                       }];
    
    [alertVC addAction:okAction];
    [alertVC addAction:cancelAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}
@end
