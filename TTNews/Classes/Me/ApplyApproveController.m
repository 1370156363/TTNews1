//
//  ApplyApproveController.m
//  TTNews
//
//  Created by 薛立强 on 2017/11/5.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "ApplyApproveController.h"
#import "KGTableviewCellModel.h"
#import "ValuePickerView.h"

@interface ApplyApproveController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UITableView       * tableview;
@property (nonatomic, strong) UILabel           * labTitle;
@property (nonatomic, strong) NSMutableArray    * arrayDataItems;
@property (nonatomic, assign) BOOL              isImageSelect;
@property (nonatomic, assign) BOOL              canEditing;

@property (nonatomic, assign) int               aproveImgId;

@property (nonatomic, strong) NSString          *titleStr;//媒体名称
@property (nonatomic, assign) NSInteger         category_id;//媒体类型
@property (nonatomic, assign) NSInteger          category_fuid;//专注领域
@property (nonatomic, strong) NSString          *descriptionStr;//媒体描述

@end

@implementation ApplyApproveController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:RGB(220, 220, 220)];
    self.title=@"媒体信息";
    [self.view sd_addSubviews:@[self.labTitle,self.tableview]];
    self.arrayDataItems=[NSMutableArray array];
    [self loadData];
    [self SetTableviewMethod];
    // Do any additional setup after loading the view from its nib.
}

-(void)loadData
{
    KGTableviewCellModel *model=[[KGTableviewCellModel alloc] init];
    model.title=@"媒体类型";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"媒体名称";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"专注领域";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"媒体简介";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"媒体图像";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"下一步";
    [self.arrayDataItems addObject:model];
    
    [self SetTableviewMethod];
}

-(void)SetTableviewMethod
{
    weakSelf(ws)
    [self.tableview cb_makeDataSource:^(CBTableViewDataSourceMaker *make) {
        [make makeSection:^(CBTableViewSectionMaker * section)
         {
             section.cell([UITableViewCell class])
             .data(self.arrayDataItems)
             .adapter(^(UITableViewCell * cell,KGTableviewCellModel * data,NSUInteger index)
                      {
                          cell.selectionStyle = UITableViewCellAccessoryNone;
                          if( index == 5){
                              UIButton * btn =[UIButton buttonWithType:UIButtonTypeSystem];
                              [cell.contentView addSubview:btn];
                              [btn setTitle:data.title forState:UIControlStateNormal];
                              [btn.titleLabel setFont:[UIFont systemFontOfSize:17]];
                              [btn setTitleColor:navColor forState:UIControlStateNormal];
                              [btn addTarget:self action:@selector(btnNextStep) forControlEvents:UIControlEventTouchUpInside];
                              btn.sd_layout
                              .leftEqualToView(cell.contentView)
                              .rightEqualToView(cell.contentView)
                              .topEqualToView(cell.contentView)
                              .bottomEqualToView(cell.contentView);
//                              [cell setupAutoHeightWithBottomView:btn bottomMargin:20];
                          }
                          else{
                              cell.textLabel.text=data.title;
                              cell.textLabel.font=[UIFont systemFontOfSize:17];
                          }
                          
                          if (index==4)
                          {
                              UIImageView *img=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"addApproveImg"]];
                              img.backgroundColor = RGB(180, 180, 180);
                              img.userInteractionEnabled = YES;
                              [img wh_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
                                  [ws imgTapGesture];
                              }];
                              [cell.contentView addSubview:img];
                              img.tag=1000;
                              img.sd_layout
                              .leftSpaceToView(cell.contentView, 120)
                              .centerYEqualToView(cell.contentView)
                              .heightIs(60)
                              .widthIs(60);
                              UILabel *lab = [[UILabel alloc]init];
                            [cell.contentView addSubview:lab];
                              lab.text = @"清晰、健康、代表每题形象的正方形照片，请勿使用二维码。";
                              lab.numberOfLines = 0;
                              lab.textColor = [UIColor lightGrayColor];
                              
                              lab.sd_layout
                              .rightSpaceToView(cell.contentView, 20)
                              .topSpaceToView(cell.contentView, 2)
                              .leftSpaceToView(cell.contentView, 200)
                              .autoHeightRatio(0);
//                              [cell setupAutoHeightWithBottomView:img bottomMargin:20];
                              
                          }
                          else if(index != 5){
                              UITextField *field=[[UITextField alloc] init];
                              [cell.contentView addSubview:field];
                              field.borderStyle = UITextBorderStyleNone;
                              field.delegate = self;
                              field.tag=1000;
                              field.sd_layout
                              .leftSpaceToView(cell.contentView, 120)
                              .heightIs(45)
                              .centerYEqualToView(cell.contentView)
                              .rightEqualToView(cell.contentView);
                              if (index == 0) {
                                  field.placeholder = @"点击选择每题类型";
                                  [field setEnabled:NO];
                                  [cell wh_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
                                      ValuePickerView *picker=[[ValuePickerView alloc] init];
                                      picker.dataSource=@[@"个人媒体",@"机构媒体",@"政府服务",@"企业",@"其他组织"];
                                      picker.pickerTitle=@"媒体类型";
                                      picker.valueDidSelect=^(NSString *value)
                                      {
                                          field.text=value;
                                          _category_id = [picker.dataSource indexOfObject:value];
                                      };
                                      [picker show];
                                  }];
                              }
                              else if (index == 1){
                                  field.placeholder = @"1-8字，审核后无法更改";
                              }
                              else if (index == 2){
                                  field.placeholder = @"点击选择专注领域";
                                  [field setEnabled:NO];
                                  [cell wh_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
                                      ValuePickerView *picker=[[ValuePickerView alloc] init];
                                      picker.dataSource=@[@"推荐",@"问答",@"要闻",@"直播",@"趣图",@"新闻",@"电影",@"科技"];
                                      picker.pickerTitle=@"专注领域";
                                      picker.valueDidSelect=^(NSString *value)
                                      {
                                          field.text=value;
                                          _category_fuid =[picker.dataSource indexOfObject:value];
                                      };
                                      [picker show];
                                  }];
                              }
                              else if (index == 3){
                                  field.sd_layout.heightIs(80);
                                  field.placeholder = @"10-100字，请简述媒体定位及内容价值，请勿填写任何联系方式";
                              }
//                              [cell setupAutoHeightWithBottomView:field bottomMargin:20];
                              
                          }
                      })
             .event(^(NSUInteger index, KGTableviewCellModel *model)
                    {
                        UITableViewCell *cell=[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
                        UITextField *textFiled=(UITextField *)[cell viewWithTag:1000];
                        if (index == 0)
                        {
                            
                        }
                        else if(index == 2){
                            
                        }
                        
                    })
             .height(80);
         }];
    }];
}
-(void)btnNextStep{
    weakSelf(ws)
    if([self checkPhoneInfo]){
        NSMutableDictionary *prms=[@{
                                     @"uid":[[OWTool Instance] getUid] ,
                                     @"avatar":@(_aproveImgId),
                                     @"category_fuid":@(_category_fuid),
                                     @"category_id":@(_category_id),
                                     @"description":_descriptionStr
                                         }mutableCopy];
        
        [[KGNetworkManager sharedInstance] invokeNetWorkAPIWith:KnetworkApplyApprove withUserInfo:prms success:^(NSDictionary *message)
         {
             [SVProgressHUD showSuccessWithStatus:message[@"message"]];
             
             [SVProgressHUD dismissWithDelay:2];
             [ws popViewController];
         } failure:^(NSError *error) {
             
         } visibleHUD:NO];
    }
}
-(BOOL)checkPhoneInfo
{
    for (int index = 0; index<5; index++) {
        UITableViewCell *cell=[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        
        if(index != 4){
            UITextField *textFiled=(UITextField *)[cell viewWithTag:1000];
            if (textFiled.text.length == 0 ) {
                if (index == 0) {
                    [SVProgressHUD showImage:nil status:@"请选择媒体类型！"];
                    [SVProgressHUD dismissWithDelay:2];
                    return false;
                }
                else if (index == 1) {
                    [SVProgressHUD showImage:nil status:@"请填写媒体名称！"];
                    [SVProgressHUD dismissWithDelay:2];
                    return false;
                }
                else if (index == 2) {
                    [SVProgressHUD showImage:nil status:@"请选择专注领域！"];
                    [SVProgressHUD dismissWithDelay:2];
                    return false;
                }
                else if (index == 3) {
                    [SVProgressHUD showImage:nil status:@"请填写媒体简介！"];
                    [SVProgressHUD dismissWithDelay:2];
                    return false;
                }
            }
            else{
                if (index == 1) {
                    _titleStr = textFiled.text;
                }
                else if (index == 3) {
                    _descriptionStr = textFiled.text;
                }
            }
        }
        else if (index == 4) {
            if (!_isImageSelect) {
                [SVProgressHUD showImage:nil status:@"请上传图片！"];
                [SVProgressHUD dismissWithDelay:2];
                return false;
            }
            
        }
        
    }
    
    return true;
}


-(void) imgTapGesture{
    weakSelf(ws)
    CKAlertViewController *alert=[CKAlertViewController alertControllerWithTitle:@"更换照片" message:@""];
    CKAlertAction *camera=[CKAlertAction actionWithTitle:@"相机" handler:^(CKAlertAction *action)
                           {
                               UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                               imagePicker.delegate = ws;
                               imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                               imagePicker.allowsEditing = YES;
                               imagePicker.showsCameraControls = YES;
                               [ws dismissViewController];
                               [ws presentViewController:imagePicker animated:YES completion:^{}];
                           }];
    CKAlertAction *phont=[CKAlertAction actionWithTitle:@"相册" handler:^(CKAlertAction *action)
                          {
                              UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                              imagePicker.navigationBar.barTintColor=[UIColor redColor];
                              imagePicker.navigationBar.tintColor=[UIColor whiteColor];
                              imagePicker.delegate = ws;
                              imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                              imagePicker.allowsEditing = YES;
                              [imagePicker.navigationBar setTitleTextAttributes:
                               @{NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 NSForegroundColorAttributeName:[UIColor whiteColor]}];
                              imagePicker.title=@"相机胶卷";
                              [ws dismissViewController];
                              [ws presentViewController:imagePicker animated:YES completion:^{}];
                          }];
    CKAlertAction *canCel=[CKAlertAction actionWithTitle:@"取消" handler:nil];
    [alert addAction:camera];
    [alert addAction:phont];
    [alert addAction:canCel];
    [ws presentViewController:alert animated:NO completion:nil];
}
-(void)hiddenKeyBoard
{
    DismissKeyboard;
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UITableViewCell *cell=[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    UIImageView *img=[cell viewWithTag:1000];
    img.image=info[UIImagePickerControllerEditedImage];
    _isImageSelect = true;
    weakSelf(ws)
    [KGNetworkManager uploadImageWithArray:@[img.image] parameter:nil success:^(NSData* data) {
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        if(err == nil) {
            [ws dismissViewController];
            _aproveImgId = dic[@"Info"][@"id"];
        }
        
    } fail:^(NSError *error) {
        
    }];
}

-(UITableView *)tableview{
    if (!_tableview) {
        _tableview=[[UITableView alloc] initWithFrame:CGRectMake(0, 110, winsize.width, winsize.height-110) style:UITableViewStylePlain];
        _tableview.showsVerticalScrollIndicator = NO;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.layoutMargins = UIEdgeInsetsZero;
        _tableview.separatorColor = [UIColor lightGrayColor];
        _tableview.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [_tableview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBoard)]];
    }
    return _tableview;
}

-(UILabel *) labTitle{
    if (!_labTitle) {
        _labTitle = [[UILabel alloc]init];
        _labTitle.numberOfLines = 0;
        _labTitle.text = @"提交完整的账号资料，将有助于增加您的内容点击量，并获得更多的增益权益。";
        [_labTitle setFont:[UIFont systemFontOfSize:16]];
        [_labTitle setTextColor:navColor];
        [_labTitle setFrame:CGRectMake(10, 70, SCREEN_WIDTH-20, 40)];
    }
    return _labTitle;
}

@end
