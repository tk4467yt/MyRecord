//
//  RecordDetailViewController.m
//  MyRecordProj
//
//  Created by  qin on 2017/6/1.
//  Copyright © 2017年  qin. All rights reserved.
//

#import "RecordDetailViewController.h"
#import "RecordDetailTitleTableViewCell.h"
#import "RecordDetailTxtTableViewCell.h"
#import "RecordDetailImageTableViewCell.h"
#import "RecordCreateSectionInfo.h"
#import "MyCommonHeaders.h"
#import "RecordSection.h"
#import "RecordSectionItem.h"
#import "CreateRecordViewController.h"

@interface RecordDetailViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tbRecordDetail;

@property (strong, nonatomic) NSMutableArray *recordDetailSectionArr;
@end

@implementation RecordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title=NSLocalizedString(@"Detail", @"");
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Edit", @"") style:UIBarButtonItemStylePlain target:self action:@selector(action2edit)];
    
    [self.tbRecordDetail registerNib:[UINib nibWithNibName:@"RecordDetailTitleTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[CellIdInfo cellIdForRecordDetailTitle]];
    [self.tbRecordDetail registerNib:[UINib nibWithNibName:@"RecordDetailTxtTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[CellIdInfo cellIdForRecordDetailTxt]];
    [self.tbRecordDetail registerNib:[UINib nibWithNibName:@"RecordDetailImageTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[CellIdInfo cellIdForRecordDetailImage]];
    
    [[MyCustomNotificationObserver sharedObserver] addCustomOvserverWithDelegate:self andKey:CUSTOM_NOTIFICATION_FOR_DB_RECORD_INFO_UPDATE];
    
    [self updateRecordSections];
}

- (void)action2edit
{
    UIViewController *initVC=[MyUtility getInitViewControllerFromSB:@"CreateRecord" withBundle:nil];
    if (nil != initVC) {
        CreateRecordViewController *recordVC=(CreateRecordViewController *)initVC;
        recordVC.editingRecordInfo=[DbHandler getRecordInfoWithRecordId:self.recordInfo.recordId];
        [MyUtility pushViewControllerFromNav:self.navigationController withTargetVC:recordVC animated:YES];
    }
}

- (void)updateRecordSections
{
    self.recordDetailSectionArr=[NSMutableArray new];
    
    //title
    RecordCreateSectionInfo *titleSection=[RecordCreateSectionInfo infoForTitle];
    titleSection.txtContent=self.recordInfo.recordTitle;
    [self.recordDetailSectionArr addObject:titleSection];
    
    //sections
    for (int sectionIdx=0; sectionIdx<self.recordInfo.sectionArr.count; ++sectionIdx) {
        RecordSection *aSection=self.recordInfo.sectionArr[sectionIdx];
        if ([SECTION_TYPE_TXT isEqualToString:aSection.sectionType]) {
            if (1 == aSection.sectionItemArr.count) {
                RecordSectionItem *txtItem=aSection.sectionItemArr[0];
                RecordCreateSectionInfo *txtSection=[RecordCreateSectionInfo infoForText];
                txtSection.txtContent=txtItem.itemTxt;
                
                [self.recordDetailSectionArr addObject:txtSection];
            }
        } else if ([SECTION_TYPE_IMAGE isEqualToString:aSection.sectionType]) {
            if (aSection.sectionItemArr.count >= 1) {
                RecordCreateSectionInfo *imgSection=[RecordCreateSectionInfo infoForImage];
                for (RecordSectionItem *aImgItem in aSection.sectionItemArr) {
                    [imgSection.imgThumbArr addObject:aImgItem.imgThumbId];
                    [imgSection.imgOrgArr addObject:aImgItem.imgId];
                }
                
                [self.recordDetailSectionArr addObject:imgSection];
            }
        }
    }
    
    [self.tbRecordDetail reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark MyCustomNotificationActionDelegate
-(void)didReceivecMyCustomNotification:(NSDictionary *)notificationDict
{
    if (nil == notificationDict) {
        return;
    }
    NSString *key2check=notificationDict[MyCustomNotificationContent_key];
    if ([key2check isEqualToString:CUSTOM_NOTIFICATION_FOR_DB_RECORD_INFO_UPDATE]) {
        self.recordInfo=[DbHandler getRecordInfoWithRecordId:self.recordInfo.recordId];
        
        [self updateRecordSections];
    } else {
        [super didReceivecMyCustomNotification:notificationDict];
    }
}

#pragma mark override
-(void)screenOrientationChangedHandle
{
    [self.tbRecordDetail reloadData];
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height=0;
    
    RecordCreateSectionInfo *createSectionInfo=self.recordDetailSectionArr[indexPath.section];
    if (SectionTypeTitle == createSectionInfo.type) {
        height = [MyUtility getLabelHeightByWidth:[MyUtility screenWidth]-16 title:createSectionInfo.txtContent font:[UIFont systemFontOfSize:17]];
        height += 20;
    } else if (SectionTypeTxt == createSectionInfo.type ) {
        height = [MyUtility getLabelHeightByWidth:[MyUtility screenWidth]-16 title:createSectionInfo.txtContent font:[UIFont systemFontOfSize:15]];
        height += 20;
    } else if (SectionTypeImg == createSectionInfo.type) {
        height = [CellSizeInfo sizeForImageCVItem].height;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view2ret=[UIView new];
    view2ret.backgroundColor=self.tbRecordDetail.backgroundColor;
    
    return view2ret;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell2ret=nil;
    
    RecordCreateSectionInfo *createSectionInfo=self.recordDetailSectionArr[indexPath.section];
    if (SectionTypeTitle == createSectionInfo.type) {
        RecordDetailTitleTableViewCell *titleCell=[tableView dequeueReusableCellWithIdentifier:[CellIdInfo cellIdForRecordDetailTitle] forIndexPath:indexPath];
        titleCell.lblTitle.text=createSectionInfo.txtContent;
        
        cell2ret=titleCell;
    } else if (SectionTypeTxt == createSectionInfo.type) {
        RecordDetailTxtTableViewCell *txtCell=[tableView dequeueReusableCellWithIdentifier:[CellIdInfo cellIdForRecordDetailTxt] forIndexPath:indexPath];
        txtCell.lblText.text=createSectionInfo.txtContent;
        
        cell2ret=txtCell;
    } else if (SectionTypeImg == createSectionInfo.type) {
        RecordDetailImageTableViewCell *imgCell=[tableView dequeueReusableCellWithIdentifier:[CellIdInfo cellIdForRecordDetailImage] forIndexPath:indexPath];
        RecordSection *curSection=self.recordInfo.sectionArr[indexPath.section-1];
        imgCell.recordSectionItemArr=curSection.sectionItemArr;
        imgCell.parentVC=self;
        
        cell2ret=imgCell;
    } else {
        cell2ret=[UITableViewCell new];
    }
    return cell2ret;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.recordDetailSectionArr.count;
}
@end
