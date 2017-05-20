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

@interface FirstViewController () <UITableViewDelegate,UITableViewDataSource,RecordTopCatInfoActionDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbAllRecords;
@property (weak, nonatomic) IBOutlet UILabel *lblEmptyContent;

@property (strong, nonatomic) NSMutableArray *categoryArr;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title=NSLocalizedString(@"nav_title_records", @"");
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(action2create)];
    
    [self.tbAllRecords registerNib:[UINib nibWithNibName:@"RecordsTopCategoryInfoTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[CellIdInfo cellIdForRecordTopCategoryInfo]];
    
    [self updateRecordsInfo];
}

-(void)action2create
{
    UIAlertController *alertVC=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *createRecordAction=[UIAlertAction actionWithTitle:NSLocalizedString(@"alert_create_record", @"")
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
    if (self.categoryArr.count > 0 || recordCount > 0) {
        [self.categoryArr insertObject:[CategoryInfo getDefaultCategoryInfo] atIndex:0];
    }
    
    self.lblEmptyContent.text=NSLocalizedString(@"record_empty_desc", @"");
    if (self.categoryArr.count <= 0) {
        self.lblEmptyContent.hidden=false;
    } else {
        self.lblEmptyContent.hidden=true;
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
    }
    return 0;
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell2ret=nil;
    
    CategoryInfo *curCategory=self.categoryArr[indexPath.section];
    if (0 == indexPath.row) {
        RecordsTopCategoryInfoTableViewCell *topCatInfoCell=[tableView dequeueReusableCellWithIdentifier:[CellIdInfo cellIdForRecordTopCategoryInfo] forIndexPath:indexPath];
        topCatInfoCell.lblCategoryName.text=curCategory.categoryTitle;
        topCatInfoCell.categoryId=curCategory.categoryId;
        topCatInfoCell.actionDelegate=self;
        
        if ([curCategory.categoryId isEqualToString:kDefaultCategoryId]) {
            topCatInfoCell.isDefaultCategory=true;
        } else {
            topCatInfoCell.isDefaultCategory=false;
        }
        
        cell2ret=topCatInfoCell;
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
    alertVC.popoverPresentationController.sourceRect=sourceView.frame;
    
    [self presentViewController:alertVC animated:YES completion:nil];
}
@end
