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
#import "CreateSectionHeaderView.h"
#import "MyCommonHeaders.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "PhotoSelectionContainerNavVC.h"
#import "CagegorySelectViewController.h"
#import "RecordSection.h"
#import "RecordSectionItem.h"

@interface CreateRecordViewController () <UITableViewDelegate,UITableViewDataSource,CreateSectionFooterViewActionDelegate,UITextViewDelegate,CreateSectionImageActionDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,PhotoSelectionActionDelegate,CreateSectionHeaderViewActionDelegate,CategorySelectActionDelegate,CreateSectionTextActionDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbCreate;

@property (strong, nonatomic) CreateSectionFooterView *footerView;
@property (strong, nonatomic) CreateSectionHeaderView *headerView;

@property (strong, nonatomic) NSMutableArray *createSectionArr;
@property (assign, nonatomic) NSInteger curEditingTVIdx;
@property (assign, nonatomic) NSInteger curAddingImageCellIdx;

@property (nonatomic, strong) CategoryInfo *category4record;

@property (nonatomic, assign) BOOL isRecordCreated;
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
    
    [self initCreateSection];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([self isBeingDismissed] || [self isMovingFromParentViewController]) {
        if (!self.isRecordCreated) {
            for (int i=0; i<self.createSectionArr.count; ++i) {
                [self deleteLocalImageForCellWithCellId:i];
            }
        }
    }
}

-(void)initCreateSection
{
    self.createSectionArr=[NSMutableArray new];
    if (nil == self.editingRecordInfo) {
        [self.createSectionArr addObject:[RecordCreateSectionInfo infoForTitle]];
        [self.createSectionArr addObject:[RecordCreateSectionInfo infoForText]];
        [self.createSectionArr addObject:[RecordCreateSectionInfo infoForImage]];
        
        //category
        if ([MyUtility isStringNilOrZeroLength:self.targetCategoryId] ||
            [self.targetCategoryId isEqualToString:kDefaultCategoryId]) {
            self.category4record=[CategoryInfo getDefaultCategoryInfo];
        } else {
            self.category4record=[DbHandler getCategoryInfoWithId:self.targetCategoryId];
        }
    } else {
        //title
        RecordCreateSectionInfo *titleSection=[RecordCreateSectionInfo infoForTitle];
        titleSection.txtContent=self.editingRecordInfo.recordTitle;
        [self.createSectionArr addObject:titleSection];
        
        //sections
        for (int sectionIdx=0; sectionIdx<self.editingRecordInfo.sectionArr.count; ++sectionIdx) {
            RecordSection *aSection=self.editingRecordInfo.sectionArr[sectionIdx];
            if ([SECTION_TYPE_TXT isEqualToString:aSection.sectionType]) {
                if (1 == aSection.sectionItemArr.count) {
                    RecordSectionItem *txtItem=aSection.sectionItemArr[0];
                    RecordCreateSectionInfo *txtSection=[RecordCreateSectionInfo infoForText];
                    txtSection.txtContent=txtItem.itemTxt;
                    
                    [self.createSectionArr addObject:txtSection];
                }
            } else if ([SECTION_TYPE_IMAGE isEqualToString:aSection.sectionType]) {
                if (aSection.sectionItemArr.count >= 1) {
                    RecordCreateSectionInfo *imgSection=[RecordCreateSectionInfo infoForImage];
                    for (RecordSectionItem *aImgItem in aSection.sectionItemArr) {
                        [imgSection.imgThumbArr addObject:aImgItem.imgThumbId];
                        [imgSection.imgOrgArr addObject:aImgItem.imgId];
                    }
                    
                    [self.createSectionArr addObject:imgSection];
                }
            }
        }
        
        //category
        if ([self.editingRecordInfo.categoryId isEqualToString:kDefaultCategoryId]) {
            self.category4record=[CategoryInfo getDefaultCategoryInfo];
        } else {
            self.category4record=[DbHandler getCategoryInfoWithId:self.editingRecordInfo.categoryId];
        }
    }
    
    [self.tbCreate reloadData];
}

-(void)navActionForCreate
{
    RecordCreateSectionInfo *titleSection=self.createSectionArr[0];
    if (SectionTypeTitle == titleSection.type) {
        if ([MyUtility isStringNilOrZeroLength:titleSection.txtContent]) {
            [MyUtility prensentAlertVCFromSourceVC:self withAnim:YES andContent:NSLocalizedString(@"record_title_cannot_empty", @"")];
            return;
        }
        
        self.isRecordCreated=true;
        
        RecordInfo *record2store=[RecordInfo new];
        if (nil == self.editingRecordInfo) {
            record2store.recordId=[MyUtility makeUniqueIdWithMaxLength:kDbIdDefaultSize];
        } else {
            record2store.recordId=self.editingRecordInfo.recordId;
        }
        
        record2store.recordTitle=titleSection.txtContent;
        
        if (nil == self.editingRecordInfo) {
            record2store.createTime=[[NSDate date] timeIntervalSince1970];
        } else {
            record2store.createTime=self.editingRecordInfo.createTime;
        }
        
        record2store.categoryId=self.category4record.categoryId;
        
        record2store.sectionArr=[NSMutableArray new];
        for (int sectionIdx=1; sectionIdx<self.createSectionArr.count; ++sectionIdx) {
            RecordCreateSectionInfo *sectionInfo=self.createSectionArr[sectionIdx];
            if (SectionTypeTxt == sectionInfo.type) {
                if ([MyUtility isStringNilOrZeroLength:sectionInfo.txtContent]) {
                    continue;
                }
                RecordSection *aSection=[RecordSection new];
                aSection.recordId=record2store.recordId;
                aSection.sectionId=sectionIdx;
                aSection.sectionType=SECTION_TYPE_TXT;
                
                aSection.sectionItemArr=[NSMutableArray new];
                RecordSectionItem *aItem=[RecordSectionItem new];
                aItem.recordId=record2store.recordId;
                aItem.sectionId=sectionIdx;
                aItem.itemId=0;
                aItem.itemTxt=sectionInfo.txtContent;
                aItem.imgId=@"";
                aItem.imgThumbId=@"";
                
                [aSection.sectionItemArr addObject:aItem];
                
                [record2store.sectionArr addObject:aSection];
            } else if (SectionTypeImg == sectionInfo.type) {
                if (sectionInfo.imgOrgArr.count <= 0 ||
                    sectionInfo.imgThumbArr.count <= 0) {
                    continue;
                }
                RecordSection *aSection=[RecordSection new];
                aSection.recordId=record2store.recordId;
                aSection.sectionId=sectionIdx;
                aSection.sectionType=SECTION_TYPE_IMAGE;
                
                aSection.sectionItemArr=[NSMutableArray new];
                for (int itemIdx=0; itemIdx<sectionInfo.imgOrgArr.count; ++itemIdx) {
                    RecordSectionItem *aItem=[RecordSectionItem new];
                    aItem.recordId=record2store.recordId;
                    aItem.sectionId=sectionIdx;
                    aItem.itemId=itemIdx;
                    aItem.itemTxt=@"";
                    aItem.imgId=sectionInfo.imgOrgArr[itemIdx];
                    aItem.imgThumbId=sectionInfo.imgThumbArr[itemIdx];
                    
                    [aSection.sectionItemArr addObject:aItem];
                }
                
                [record2store.sectionArr addObject:aSection];
            }
        }
        
        [DbHandler deleteRecordInfoWithId:self.editingRecordInfo andAutoDelMedia:NO];
        [DbHandler storeRecordWithInfo:record2store];
    }
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSInteger tvIdx=textView.tag;
    if (tvIdx >= self.createSectionArr.count) {
        self.curEditingTVIdx=-1;
        return;
    }
    
    self.curEditingTVIdx=tvIdx;
    
    [self performSelector:@selector(scrollEditingTextView2visible) withObject:nil afterDelay:0.3];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    BOOL retFlag=true;
    
    NSInteger tvIdx=textView.tag;
    if (tvIdx >= self.createSectionArr.count) {
        return retFlag;
    }
    
    NSInteger maxLimit=NSIntegerMax;
    RecordCreateSectionInfo *sectionInfo=self.createSectionArr[tvIdx];
    switch (sectionInfo.type) {
        case SectionTypeTitle:
            maxLimit=kDbIdRecordTitleSize;
            break;
        case SectionTypeTxt:
            maxLimit=kDbIdRecordItemTxtSize;
            break;
        case SectionTypeImg:
            break;
        default:
            break;
    }
    
    if (textView.text.length + text.length > maxLimit) {
        retFlag=false;
        [MyUtility prensentAlertVCFromSourceVC:self withAnim:YES andContent:[NSString stringWithFormat:NSLocalizedString(@"max text can be input %d", @""),(int)maxLimit]];
    }
    
    return retFlag;
}
- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger tvIdx=textView.tag;
    if (tvIdx >= self.createSectionArr.count) {
        return;
    }
    
    RecordCreateSectionInfo *sectionInfo=self.createSectionArr[tvIdx];
    NSString *txt2use=textView.text;
    switch (sectionInfo.type) {
        case SectionTypeTitle:
            if (txt2use.length > kDbIdRecordTitleSize) {
                txt2use=[txt2use substringToIndex:kDbIdRecordTitleSize];
            }
            break;
        case SectionTypeTxt:
            if (txt2use.length > kDbIdRecordItemTxtSize) {
                txt2use=[txt2use substringToIndex:kDbIdRecordItemTxtSize];
            }
            break;
        case SectionTypeImg:
            break;
        default:
            break;
    }
    
    sectionInfo.txtContent=txt2use;
    
    [self updateTxtInfoForCell:[self.tbCreate cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tvIdx inSection:0]] andSectionInfo:sectionInfo];
}

-(void)updateTxtInfoForCell:(UITableViewCell *)cell2update andSectionInfo:(RecordCreateSectionInfo *)sectionInfo
{
    if (nil == cell2update || nil == sectionInfo) {
        return;
    }
    switch (sectionInfo.type) {
        case SectionTypeTitle:
        {
            CreateSectionTitleTableViewCell *titleCell=(CreateSectionTitleTableViewCell *)cell2update;
            if ([titleCell isKindOfClass:CreateSectionTitleTableViewCell.class]) {
                titleCell.tvTitle.text=sectionInfo.txtContent;
                titleCell.lblLimit.text=[NSString stringWithFormat:@"%d/%d",(int)sectionInfo.txtContent.length,(int)kDbIdRecordTitleSize];
            }
            break;
        }
        case SectionTypeTxt:
        {
            CreateSectionTxtTableViewCell *txtCell=(CreateSectionTxtTableViewCell *)cell2update;
            if ([txtCell isKindOfClass:CreateSectionTxtTableViewCell.class]) {
                txtCell.tvTxtContent.text=sectionInfo.txtContent;
                txtCell.lblLimit.text=[NSString stringWithFormat:@"%d/%d",(int)sectionInfo.txtContent.length,(int)kDbIdRecordItemTxtSize];
            }
            break;
        }
        case SectionTypeImg:
            break;
        default:
            break;
    }
}

#pragma mark override
- (void)actionForKeyboardHeightDidChange
{
    [super actionForKeyboardHeightDidChange];
    
    for (NSLayoutConstraint *aConstraint in self.view.constraints) {
        if ([aConstraint.identifier isEqualToString:@"bottom_constraint_id"]) {
            aConstraint.constant=self.kbHeight;
        }
    }
    
    [self performSelector:@selector(scrollEditingTextView2visible) withObject:nil afterDelay:0.3];
}

-(void)scrollEditingTextView2visible
{
    if (self.kbHeight > 0) {
        if (self.curEditingTVIdx >= 0 && self.curEditingTVIdx < self.createSectionArr.count) {
            [self.tbCreate scrollRectToVisible:[self.tbCreate rectForRowAtIndexPath:[NSIndexPath indexPathForRow:self.curEditingTVIdx inSection:0]] animated:YES];
        }
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
            return [CellSizeInfo sizeForImageCVItem].height+35;
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
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
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (nil == self.headerView) {
        self.headerView=[[[NSBundle mainBundle] loadNibNamed:@"CreateSectionHeaderView" owner:self options:nil] lastObject];
        self.headerView.headerActionDelegate=self;
        self.headerView.lblDesc.text=[NSString stringWithFormat:@"%@:",NSLocalizedString(@"title_for_category", @"")];
    }
    
    [self.headerView.btnCategory setTitle:self.category4record.categoryTitle forState:UIControlStateNormal];
    return self.headerView;
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
        titleCell.tvTitle.delegate=self;
        titleCell.tvTitle.tag=indexPath.row;
        
        [self updateTxtInfoForCell:titleCell andSectionInfo:sectionInfo];
        cell2ret=titleCell;
    } else if (SectionTypeTxt == sectionInfo.type) {
        CreateSectionTxtTableViewCell *txtCell=[tableView dequeueReusableCellWithIdentifier:[CellIdInfo cellIdForCreateSectionTxt]
                                                                                   forIndexPath:indexPath];
        txtCell.lblTxtDesc.text=NSLocalizedString(@"create_record_txt_desc", @"");
        txtCell.tvTxtContent.delegate=self;
        txtCell.tvTxtContent.tag=indexPath.row;
        
        txtCell.cellIndex=indexPath.row;
        txtCell.actionDelegate=self;
        
        [self updateTxtInfoForCell:txtCell andSectionInfo:sectionInfo];
        cell2ret=txtCell;
    } else if (SectionTypeImg == sectionInfo.type) {
        CreateSectionImgTableViewCell *imgCell=[tableView dequeueReusableCellWithIdentifier:[CellIdInfo cellIdForCreateSectionImg]
                                                                                   forIndexPath:indexPath];
        imgCell.lblImgDesc.text=NSLocalizedString(@"create_record_img_desc", @"");
        imgCell.cellIndex=indexPath.row;
        imgCell.thumbImgArr=sectionInfo.imgThumbArr;
        imgCell.orgImgArr=sectionInfo.imgOrgArr;
        imgCell.actionDelegate=self;
        
        cell2ret=imgCell;
    }
    
    [cell2ret setNeedsLayout];
    return cell2ret;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark CreateSectionImageActionDelegate
-(void)imageActionForAddImageWithCellIndex:(NSInteger)cellIdx andSourceView:(UIView *)sourceView
{
    self.curAddingImageCellIdx=cellIdx;
    
    UIAlertController *alertVC=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *libraryAction=[UIAlertAction actionWithTitle:NSLocalizedString(@"add_image_from_library", @"")
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action){
                                                           [self launchImagePickerWithType:UIImagePickerControllerSourceTypePhotoLibrary];
                                                       }];
    UIAlertAction *cameraAction=[UIAlertAction actionWithTitle:NSLocalizedString(@"add_image_from_camera", @"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action){
                                                             [self launchImagePickerWithType:UIImagePickerControllerSourceTypeCamera];
                                                         }];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", @"")
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction *action){
                                                           
                                                       }];
    
    [alertVC addAction:libraryAction];
    [alertVC addAction:cameraAction];
    [alertVC addAction:cancelAction];
    
    alertVC.popoverPresentationController.sourceView=sourceView;
    alertVC.popoverPresentationController.sourceRect=sourceView.bounds;
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

-(void)launchImagePickerWithType:(UIImagePickerControllerSourceType)type
{
    if (UIImagePickerControllerSourceTypePhotoLibrary == type) {
        PhotoSelectionContainerNavVC *photoSelectionContainerVC = [[UIStoryboard storyboardWithName:@"PhotoSelection" bundle:nil] instantiateInitialViewController];
        photoSelectionContainerVC.photoSelectionDelegate=self;
        [self presentViewController:photoSelectionContainerVC animated:YES completion:nil];
        
//        UIImagePickerController * imagePickerVC = [[UIImagePickerController alloc] init];
//        imagePickerVC.sourceType = type;
//        imagePickerVC.mediaTypes = @[(NSString *)kUTTypeImage];
//
//        imagePickerVC.delegate = self;
//
//        [self presentViewController:imagePickerVC animated:YES completion:nil];
    } else if (UIImagePickerControllerSourceTypeCamera == type) {
        if ([UIImagePickerController isSourceTypeAvailable:type]) {
            UIImagePickerController * imagePickerVC = [[UIImagePickerController alloc] init];
            imagePickerVC.sourceType = type;

            imagePickerVC.mediaTypes = @[(NSString *)kUTTypeImage];
            imagePickerVC.delegate = self;
            imagePickerVC.allowsEditing = YES;
            imagePickerVC.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            imagePickerVC.cameraDevice = UIImagePickerControllerCameraDeviceRear;

            imagePickerVC.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
//            imagePickerVC.showsCameraControls = NO;

            [self presentViewController:imagePickerVC animated:YES completion:nil];
        }
    }
}

-(void)imageActionForDelSectionWithCellIndex:(NSInteger)cellIdx
{
    [self action4delSectionWithCellIndex:cellIdx];
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [self dismissViewControllerAnimated:YES completion:nil];

    if (self.curAddingImageCellIdx>=0 && self.curAddingImageCellIdx < self.createSectionArr.count) {
        RecordCreateSectionInfo *sectionInfo=self.createSectionArr[self.curAddingImageCellIdx];
        if (SectionTypeImg == sectionInfo.type) {
            UIImage *imgGot=info[UIImagePickerControllerOriginalImage];
            if (nil != imgGot) {
                imgGot=[MyUtility scaleImage:imgGot toSize:[MyUtility maxSizeOfImage2handle]];
                
                [sectionInfo.imgOrgArr addObject:[MyUtility writeImage:imgGot intoDirectory:IMG_STORE_PATH_IN_DOC]];
                [sectionInfo.imgThumbArr addObject:[MyUtility writeImageThumb:imgGot intoDirectory:IMG_STORE_PATH_IN_DOC]];
                
                [self.tbCreate reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.curAddingImageCellIdx inSection:0]]
                                     withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }
    
//    info中可能包含的key的含义
//    UIImagePickerControllerCropRect // 编辑裁剪区域
//    UIImagePickerControllerEditedImage // 编辑后的UIImage
//    UIImagePickerControllerMediaType // 返回媒体的媒体类型
//    UIImagePickerControllerOriginalImage // 原始的UIImage
//    UIImagePickerControllerReferenceURL // 图片地址
//    NSLog(@"%@", info);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark CreateSectionTextActionDelegate
-(void)textActionForDelSectionWithCellIndex:(NSInteger)cellIdx
{
    [self action4delSectionWithCellIndex:cellIdx];
}

-(void)action4delSectionWithCellIndex:(NSInteger)cellIdx
{
    UIAlertController *alertVC=[UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Are you sure to delete this section?", @"") preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction=[UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"")
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action){
                                                       [self deleteLocalImageForCellWithCellId:cellIdx];
                                                       
                                                       [self.createSectionArr removeObjectAtIndex:cellIdx];
                                                       
                                                       [self.tbCreate reloadData];
                                                   }];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", @"")
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction *action){
                                                           
                                                       }];
    
    [alertVC addAction:okAction];
    [alertVC addAction:cancelAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)deleteLocalImageForCellWithCellId:(NSInteger)cellIdx
{
    if (cellIdx >= self.createSectionArr.count || nil != self.editingRecordInfo) {
        return;
    }
    RecordCreateSectionInfo *sectionInfo=self.createSectionArr[cellIdx];
    if (SectionTypeImg == sectionInfo.type) {
        for (NSString *aOrgImgName in sectionInfo.imgOrgArr) {
            [MyUtility deleteFileWithName:aOrgImgName inDirectory:IMG_STORE_PATH_IN_DOC];
        }
        for (NSString *aThumbImgName in sectionInfo.imgThumbArr) {
            [MyUtility deleteFileWithName:aThumbImgName inDirectory:IMG_STORE_PATH_IN_DOC];
        }
    }
}

#pragma mark UINavigationControllerDelegate

#pragma mark PhotoSelectionActionDelegate
- (void)photoSelectionFinishWithImageArr:(NSArray *)imgArr
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (imgArr.count > 0) {
        RecordCreateSectionInfo *sectionInfo=self.createSectionArr[self.curAddingImageCellIdx];
        for (UIImage *aImage in imgArr) {
            [sectionInfo.imgOrgArr addObject:[MyUtility writeImage:aImage intoDirectory:IMG_STORE_PATH_IN_DOC]];
            [sectionInfo.imgThumbArr addObject:[MyUtility writeImageThumb:aImage intoDirectory:IMG_STORE_PATH_IN_DOC]];
            
            [self.tbCreate reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.curAddingImageCellIdx inSection:0]]
                                 withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}
- (void)photoSelectionCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark override
-(void)screenOrientationChangedHandle
{
    [self.tbCreate reloadData];
}

#pragma mark CreateSectionHeaderViewActionDelegate
-(void)headerButtonDidTappedWithButton:(UIButton *)btnTapped
{
    CagegorySelectViewController *categorySelectionVC = [[UIStoryboard storyboardWithName:@"CagegorySelect" bundle:nil] instantiateInitialViewController];
    categorySelectionVC.actionDelegate=self;
    [MyUtility pushViewControllerFromNav:self.navigationController withTargetVC:categorySelectionVC animated:YES];
}

#pragma mark CategorySelectActionDelegate
-(void)didSelectCategory:(CategoryInfo *)categoryInfo
{
    self.category4record=categoryInfo;
    [self.headerView.btnCategory setTitle:self.category4record.categoryTitle forState:UIControlStateNormal];
}

@end
