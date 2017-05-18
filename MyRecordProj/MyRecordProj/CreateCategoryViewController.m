//
//  CreateCategoryViewController.m
//  MyRecordProj
//
//  Created by  qin on 2017/5/17.
//  Copyright © 2017年  qin. All rights reserved.
//

#import "CreateCategoryViewController.h"
#import "CategoryCreateTFTableViewCell.h"
#import "CategoryInfo.h"
#import "DbHandler.h"

@interface CreateCategoryViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tbCreateCategory;

@property (weak, nonatomic) UITextField *tfInput;
@end

@implementation CreateCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title=NSLocalizedString(@"alert_create_category", @"");
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(didAddCategory)];
}

-(void)didAddCategory
{
    NSString *title=self.tfInput.text;
    if (![MyUtility isStringNilOrZeroLength:title]) {
        CategoryInfo *info=[CategoryInfo new];
        info.categoryTitle=title;
        info.categoryId=nil;
        info.createTime=[[NSDate date] timeIntervalSince1970];
        
        [DbHandler addCategoryInfo:info];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        if (0 == indexPath.row) {
            return 50;
        }
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return 30;
    }
    
    return 0;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCreateTFTableViewCell *tfCell=[tableView dequeueReusableCellWithIdentifier:@"category_create_tf_cell_id" forIndexPath:indexPath];
    self.tfInput=tfCell.tfInput;
    
    return tfCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return NSLocalizedString(@"title_for_category_name", @"");
    }
    
    return nil;
}

@end
