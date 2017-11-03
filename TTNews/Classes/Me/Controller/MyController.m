//
//  MyController.m
//  TTNews
//
//  Created by 西安云美 on 2017/7/26.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "MyController.h"
#import <SDImageCache.h>
#import "TTDataTool.h"
#import <SVProgressHUD.h>
#import "UIImage+Extension.h"
#import "TTConst.h"
#import "SendFeedbackViewController.h"
#import "AppInfoViewController.h"
#import "EditUserInfoViewController.h"
#import "UIImage+Extension.h"
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

@interface MyController ()<TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>
@property (nonatomic, weak) UISwitch                *shakeCanChangeSkinSwitch;
@property (nonatomic, assign) CGFloat               cacheSize;
@property (nonatomic, strong)NSMutableArray         *arrayDataItems;
@property (nonatomic,strong)KGMPersonalHeaderView   *personalHeaderView;
@property (nonatomic,strong)UITableView             *tableView;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

@property (nonatomic, assign)  NSInteger maxCountTF;  ///< 照片最大可选张数

@end

@implementation MyController


-(void)BtnAction:(NSInteger)tag
{
    if (tag==50)
    {
         LoginController* col = [[LoginController alloc] init];
        //登录成功刷新数据
        weakSelf(ws)
        col.LoginSuccessBlock = ^{
            [ws.personalHeaderView updateSubView];
        };
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
        edit.titleStr=@"昵称";
        [ws.navigationController pushViewController:edit animated:YES];
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
-(KGMPersonalHeaderView *)personalHeaderView
{
    weakSelf(ws);
    if (!_personalHeaderView)
    {
        _personalHeaderView=[[KGMPersonalHeaderView alloc] initWithFrame:CGRectMake(0, 0, winsize.width, 190)];
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
    _maxCountTF = 1;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, winsize.width, winsize.height-49) style:UITableViewStylePlain];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = RGB(240, 240, 240);
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
    [self caculateCacheSize];
    [self setupBasic];
    self.navigationController.navigationBar.barTintColor=navColor;
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(MainColor,0x444444,MainColor);
    self.tableView.tableHeaderView=self.personalHeaderView;
    self.tableView.separatorColor = [UIColor colorWithHexString:@"#dfdfdf"];
    self.arrayDataItems=[NSMutableArray array];
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [SVProgressHUD dismiss];
}

-(void)setupBasic{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    self.tableView.dk_separatorColorPicker = DKColorPickerWithKey(SEP);
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(0xfa5054,0x444444,0xfa5054);
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
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"我的商城";
    model.imageName=@"shangcheng";
    [self.arrayDataItems addObject:model];
    
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


-(void)caculateCacheSize {
    float imageCache = [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
    //    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"data.sqlite"];
    //    NSFileManager *fileManager = [NSFileManager defaultManager];
    //    float sqliteCache = [fileManager attributesOfItemAtPath:path error:nil].fileSize/1024.0/1024.0;
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
    //    else if (theSwitch == self.shakeCanChangeSkinSwitch) {//摇一摇夜间模式
    //        BOOL status = self.shakeCanChangeSkinSwitch.on;
    //        [[NSUserDefaults standardUserDefaults] setObject:@(status) forKey:IsShakeCanChangeSkinKey];
    //        [[NSUserDefaults standardUserDefaults] synchronize];
    //        if([self.delegate respondsToSelector:@selector(shakeCanChangeSkin:)]) {
    //            [self.delegate shakeCanChangeSkin:status];
    //        }
    //   }
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
                [ws.navigationController pushViewController:[fensiController new] animated:YES];
            })
             .height(81);
         }];
        
        [make makeSection:^(CBTableViewSectionMaker *section)
         {
             section.data(self.arrayDataItems)
             .cell([UITableViewCell class])
             .adapter(^(UITableViewCell *cell,KGTableviewCellModel *model,NSUInteger index)
                      {
                          cell=[cell initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"identify"];
                          cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                          cell.textLabel.text=model.title;
                          cell.imageView.image=[UIImage imageNamed:model.imageName];
                          
                          if (index==6)
                          {
                              UISwitch *sw=[[UISwitch alloc] init];
                              [cell.contentView addSubview:sw];
                              [sw mas_makeConstraints:^(MASConstraintMaker *make) {
                                  make.top.offset(5);
                                  make.bottom.offset(-5);
                                  make.right.offset(-20);
                                  make.width.mas_equalTo(30);
                              }];
                              [sw addTarget:self action:@selector(switchDidChange:) forControlEvents:UIControlEventValueChanged];
                          }
                          
                      })
             .event(^(NSUInteger index, KGTableviewCellModel *model)
                    {
                        //检验用户登录状态
                        if(index !=5 || index != 8 || index != 9){
                            if([[OWTool Instance] getUid] == nil || [[[OWTool Instance] getUid] isEqualToString:@""]){
                                [SVProgressHUD showImage:nil status:@"用户未登录"];
                                [SVProgressHUD dismissWithDelay:2];
                                return;
                            }
                        }
                        
                        if (index==0){
                            KGDynamicsController *dyVc=[KGDynamicsController new];
                            [self.navigationController pushViewController:dyVc animated:YES];
                        }
                        else if (index==1){
                            collectController *collect=[[collectController alloc] init];
                            [self.navigationController pushViewController:collect animated:YES];
                        }
                        else if (index == 2){
                            AddMessageViewController *col = [[AddMessageViewController alloc]init];
                            [self.navigationController pushViewController:col animated:YES];
                        }
                        else  if (index==5){
                            LibraryController *libraryVc=[[LibraryController alloc] init];
                            [self.navigationController pushViewController:libraryVc animated:YES];
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
                            weakSelf(ws)
                            settingCol.loginOutBlock = ^{
                                [ws.personalHeaderView updateSubView];
                            };
                            [self.navigationController pushViewController:settingCol  animated:YES];
                        }
                        
                    })
             .height(45);
         }];
    }];
}

#pragma mark -上传图片

-(void)upLoadUserHeadIm:(UIImage*)img{
    weakSelf(ws)
    [KGNetworkManager uploadImageWithArray:@[img] parameter:nil success:^(NSData* data) {
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        if(err == nil) {
            [ws.personalHeaderView.headerImg setImage:img];
        }
      
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
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
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

@end
