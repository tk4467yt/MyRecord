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
            return 50;
            break;
        case SectionTypeTxt:
            return 80;
            break;
        case SectionTypeImg:
            return 80;
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
        
        cell2ret=titleCell;
    } else if (SectionTypeTxt == sectionInfo.type) {
        CreateSectionTxtTableViewCell *txtCell=[tableView dequeueReusableCellWithIdentifier:[CellIdInfo cellIdForCreateSectionTxt]
                                                                                   forIndexPath:indexPath];
        
        cell2ret=txtCell;
    } else if (SectionTypeImg == sectionInfo.type) {
        CreateSectionImgTableViewCell *imgCell=[tableView dequeueReusableCellWithIdentifier:[CellIdInfo cellIdForCreateSectionImg]
                                                                                   forIndexPath:indexPath];
        
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
