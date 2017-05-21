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
#import "CreateSectionFooterView.h"

@interface CreateRecordViewController () <UITableViewDelegate,UITableViewDataSource,CreateSectionFooterViewActionDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbCreate;

@property (strong, nonatomic) CreateSectionFooterView *footerView;

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

#pragma mark CreateSectionFooterViewActionDelegate
-(void)footerButtonDidTappedWithButton:(UIButton *)btnTapped
{
    UIAlertController *alertVC=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *addTxtAction=[UIAlertAction actionWithTitle:NSLocalizedString(@"create_record_add_text", @"")
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action){
                                                                 [self.createSectionArr addObject:[RecordCreateSectionInfo infoForText]];
                                                                 [self.tbCreate reloadData];
                                                                 
                                                                 [self performSelector:@selector(action4scroll2bottom) withObject:nil afterDelay:0.3];
                                                             }];
    UIAlertAction *addImageAction=[UIAlertAction actionWithTitle:NSLocalizedString(@"create_record_add_image", @"")
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction *action){
                                                                   [self.createSectionArr addObject:[RecordCreateSectionInfo infoForImage]];
                                                                   [self.tbCreate reloadData];
                                                                   
                                                                   [self performSelector:@selector(action4scroll2bottom) withObject:nil afterDelay:0.3];
                                                               }];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", @"")
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction *action){
                                                           
                                                       }];
    
    [alertVC addAction:addTxtAction];
    [alertVC addAction:addImageAction];
    [alertVC addAction:cancelAction];
    
    alertVC.popoverPresentationController.sourceView=btnTapped;
    alertVC.popoverPresentationController.sourceRect=btnTapped.bounds;
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

-(void)action4scroll2bottom
{
    NSInteger countRows=[self.tbCreate numberOfRowsInSection:0];
    if (countRows > 0) {
        [self.tbCreate scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:countRows-1 inSection:0]
                             atScrollPosition:UITableViewScrollPositionBottom
                                     animated:YES];
    }
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
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 60;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (nil == self.footerView) {
        self.footerView=[[[NSBundle mainBundle] loadNibNamed:@"CreateSectionFooterView" owner:self options:nil] lastObject];
        self.footerView.actionDelegate=self;
        [self.footerView.btnAddSection setTitle:NSLocalizedString(@"create_record_add_more_desc", @"") forState:UIControlStateNormal];
    }
    
    return self.footerView;
}
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
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
