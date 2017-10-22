//
//  tiwenController.m
//  TTNews
//
//  Created by 西安云美 on 2017/7/26.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "tiwenController.h"
#import "BiaoqianController.h"

#import "TiWenTableViewCell.h"
#import "ImageModel.h"


@interface tiwenController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,TiWenTableViewCellDelegate,UITextFieldDelegate>
{
    NSString *title;
    NSString *content;
    NSMutableArray *imagesArr;
    NSMutableArray *imagesModeArr;
    ///判断是哪个btu点击的图片
    NSInteger BtuTags;
    ///加载第一次,然后隐藏lab
    NSInteger isok;
}
///
@property (weak, nonatomic) IBOutlet UITableView *MainTabView;

@property (nonatomic, strong) NSMutableArray    *dataListArr;



@end

@implementation tiwenController



- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.dataListArr) {
        self.dataListArr=[@[@"1",@"2",@"3"] mutableCopy];
    }
    if (!imagesArr) {
        imagesArr=[[NSMutableArray alloc] init];
    }
    if (!imagesModeArr) {
        imagesModeArr=[[NSMutableArray alloc] init];
    }
    self.MainTabView.delegate=self;
    self.MainTabView.dataSource=self;
    self.MainTabView.separatorStyle=UITableViewCellSeparatorStyleNone;

    [self initNavigationWithImgAndTitle:@"提问" leftBtton:nil rightButImg:nil rightBut:@"完成" navBackColor:navColor];
    [self.navigationItem.rightBarButtonItems[1] setAction:@selector(nextStep)];

    isok=0;

}

-(void)nextStep
{
    if (imagesArr.count==0) {
        [SVProgressHUD showErrorWithStatus:@"请上传1～9张图片"];
        return;
    }
    if (title.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请填写标题"];
        return;
    }

    ///发布
    switch (self.type) {
        case DongTaiType:
        {
            NSString *imagesidStr=@"";
            NSInteger num=0;
            for (ImageModel *iamgemode in imagesModeArr) {
                if (num==0) {
                    imagesidStr=[NSString stringWithFormat:@"%@",iamgemode.id];
                }
                else{
                    imagesidStr=[NSString stringWithFormat:@"%@,%@",imagesidStr,iamgemode.id];
                }
                num++;
            }

            NSMutableDictionary *dicts=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[[OWTool Instance] getUid],@"uid",title,@"title",imagesidStr,@"cover_id", nil];

            if (content.length!=0) {
                [dicts setObject:content forKey:@"description"];
            }
            
            [[KGNetworkManager sharedInstance] invokeNetWorkAPIWith:KNetworkWenAddDongTai withUserInfo:dicts success:^(id message) {
                [SVProgressHUD dismiss];

                if ([message[@"status"] integerValue]==1) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } failure:^(NSError *error) {

            } visibleHUD:YES];

        }
            break;
        case WenDaType:
        {
            NSString *imagesidStr=@"";
            NSInteger num=0;
            for (ImageModel *iamgemode in imagesModeArr) {
                if (num==0) {
                    imagesidStr=[NSString stringWithFormat:@"%@",iamgemode.id];
                }
                else{
                    imagesidStr=[NSString stringWithFormat:@"%@,%@",imagesidStr,iamgemode.id];
                }
                num++;
            }

            NSMutableDictionary *dicts=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[[OWTool Instance] getUid],@"uid",title,@"title",imagesidStr,@"cover_id", nil];

            if (content.length!=0) {
                [dicts setObject:content forKey:@"description"];
            }
            [[KGNetworkManager sharedInstance] invokeNetWorkAPIWith:KNetworkWenAddWenDa withUserInfo:dicts success:^(id message) {
                [SVProgressHUD dismiss];
                if ([message[@"status"] integerValue]==1) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } failure:^(NSError *error) {

            } visibleHUD:YES];
        }
            break;
        default:
            break;
    }

}

#pragma mark - TableView DataSource

// Default is 1 if not implemented
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataListArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
//每个section头部标题高度（实现这个代理方法后前面 sectionFooterHeight 设定的高度无效）
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

//每个section头部的标题－Header
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return [NSString stringWithFormat:@"共有%lu辆车",(unsigned long)dataArr.count];
//}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    //    view.tintColor = [UIColor blackColor];

    if ([view isMemberOfClass:[UITableViewHeaderFooterView class]]) {
        ((UITableViewHeaderFooterView *)view).backgroundView.backgroundColor = [UIColor clearColor];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {

    if ([view isMemberOfClass:[UITableViewHeaderFooterView class]]) {
        ((UITableViewHeaderFooterView *)view).backgroundView.backgroundColor = [UIColor clearColor];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TiWenTableViewCell *cell;

    switch (indexPath.section) {
        case 0:
        {
            cell=[tableView dequeueReusableCellWithIdentifier:@"messageCell"];
            cell =[[NSBundle mainBundle] loadNibNamed:@"TiWenTableViewCell" owner:self options:nil][0];
            cell.messageTxt.returnKeyType=UIReturnKeyDone;
            cell.messageTxt.delegate=self;
            if (title.length!=0) {
                cell.messageTxt.text=title;
            }
        }
            break;
        case 1:
        {
            cell=[tableView dequeueReusableCellWithIdentifier:@"contentCell"];
            cell =[[NSBundle mainBundle] loadNibNamed:@"TiWenTableViewCell" owner:self options:nil][1];
            cell.contextTxt.delegate=self;
            if (content.length!=0) {
                cell.contextTxt.text=title;
                [cell.contentLab setHidden:YES];
                [cell setContent:content];

            }
            cell.contextTxt.returnKeyType=UIReturnKeyDone;

        }
            break;
        case 2:
        {
            cell=[tableView dequeueReusableCellWithIdentifier:@"imageCell"];
            cell =[[NSBundle mainBundle] loadNibNamed:@"TiWenTableViewCell" owner:self options:nil][2];
            cell.delegate=self;
            if (imagesArr.count!=0) {
                cell.image1.userInteractionEnabled=YES;

                cell.images=imagesArr;
            }

        }
            break;
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:[UIColor whiteColor]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section==0) {
        return 56;
    }
    else if(indexPath.section==1){
        return 192;
    }
    else{
        return 354;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==2) {
        DismissKeyboard;
    }
}

#pragma mark -界面展示

-(IBAction)BtnSelect:(UIButton *)sender
{

}

-(void)selsectImage{

    weakSelf(ws);
    CKAlertViewController *alert=[CKAlertViewController alertControllerWithTitle:@"添加照片" message:@""];
    CKAlertAction *camera=[CKAlertAction actionWithTitle:@"相机" handler:^(CKAlertAction *action)
                           {
                               UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                               imagePicker.delegate = ws;
                               imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                               imagePicker.allowsEditing = YES;
                               imagePicker.showsCameraControls = YES;
                               [ws dismissViewControllerAnimated:YES completion:nil];
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
                              [ws dismissViewControllerAnimated:YES completion:nil];
                              [ws presentViewController:imagePicker animated:YES completion:^{}];
                          }];
    CKAlertAction *canCel=[CKAlertAction actionWithTitle:@"取消" handler:nil];
    [alert addAction:camera];
    [alert addAction:phont];
    [alert addAction:canCel];
    [ws presentViewController:alert animated:NO completion:nil];

}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewController];

    UIImage *image=info[UIImagePickerControllerEditedImage];
    [self uploadImag:image];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    content=textView.text;
    if (isok==0&&content.length!=0) {
        [self.MainTabView reloadData];
        isok++;
    }
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    title=textField.text;
    
    DismissKeyboard;
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    title=textField.text;
    DismissKeyboard;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    DismissKeyboard;
}



#pragma mark -cellDegl
-(void)clickImageBtu:(UIButton *)sender{

    BtuTags=sender.tag-100;
    [self selsectImage];
}

#pragma mark -上传图片
-(void)uploadImag:(UIImage *)iamge{
    NSMutableArray *iamgess=[[NSMutableArray alloc] init];
    [iamgess addObject:iamge];
    [KGNetworkManager uploadImageWithArray:iamgess parameter:nil success:^(id response) {
        NSData *data=response;
        NSString *str=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *dict=[str mj_JSONObject];
        dict=dict[@"info"];
        ImageModel *imageMode=[ImageModel mj_objectWithKeyValues:dict];

        NSString *url=[dict objectForKey:@"path"];
        if (BtuTags<=imagesArr.count) {
            [imagesArr removeObjectAtIndex:BtuTags-1];
            [imagesArr insertObject:url atIndex:BtuTags-1];

            [imagesModeArr removeObjectAtIndex:BtuTags-1];
            [imagesModeArr insertObject:imageMode atIndex:BtuTags-1];
        }
        else{
            [imagesArr insertObject:url atIndex:BtuTags-1];
            [imagesModeArr insertObject:imageMode atIndex:BtuTags-1];
        }

        [self.MainTabView reloadData];

    } fail:^(NSError *error) {

    }];
    
}

@end
