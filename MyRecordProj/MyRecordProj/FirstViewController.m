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


@interface FirstViewController () <UITableViewDelegate,UITableViewDataSource>
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
    if (recordCount > 0) {
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

#pragma mark memoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        return 40;
    }
    return 0;
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
        
        cell2ret=topCatInfoCell;
    }
    
    [cell2ret setNeedsLayout];
    return cell2ret;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.categoryArr.count;
}
@end
