//
//  InformEditController.m
//  TTNews
//
//  Created by 王迪 on 2017/9/22.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "InformEditController.h"
#import "KGTableviewCellModel.h"
#import "ValuePickerView.h"
#import "UserDatePicker.h"
#import "EditController.h"
#import "YYLocation.h"
#import "UserModel.h"

@interface InformEditController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,YYLocationPickerViewDelegate>
@property(nonatomic,strong)NSMutableArray *arrayDataItems;

@property (nonatomic, assign) NSInteger sexIndex;
@property (nonatomic, strong) NSString * birthdayIndex;
@property (nonatomic, strong) NSString * locationStr;
@property (nonatomic, strong) UserModel *userModel;
@end

@implementation InformEditController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"编辑个人资料";
    self.tableView.tableFooterView = [UIView new];
    self.arrayDataItems=[NSMutableArray array];
    
    [self requestURL];
//    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(0xfa5054,0x444444,0xfa5054);
}

-(void)requestURL{
    NSMutableDictionary *prms=[@{
                                 @"uid":[[OWTool Instance] getUid]
                                 }mutableCopy];
    weakSelf(ws)
    [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:KNetworGetUserINfo withUserInfo:prms success:^(NSDictionary *message)
     {
         if ([message[@"status"] intValue]==1)
         {
             _userModel = [UserModel mj_objectWithKeyValues:message[@"data"]];
             [[OWTool Instance] setUserInfo:[_userModel mj_keyValues]];
             [ws loadData];
         }
         else
         {
             [SVProgressHUD showImage:nil status:message[@"message"]];
             [SVProgressHUD dismissWithDelay:2];
         }
     } failure:^(NSError *error) {
         
     } visibleHUD:NO];
}

-(void)loadData
{
    _sexIndex = [_userModel.sex integerValue];
    _birthdayIndex = _userModel.birthday;
    
    KGTableviewCellModel *model=[[KGTableviewCellModel alloc] init];
    model.title=@"头像";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"昵称";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"签名";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"性别";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"生日";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"所在地";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"完成";
    [self.arrayDataItems addObject:model];

    [self SetTableviewMethod];
}



-(void)SetTableviewMethod
{
    weakSelf(ws);
    [self.tableView cb_makeDataSource:^(CBTableViewDataSourceMaker *make) {
        [make makeSection:^(CBTableViewSectionMaker *section)
         {
             section.data(self.arrayDataItems)
             .cell([UITableViewCell class])
             .adapter(^(UITableViewCell *cell,KGTableviewCellModel *model,NSUInteger index)
                      {
                          cell=[cell initWithStyle:UITableViewStylePlain reuseIdentifier:@"identify"];
                          cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                          if (index != 6) {
                              cell.textLabel.text=model.title;
                          }
                          
                          cell.textLabel.font=[UIFont systemFontOfSize:16];
                          cell.detailTextLabel.text=model.detail;
                          cell.detailTextLabel.font=[UIFont systemFontOfSize:13];
                          cell.detailTextLabel.textColor=[UIColor colorWithHexString:@"#848484"];
                          
                          //清理缓存
                          if (index!=0 && index <6)
                          {
                              UILabel *lab=[[UILabel alloc] init];
                              [cell.contentView addSubview:lab];
                              
                              if (index == 1) {
                                  lab.text=_userModel.nicheng;
                              }
                              else if (index == 2) {
                                  lab.text=_userModel.signature;
                              }
                              else if (index == 3) {
                                  NSArray * sexList = @[@"男",@"女",@"保密"];
                                  NSString *sexStr = [sexList objectAtIndex:[_userModel.sex intValue]];
                                  lab.text=sexStr;
                              }
                              else if (index == 4) {
                                  lab.text=_userModel.birthday;
                              }
                              else if (index == 5) {
                                  lab.text=[NSString stringWithFormat:@"%@ %@ %@",_userModel.pos_province,_userModel.pos_city,_userModel.pos_district];
                              }
                              lab.font=[UIFont systemFontOfSize:14];
                              lab.textAlignment=2;
                              lab.tag=1000;
                              lab.textColor=wh_RGB(145, 145, 145);
                              [lab mas_makeConstraints:^(MASConstraintMaker *make)
                               {
                                   make.top.bottom.mas_equalTo(5);
                                   make.right.mas_equalTo(-10);
                                   make.width.mas_equalTo(200);
                                   make.bottom.offset(-5);
                               }];
                          }
                          else if(index == 0)
                          {
                              UIImageView *img=[[UIImageView alloc] init];
                              [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://xinwen.52jszhai.com",_userModel.avatar]]];
                              [cell.contentView addSubview:img];
                              img.layer.masksToBounds=YES;
                              img.layer.cornerRadius=25;
                              img.tag=1000;
                              [img mas_makeConstraints:^(MASConstraintMaker *make) {
                                  make.top.bottom.mas_equalTo(5);
                                  make.right.mas_equalTo(-10);
                                  make.width.mas_equalTo(50);
                                  make.bottom.offset(-5);
                              }];
                          }
                          else if (index == 6){
                              UIButton * btn =[UIButton buttonWithType:UIButtonTypeSystem];
                              [cell.contentView addSubview:btn];
                              cell.selectionStyle = UITableViewCellAccessoryNone;
                              cell.accessoryType = UITableViewCellAccessoryNone;
                              [btn setTitle:model.title forState:UIControlStateNormal];
                              [btn.titleLabel setFont:[UIFont systemFontOfSize:17]];
                              [btn setTitleColor:navColor forState:UIControlStateNormal];
                              [btn addTarget:self action:@selector(btnNextStep) forControlEvents:UIControlEventTouchUpInside];
                              btn.sd_layout
                              .leftEqualToView(cell.contentView)
                              .rightEqualToView(cell.contentView)
                              .topEqualToView(cell.contentView)
                              .bottomEqualToView(cell.contentView);
                          }
                          
                      })
             .event(^(NSUInteger index, KGTableviewCellModel *model)
                    {
                        UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
                        UILabel *lab=(UILabel *)[cell viewWithTag:1000];
                        if(index==0)
                        {
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
                        else if (index==1)
                        {
                            EditController *edit=[[EditController alloc] init];
                            edit.SendTextBlock = ^(NSString *str) {
                                lab.text=str;
                            };
                            edit.titleStr=@"昵称";
                            [ws.navigationController pushViewController:edit animated:YES];
                        }
                        else if (index==2)
                        {
                            EditController *edit=[[EditController alloc] init];
                            edit.SendTextBlock = ^(NSString *str) {
                                lab.text=str;
                            };
                            edit.titleStr=@"签名";
                            [ws.navigationController pushViewController:edit animated:YES];
                        }
                        else if (index==3)
                        {
                            ValuePickerView *picker=[[ValuePickerView alloc] init];
                            picker.dataSource=@[@"男",@"女",@"保密"];
                            picker.pickerTitle=@"性别选择";
                            picker.valueDidSelect=^(NSString *value)
                            {
                                lab.text=value;
                                _sexIndex =  [picker.dataSource indexOfObject:value];
                            };
                            [picker show];
                        }
                        else if (index==4)
                        {
                            UserDatePicker *datePick=[UserDatePicker UserDatePicker];
                            [datePick setTitle:@"时间选择"];
                            datePick.UserDateBlock=^(UserDatePicker *picker, NSString *date, NSString *udate)
                            {
                                lab.text=date;
                                _birthdayIndex =date;
                            };
                        }
                        else if (index==5)
                        {
                            YYLocationPickerView *location = [[YYLocationPickerView alloc] initWithLevel:YYLocationPickerViewLevelCity andDelegate:self];
                            location.tag = 2;
                            [location show];
                        }
                    })
             .height(60);
         }];
    }];
}

-(void)btnNextStep{
    weakSelf(ws)
    NSMutableDictionary *prms=[@{
                                 @"uid":[[OWTool Instance] getUid] ,
                                 @"sex":@(_sexIndex),
                                 @"birthday":_birthdayIndex
                                 }mutableCopy];
    
    [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:NNetworkUpdateUserInfo withUserInfo:prms success:^(NSDictionary *message)
     {
         [SVProgressHUD showSuccessWithStatus:message[@"message"]];
         
         [SVProgressHUD dismissWithDelay:2];
         [ws popViewController];
     } failure:^(NSError *error) {
         
     } visibleHUD:NO];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UIImageView *img=[cell viewWithTag:1000];
    img.image=info[UIImagePickerControllerEditedImage];
    weakSelf(ws)
    [KGNetworkManager uploadImageWithArray:@[img.image] parameter:nil success:^(NSData* data) {
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        if(err == nil) {
            NSMutableDictionary *prms=[@{
                                         @"uid":[[OWTool Instance] getUid] ,
                                         @"avatar":dic[@"Info"][@"id"]
                                         }mutableCopy];
            
            [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:KNetworkmyDynamic withUserInfo:prms success:^(NSDictionary *message)
             {
                 [SVProgressHUD showSuccessWithStatus:message[@"message"]];
                
                 [SVProgressHUD dismissWithDelay:2];
                  [ws dismissViewController];
             } failure:^(NSError *error) {
                 
             } visibleHUD:NO];
            //[ws.personalHeaderView.headerImg setImage:img];
        }
        
    } fail:^(NSError *error) {
        
    }];
    
}

#pragma mark - YYLocationPickViewDelegate
- (void)locationPickerView:(YYLocationPickerView *)locationPickerView didSelectedLocation:(NSString *)location locationID:(NSString *)locationID
{
    UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    UILabel *lab=(UILabel *)[cell viewWithTag:1000];
    lab.text = location;
    _locationStr = location;
}
@end
