//
//  FirstViewController.m
//  MyRecordProj
//
//  Created by  qin on 2017/5/8.
//  Copyright © 2017年  qin. All rights reserved.
//

#import "FirstViewController.h"
#import <MyIosFramework/MyIosFramework.h>
#import "DbHandler.h"

@interface FirstViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tbAllRecords;
@property (weak, nonatomic) IBOutlet UILabel *lblEmptyContent;

@property (strong, nonatomic) NSArray *categoryArr;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title=NSLocalizedString(@"nav_title_records", @"");
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(action2create)];
    
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
    
    self.lblEmptyContent.text=NSLocalizedString(@"record_empty_desc", @"");
    if (self.categoryArr.count <= 0) {
        self.lblEmptyContent.hidden=false;
    } else {
        self.lblEmptyContent.hidden=true;
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
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
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
    return 0;
}
@end
