//
//  CreateRecordViewController.m
//  MyRecordProj
//
//  Created by  qin on 2017/5/14.
//  Copyright © 2017年  qin. All rights reserved.
//

#import "CreateRecordViewController.h"
#import "RecordCreateSectionInfo.h"
#import "CreateSectionTitleTableViewCell.h"
#import "CreateSectionTxtTableViewCell.h"
#import "CreateSectionImgTableViewCell.h"

@interface CreateRecordViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tbCreate;

@property (strong, nonatomic) NSMutableArray *createSectionArr;
@end

@implementation CreateRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title=NSLocalizedString(@"title_create_record", @"");
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(navActionForCreate)];
    
    [self.tbCreate registerNib:[UINib nibWithNibName:@"CreateSectionTitleTableViewCell" bundle:[NSBundle mainBundle]]
        forCellReuseIdentifier:[CellIdInfo cellIdForCreateSectionTitle]];
    [self.tbCreate registerNib:[UINib nibWithNibName:@"CreateSectionTxtTableViewCell" bundle:[NSBundle mainBundle]]
        forCellReuseIdentifier:[CellIdInfo cellIdForCreateSectionTxt]];
    [self.tbCreate registerNib:[UINib nibWithNibName:@"CreateSectionImgTableViewCell" bundle:[NSBundle mainBundle]]
        forCellReuseIdentifier:[CellIdInfo cellIdForCreateSectionImg]];
    
    [self updateCreateSection];
}

-(void)updateCreateSection
{
    self.createSectionArr=[NSMutableArray new];
    [self.createSectionArr addObject:[RecordCreateSectionInfo infoForTitle]];
    [self.createSectionArr addObject:[RecordCreateSectionInfo infoForText]];
    [self.createSectionArr addObject:[RecordCreateSectionInfo infoForImage]];
    
    [self.tbCreate reloadData];
}

-(void)navActionForCreate
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecordCreateSectionInfo *sectionInfo=self.createSectionArr[indexPath.row];
    switch (sectionInfo.type) {
        case SectionTypeTitle:
            return 100;
            break;
        case SectionTypeTxt:
            return 120;
            break;
        case SectionTypeImg:
            return 120;
            break;
        default:
            break;
    }
    return 0;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.createSectionArr.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell2ret=nil;
    
    RecordCreateSectionInfo *sectionInfo=self.createSectionArr[indexPath.row];
    if (SectionTypeTitle == sectionInfo.type) {
        CreateSectionTitleTableViewCell *titleCell=[tableView dequeueReusableCellWithIdentifier:[CellIdInfo cellIdForCreateSectionTitle]
                                                                                   forIndexPath:indexPath];
        titleCell.lblTitleDesc.text=NSLocalizedString(@"create_record_title_desc", @"");
        
        cell2ret=titleCell;
    } else if (SectionTypeTxt == sectionInfo.type) {
        CreateSectionTxtTableViewCell *txtCell=[tableView dequeueReusableCellWithIdentifier:[CellIdInfo cellIdForCreateSectionTxt]
                                                                                   forIndexPath:indexPath];
        txtCell.lblTxtDesc.text=NSLocalizedString(@"create_record_txt_desc", @"");
        
        cell2ret=txtCell;
    } else if (SectionTypeImg == sectionInfo.type) {
        CreateSectionImgTableViewCell *imgCell=[tableView dequeueReusableCellWithIdentifier:[CellIdInfo cellIdForCreateSectionImg]
                                                                                   forIndexPath:indexPath];
        imgCell.lblImgDesc.text=NSLocalizedString(@"create_record_img_desc", @"");
        
        cell2ret=imgCell;
    }
    
    [cell2ret setNeedsLayout];
    return cell2ret;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

@end
