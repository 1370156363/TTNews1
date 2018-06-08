//
//  MyController.m
//  TTNews
//
//  Created by 西安云美 on 2017/7/26.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "MyController.h"
#import <SDImageCache.h>
#import <SVProgressHUD.h>
#import "TTConst.h"
#import "SendFeedbackViewController.h"
#import "AppInfoViewController.h"
#import "EditUserInfoViewController.h"
#import <DKNightVersion.h>
#import "KGTableviewCellModel.h"
#import "KGMPersonalHeaderView.h"
#import "LibraryController.h"
#import "FocusCell.h"
#import "SettingController.h"
#import "collectController.h"
#import "fensiController.h"
#import "KGDynamicsController.h"
#import "LoginController.h"
#import "MyFensiController.h"
#import "PublishManageViewController.h"
#import "AddMessageViewController.h"
#import "EditController.h"
#import "ShoppingController.h"
#import "MLBasePageViewController.h"
#import "MyFavQuestionCol.h"
#import "MyQuestionAnswerCol.h"

#import "ContactListViewController.h"
#import "ChatListViewController.h"

@interface MyController ()<TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>
{
    UIBarButtonItem *_addFriendItem;
    NSDate *date;
}
@property (nonatomic, weak) UISwitch                *shakeCanChangeSkinSwitch;
@property (nonatomic, assign) CGFloat               cacheSize;
@property (nonatomic, strong) NSMutableArray         *arrayDataItems;
@property (nonatomic, strong) KGMPersonalHeaderView   *personalHeaderView;
@property (nonatomic, strong) UITableView             *tableView;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

@property (strong, nonatomic)ChatListViewController     * chatListCol;
@property (strong, nonatomic)ContactListViewController  * contactListCol;

@property (nonatomic, strong) MLBasePageViewController *vc;

@property (nonatomic, strong) MLBasePageViewController *vcChat;

@property (nonatomic, strong) MyFavQuestionCol *favQuestionCol;

@property (nonatomic, strong) MyQuestionAnswerCol *questionAnswerCol;


@property (nonatomic, assign)  NSInteger maxCountTF;  ///< 照片最大可选张数

@end

@implementation MyController


-(void)BtnAction:(NSInteger)tag
{
    if (tag==50)
    {
         LoginController* col = [[LoginController alloc] init];
        [self.navigationController pushViewController:col animated:YES];
    }
    else if (tag==60){
       //图像
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
        [sheet showInView:self.view];
    }
    else if (tag==70){
        //签名
        weakSelf(ws)
        EditController *edit=[[EditController alloc] init];
        edit.SendTextBlock = ^(NSString *str) {
            ws.personalHeaderView.contenttext.text=str;
        };
        edit.titleStr=@"签名";
        [ws.navigationController pushViewController:edit animated:YES];
    }
    else if (tag==80){
        //昵称
        weakSelf(ws)
        EditController *edit=[[EditController alloc] init];
        edit.SendTextBlock = ^(NSString *str) {
            ws.personalHeaderView.contenttext.text=str;
        };
        edit.titleStr=@"昵称";
        [ws.navigationController pushViewController:edit animated:YES];
    }
    else{
        if([[OWTool Instance] getUid] == nil || [[[OWTool Instance] getUid] isEqualToString:@""]){
            LoginController* loginCol = [[LoginController alloc] init];
            [self.navigationController pushViewController:loginCol animated:NO];
        }
        else if (tag==10)
        {
            [self.navigationController pushViewController:[KGDynamicsController new] animated:YES];
        }
        else if (tag==20)
        {
            [self.navigationController pushViewController:[MyFensiController new] animated:YES];
        }
        else if (tag==30)
        {
            [self.navigationController pushViewController:[fensiController new] animated:YES];
        }
        else if (tag==40)
        {
            [self.navigationController pushViewController:[fensiController new] animated:YES];
        }
    }
    
}
-(KGMPersonalHeaderView *)personalHeaderView
{
    weakSelf(ws);
    if (!_personalHeaderView)
    {
        _personalHeaderView=[[KGMPersonalHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 220)];
        _personalHeaderView.KGPersonalCheckBlock=^(NSInteger tag)
        {
            [ws BtnAction:tag];
        };
    }
    return _personalHeaderView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self caculateCacheSize];
    [self setupBasic];
   
    
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.personalHeaderView updateSubView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [SVProgressHUD dismiss];
}

-(void)setupBasic{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    //下面以 '2017-04-24 08:57:29'为例代表服务器返回的时间字符串
    date = [dateFormatter dateFromString:@"2018-05-20 08:57:29"];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, SCREEN_HEIGHT-24) style:UITableViewStylePlain];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorColor = RGB(240, 240, 240);
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
    self.tableView.tableHeaderView=self.personalHeaderView;
    self.tableView.separatorColor = [UIColor colorWithHexString:@"#dfdfdf"];
    self.arrayDataItems=[NSMutableArray array];
    
    _maxCountTF = 1;
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xAAAAAA, 0x000000);
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(MainColor,0x444444);
    //获取用户信息并刷新
    [self.personalHeaderView updateSubView];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    //黑色
    //return UIStatusBarStyleDefault;
    //白色
    return UIStatusBarStyleLightContent;
}

///刷新
-(void)loadData
{
    KGTableviewCellModel *model=[[KGTableviewCellModel alloc] init];
    model.title=@"消息通知";
    model.imageName=@"xiaoxiTZ";
    [self.arrayDataItems addObject:model];

    model=[[KGTableviewCellModel alloc] init];
    model.title=@"收藏/历史";
    model.imageName=@"shoucangjia";
    [self.arrayDataItems addObject:model];
    
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"发布动态";
    model.imageName=@"tougao";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"社交群组";
    model.imageName=@"qunzu";
    [self.arrayDataItems addObject:model];
    
    
    
    if([self compareOneDay:[self getCurrentTime]  withAnotherDay:date]){
        model=[[KGTableviewCellModel alloc] init];
        model.title=@"我的商城";
        model.imageName=@"shangcheng";
        [self.arrayDataItems addObject:model];
    }
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"电子图书馆";
    model.imageName=@"yuedu";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"日间/夜间";
    model.imageName=@"yejian";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"用户反馈";
    model.imageName=@"fankui";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"发布管理";
    model.imageName=@"shangchuan";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"系统设置";
    model.imageName=@"shezhi";
    [self.arrayDataItems addObject:model];
    
    [self SetTableviewMethod];
}

- (NSDate *)getCurrentTime{
    
    //2017-04-24 08:57:29
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
    NSDate *date = [formatter dateFromString:dateTime];
    //    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    //    NSString *dateString = [formatter stringFromDate:date];
    //    NSLog(@"datastring  = %@",dateString);
    return date;
}

- (BOOL)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"oneDay : %@, anotherDay : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //在指定时间前面 过了指定时间 过期
        NSLog(@"oneDay  is in the future");
        return true;
    }
    else if (result == NSOrderedAscending){
        //没过指定时间 没过期
        //NSLog(@"Date1 is in the past");
        return false;
    }
    //刚好时间一样.
    //NSLog(@"Both dates are the same");
    return false;
    
}


-(void)caculateCacheSize {
    float imageCache = [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
    self.cacheSize = imageCache;
}

-(void)switchDidChange:(UISwitch *)theSwitch {
    
    if (theSwitch.on == YES) {//切换至夜间模式
        self.dk_manager.themeVersion = DKThemeVersionNight;
        self.tabBarController.tabBar.barTintColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0];
        
    } else {
        self.dk_manager.themeVersion = DKThemeVersionNormal;
        self.tabBarController.tabBar.barTintColor = [UIColor whiteColor];
        
    }
}

-(void)didReceiveMemoryWarning {
    [[SDImageCache sharedImageCache] clearMemory];
}

-(void)SetTableviewMethod
{
    weakSelf(ws);
    [self.tableView cb_makeDataSource:^(CBTableViewDataSourceMaker *make) {
        [make makeSection:^(CBTableViewSectionMaker * section)
         {
             section.cell([FocusCell class])
             .data(@[@""])
             .adapter(^(FocusCell * cell,NSArray * data,NSUInteger index)
             {
                 
             })
             .event(^(NSUInteger index, KGTableviewCellModel *model)
            {
                if([[OWTool Instance] getUid] == nil || [[[OWTool Instance] getUid] isEqualToString:@""]){
                    LoginController* loginCol = [[LoginController alloc] init];
                    [self.navigationController pushViewController:loginCol animated:NO];
                }
                else{
                    [ws.navigationController pushViewController:[fensiController new] animated:YES];
                }
            })
             .height(45);
         }];
        
        [make makeSection:^(CBTableViewSectionMaker *section)
         {
             section.data(self.arrayDataItems)
             .cell([UITableViewCell class])
             .adapter(^(UITableViewCell *cell,KGTableviewCellModel *model,NSUInteger index)
                      {
                          cell.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x343434, 0xfafafa);
                          
                          cell.contentView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x343434, 0xfafafa);
                          cell.textLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
                          
                          cell=[cell initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"identify"];
                      cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                          cell.textLabel.text=model.title;
                          cell.imageView.image=[UIImage imageNamed:model.imageName];
                          if(![self compareOneDay:[self getCurrentTime] withAnotherDay:date] && index > 3 )
                          {
                              index = index + 1;
                          }
                          if (index==6)
                          {
                              UISwitch *sw=[[UISwitch alloc] init];
                              [cell.contentView addSubview:sw];
                              cell.selectionStyle = UITableViewCellSelectionStyleNone;
                              [sw mas_makeConstraints:^(MASConstraintMaker *make) {
                                  make.top.offset(5);
                                  make.bottom.offset(-5);
                                  make.right.offset(-20);
                                  make.width.mas_equalTo(30);
                              }];
                              if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNormal]) {
                                  [sw setOn:NO animated:YES];
                              } else {
                                  [sw setOn:YES animated:YES];
                                  
                              }
                              [sw addTarget:self action:@selector(switchDidChange:) forControlEvents:UIControlEventValueChanged];
                          }
                          
                      })
             .event(^(NSUInteger index, KGTableviewCellModel *model)
                    {
                        
                         if(![self compareOneDay:[self getCurrentTime] withAnotherDay:date] && index > 3)
                         {
                             index = index + 1;
                         }
                        //检验用户登录状态
                        if(!(index == 5 || index == 6)){
                            if([[OWTool Instance] getUid] == nil || [[[OWTool Instance] getUid] isEqualToString:@""]){
                                LoginController* loginCol = [[LoginController alloc] init];
                                [self.navigationController pushViewController:loginCol animated:NO];
                            }
                            else if(index==0){
                                [self.navigationController pushViewController:self.vc animated:YES];
                            }
                            else  if (index==1){
                                collectController *collect=[[collectController alloc] init];
                                [self.navigationController pushViewController:collect animated:YES];
                            }
                            else if(index == 4){
                                [self.navigationController pushViewController:[ShoppingController new] animated:YES];
                            }
                            else if (index == 2){
                                AddMessageViewController *col = [[AddMessageViewController alloc]init];
                                [self.navigationController pushViewController:col animated:YES];
                            }
                            else if (index == 3){
                                //聊天群组
                                if ([[OWTool Instance] getLastLoginUsername].length!=0) {
                                    [self.navigationController pushViewController:self.vcChat animated:YES];
                                    
                                }
                                else{
                                    LoginController *logCol = [[LoginController alloc] init];
                                    [self.navigationController pushViewController:logCol animated:YES];
                                }
                            }
                            else if(index == 8){
                                PublishManageViewController
                                * col=[[PublishManageViewController alloc] init];
                                [self.navigationController pushViewController:col animated:YES];
                            }
                            else if (index==7){
                                [self.navigationController pushViewController:[[SendFeedbackViewController alloc] init] animated:YES];
                            }
                            else if (index==9){
                                SettingController *settingCol = [[SettingController alloc]init];
                                [self.navigationController pushViewController:settingCol  animated:YES];
                                weakSelf(ws)
                                settingCol.loginOutBlock = ^{
                                    [ws.personalHeaderView updateSubView];
                                };
                            }
                        }
                        
                        else  if (index==5){
                            LibraryController *libraryVc=[[LibraryController alloc] init];
                            [self.navigationController pushViewController:libraryVc animated:YES];
                        }
                        
                    })
             .height(45);
         }];
    }];
}

#pragma mark -上传图片

-(void)upLoadUserHeadIm:(UIImage*)img{
    weakSelf(ws)
    [[KGNetworkManager sharedInstance] uploadImageWithArray:[@[img] copy] parameter:nil success:^(NSDictionary* dict) {
        NSDictionary *dic = dict[@"info"][0];
       
        NSMutableDictionary* dictData = [@{@"uid":[[OWTool Instance] getUid],@"avatar":dic[@"id"]} copy];
        [[KGNetworkManager sharedInstance]invokeNetWorkAPIWith:NNetworkUpdateUserAvatar withUserInfo:dictData success:^(id message) {
            [SVProgressHUD showInfoWithStatus:message[@"message"]];
             [ws.personalHeaderView.headerImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,dic[@"url"]]]];
        } failure:^(NSError *error) {
            
        } visibleHUD:NO];
      
    } fail:^(NSError *error) {
        
    }];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { // take photo / 去拍照
        [self takePhoto];
    } else if (buttonIndex == 1) {
        [self pushImagePickerController];
    }
}

#pragma mark - UIImagePickerController
- (void)takePhoto {
    //相机权限
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus ==AVAuthorizationStatusRestricted ||//此应用程序没有被授权访问的照片数据。可能是家长控制权限
        authStatus ==AVAuthorizationStatusDenied)  //用户已经明确否认了这一照片数据的应用程序访问
    {
        // 无相机权限 做一个友好的提示
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
        // 拍照之前还需要检查相册权限
    } else if ([TZImageManager authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        alert.tag = 1;
        [alert show];
    } else { // 调用相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerVc.sourceType = sourceType;
            if(iOS8Later) {
                self.imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self.view.window.rootViewController presentViewController:self.imagePickerVc animated:YES completion:nil];
        } else {
            NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
    }
}
//引导开启权限
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

#pragma mark - TZImagePickerController

- (void)pushImagePickerController {
    if (self.maxCountTF <= 0) {
        return;
    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxCountTF columnNumber:3 delegate:self pushPhotoPickerVc:YES];
    
    
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = NO;
    
//    if (self.maxCountTF > 1) {
//        // 1.设置目前已经选中的图片数组
//        imagePickerVc.selectedAssets = self.addMessageView.selectedAssets; // 目前已经选中的图片数组
//    }
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
//    imagePickerVc.allowCrop = YES;//允许裁剪
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    // imagePickerVc.navigationBar.translucent = NO;
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    // imagePickerVc.minImagesCount = 3;
    // imagePickerVc.alwaysEnableDoneBtn = YES;
    
    // imagePickerVc.minPhotoWidthSelectable = 3000;
    // imagePickerVc.minPhotoHeightSelectable = 2000;
    
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    //    imagePickerVc.showSelectBtn = NO;
    //    imagePickerVc.allowCrop = self.allowCropSwitch.isOn;
    //    imagePickerVc.needCircleCrop = self.needCircleCropSwitch.isOn;
    //    imagePickerVc.circleCropRadius = 100;
    /*
     [imagePickerVc setCropViewSettingBlock:^(UIView *cropView) {
     cropView.layer.borderColor = [UIColor redColor].CGColor;
     cropView.layer.borderWidth = 2.0;
     }];*/
    
    //imagePickerVc.allowPreview = NO;
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        [self upLoadUserHeadIm:[photos firstObject]];
//        self.addMessageView.selectedPhotos = [NSMutableArray arrayWithArray:photos];
//        self.addMessageView.selectedAssets = [NSMutableArray arrayWithArray:assets];
//        [self.addMessageView.publishPhotosView reloadDataWithImages:self.addMessageView.selectedPhotos];
//        NSLog(@"添加图片 --- 添加后有%zd张图片", self.addMessageView.selectedPhotos.count);
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES needFetchAssets:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        [self upLoadUserHeadIm:image];
//                        self.addMessageView.selectedPhotos = [NSMutableArray arrayWithArray:@[image]];
//                        self.addMessageView.selectedAssets = [NSMutableArray arrayWithArray:@[assetModel.asset]];
//                        [self.addMessageView.publishPhotosView reloadDataWithImages:self.addMessageView.selectedPhotos];
                    }];
                }];
            }
        }];
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

#pragma mark LazyLoad

-(MyFavQuestionCol *)favQuestionCol{
    if (_favQuestionCol == nil) {
        _favQuestionCol = [MyFavQuestionCol new];
        
    }
    return _favQuestionCol;
}
-(MyQuestionAnswerCol *)questionAnswerCol{
    
    if (_questionAnswerCol == nil) {
        _questionAnswerCol = [MyQuestionAnswerCol new];
        
    }
    return _questionAnswerCol;
}
-(MLBasePageViewController*)vc{
    if (_vc == nil) {
        _vc = [[MLBasePageViewController alloc] init];
        _vc.VCArray = @[ self.favQuestionCol,self.questionAnswerCol];
        _vc.sectionTitles = @[ @"关注问题", @"邀请通知"];
        _vc.MLBasePageViewBlock = ^(int index) {
            
        };
        
    }
    return _vc;
}

#pragma mark LazyLoad

-(ContactListViewController *)contactListCol{
    if (_contactListCol == nil) {
        _contactListCol = [ContactListViewController new];
        
    }
    return _contactListCol;
}
-(ChatListViewController *)chatListCol{
    
    if (_chatListCol == nil) {
        _chatListCol = [ChatListViewController new];
        
    }
    return _chatListCol;
}

-(MLBasePageViewController*)vcChat{
    if (_vcChat == nil) {
        _vcChat = [[MLBasePageViewController alloc] init];
        _vcChat.VCArray = @[ self.chatListCol,self.contactListCol];
        _vcChat.sectionTitles = @[ @"消息", @"联系人"];
        UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [addButton setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
        [addButton addTarget:self.contactListCol action:@selector(addFriendAction) forControlEvents:UIControlEventTouchUpInside];
        _addFriendItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
        weakSelf(ws);
        _vcChat.MLBasePageViewBlock = ^(int index) {
            if (index == 0) {
                ws.vc.navigationItem.rightBarButtonItem = nil;
            }
            else{
                ws.vc.navigationItem.rightBarButtonItem = _addFriendItem;
            }
        };
        
    }
    return _vcChat;
}

@end
