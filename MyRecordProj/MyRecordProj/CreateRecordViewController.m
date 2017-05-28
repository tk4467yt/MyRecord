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
#import "MyCommonHeaders.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "PhotoSelectionContainerNavVC.h"

@interface CreateRecordViewController () <UITableViewDelegate,UITableViewDataSource,CreateSectionFooterViewActionDelegate,UITextViewDelegate,CreateSectionImageActionDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,PhotoSelectionActionDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbCreate;

@property (strong, nonatomic) CreateSectionFooterView *footerView;

@property (strong, nonatomic) NSMutableArray *createSectionArr;
@property (assign, nonatomic) NSInteger curEditingTVIdx;
@property (assign, nonatomic) NSInteger curAddingImageCellIdx;
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
        UIAlertController *alertVC=[UIAlertController alertControllerWithTitle:nil
                                                                       message:[NSString stringWithFormat:NSLocalizedString(@"max text can be input %d", @""),(int)maxLimit]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", @"")
                                                             style:UIAlertActionStyleCancel
                                                           handler:^(UIAlertAction *action){
                                                               
                                                           }];
        [alertVC addAction:cancelAction];
        [self presentViewController:alertVC animated:YES completion:nil];
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
            CreateSectionTxtTableViewCell *titleCell=(CreateSectionTxtTableViewCell *)cell2update;
            if ([titleCell isKindOfClass:CreateSectionTxtTableViewCell.class]) {
                titleCell.tvTxtContent.text=sectionInfo.txtContent;
                titleCell.lblLimit.text=[NSString stringWithFormat:@"%d/%d",(int)sectionInfo.txtContent.length,(int)kDbIdRecordItemTxtSize];
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
        
        [self updateTxtInfoForCell:txtCell andSectionInfo:sectionInfo];
        cell2ret=txtCell;
    } else if (SectionTypeImg == sectionInfo.type) {
        CreateSectionImgTableViewCell *imgCell=[tableView dequeueReusableCellWithIdentifier:[CellIdInfo cellIdForCreateSectionImg]
                                                                                   forIndexPath:indexPath];
        imgCell.lblImgDesc.text=NSLocalizedString(@"create_record_img_desc", @"");
        imgCell.cellIndex=indexPath.row;
        imgCell.imgArr=sectionInfo.imgThumbArr;
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

#pragma mark UINavigationControllerDelegate

#pragma mark PhotoSelectionActionDelegate
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

@end
