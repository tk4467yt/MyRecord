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

@interface FirstViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tbAllRecords;
@property (weak, nonatomic) IBOutlet UILabel *lblEmptyContent;

@property (strong, nonatomic) NSArray *categoryArr;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title=NSLocalizedString(@"nav_title_records", @"");
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createNewRecord)];
    
    [self updateRecordsInfo];
}

-(void)createNewRecord
{
    UIViewController *createRecordVC=[MyUtility getInitViewControllerFromSB:@"CreateRecord" withBundle:nil];
    if (nil != createRecordVC) {
        [MyUtility pushViewControllerFromNav:self.navigationController withTargetVC:createRecordVC animated:YES];
    }
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


@end
