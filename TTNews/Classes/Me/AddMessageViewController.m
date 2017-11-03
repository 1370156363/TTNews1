//
//  AddMessageViewController.m
//  QuestionEveryday
//
//  Created by 薛立强 on 2017/6/20.
//  Copyright © 2017年 薛立强. All rights reserved.
//

#import "AddMessageViewController.h"
#import "AddMessageView.h"

#define ADDTITLESTR @"标题不超过20个字"
#define ADDMESSAGESTR @"内容不超过200个字"

@interface AddMessageViewController ()<TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) AddMessageView *addMessageView;

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

@property (nonatomic, assign)  NSInteger maxCountTF;  ///< 照片最大可选张数

@end

@implementation AddMessageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupviews];
    // Do any additional setup after loading the view.
}

-(void)setupviews
{
    _maxCountTF = 9;
    self.title = @"发布动态";
    //提交按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, 25);
    [rightBtn setTitle:@"提交" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize: 15.0];
    rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [rightBtn addTarget:self action:@selector(saveMessage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rewardItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -10;
    
    self.navigationItem.rightBarButtonItems = @[spaceItem,rewardItem];
    
    [self.view addSubview:self.addMessageView];
}

-(void)saveMessage
{
    if (self.addMessageView.textTitleView.text.length == 0 || [ADDTITLESTR isEqualToString:self.addMessageView.textTitleView.text]) {
        NSString *Vermessage = @"请输入标题";
        UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"提示" message:Vermessage preferredStyle:UIAlertControllerStyleAlert];
        
        //UIAlertAction给警告控制器添加一个事件按钮
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        //把action时间按钮安装到ac上
        [ac addAction:action];
        [self presentViewController:ac animated:YES completion:nil];
        return;
    }
    if (self.addMessageView.textContentView.text.length == 0 || [ADDMESSAGESTR isEqualToString:self.addMessageView.textContentView.text]) {
        NSString *Vermessage = @"请输入内容";
        UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"提示" message:Vermessage preferredStyle:UIAlertControllerStyleAlert];
        
        //UIAlertAction给警告控制器添加一个事件按钮
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        //把action时间按钮安装到ac上
        [ac addAction:action];
        [self presentViewController:ac animated:YES completion:nil];
        return;
    }
    if (self.addMessageView.selectedPhotos && self.addMessageView.selectedPhotos.count > 0) {
        weakSelf(ws)
        [KGNetworkManager uploadImageWithArray:self.addMessageView.selectedPhotos parameter:nil success:^(NSData* data) {
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&err];
            if(err == nil) {
                [ws upLoadDymanic:dic[@"info"][@"id"]];
            }
            
//            if ([dict[@"status"] intValue]==1){
//                NSLog(dict[@"Info"]);
//
//            }
            
            //[ws upLoadDymanic:]
        } fail:^(NSError *error) {
            
        }];
    }
    else{
        [self upLoadDymanic:nil];
    }
    
}

-(void)upLoadDymanic:(NSString*)cover_id{
    NSMutableDictionary *prms=[@{
                                 @"uid":[[OWTool Instance] getUid],
                                 @"description":self.addMessageView.textContentView.text,
                                 @"title":self.addMessageView.textTitleView.text
                                 }mutableCopy];
    if (cover_id) {
        [prms setValue:cover_id forKey:@"cover_id"];
    }
    weakSelf(ws)
    [[KGNetworkManager sharedInstance] invokeNetWorkAPIWith:KNetworkWenAddDongTai withUserInfo:prms success:^(NSDictionary *message)
     {
         if ([message[@"status"] intValue]==1)
         {
             [SVProgressHUD showImage:nil status:message[@"message"]];
             [SVProgressHUD dismissWithDelay:2];
             [ws popToRootViewController];
         }
         else
         {
             [SVProgressHUD showImage:nil status:message[@"message"]];
             [SVProgressHUD dismissWithDelay:2];
         }
     } failure:^(NSError *error) {
         
     } visibleHUD:NO];
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
                _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self presentViewController:_imagePickerVc animated:YES completion:nil];
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
    
    if (self.maxCountTF > 1) {
        // 1.设置目前已经选中的图片数组
        imagePickerVc.selectedAssets = self.addMessageView.selectedAssets; // 目前已经选中的图片数组
    }
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
        self.addMessageView.selectedPhotos = [NSMutableArray arrayWithArray:photos];
        self.addMessageView.selectedAssets = [NSMutableArray arrayWithArray:assets];
        [self.addMessageView.publishPhotosView reloadDataWithImages:self.addMessageView.selectedPhotos];
        NSLog(@"添加图片 --- 添加后有%zd张图片", self.addMessageView.selectedPhotos.count);
        
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
                        self.addMessageView.selectedPhotos = [NSMutableArray arrayWithArray:@[image]];
                        self.addMessageView.selectedAssets = [NSMutableArray arrayWithArray:@[assetModel.asset]];
                        [self.addMessageView.publishPhotosView reloadDataWithImages:self.addMessageView.selectedPhotos];
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

#pragma mark lazyLoad 
-(AddMessageView *) addMessageView
{
    if (_addMessageView == nil) {
        _addMessageView = [[AddMessageView alloc]init];
        _addMessageView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        [_addMessageView returnAddMorePhotoBlock:^{
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
            [sheet showInView:self.view];
        }];
    }
    return _addMessageView;
}

@end
