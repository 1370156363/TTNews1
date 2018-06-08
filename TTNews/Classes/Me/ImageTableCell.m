//
//  ImageTableCell.m
//  TTNews
//
//  Created by 薛立强 on 2017/11/10.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "ImageTableCell.h"

@interface ImageTableCell()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>


@end

@implementation ImageTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    weakSelf(ws)
    [self.imgPhoto wh_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [ws imgTapGesture];
    }];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"ImageTableCell" owner:self options:nil][0];
    }
    return self;
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
                               [[ws getCurrentViewController] dismissViewController];
                               [[ws getCurrentViewController] presentViewController:imagePicker animated:YES completion:^{}];
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
                              [[ws getCurrentViewController] dismissViewController];
                              [[ws getCurrentViewController] presentViewController:imagePicker animated:YES completion:^{}];
                          }];
    CKAlertAction *canCel=[CKAlertAction actionWithTitle:@"取消" handler:nil];
    [alert addAction:camera];
    [alert addAction:phont];
    [alert addAction:canCel];
    [[ws getCurrentViewController] presentViewController:alert animated:NO completion:nil];
}
#pragma mark 获取当前视图控制器
- (UIViewController*)getCurrentViewController{
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}


-(void)hiddenKeyBoard
{
    DismissKeyboard;
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    self.imgPhoto.image=info[UIImagePickerControllerEditedImage];
    weakSelf(ws)
    [[KGNetworkManager sharedInstance] uploadImageWithArray:[NSMutableArray arrayWithObject:self.imgPhoto.image] parameter:nil success:^(NSData* data) {
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        if(err == nil) {
            [[ws getCurrentViewController] dismissViewController];
            _aproveImgId = dic[@"info"][@"id"];
        }
        
    } fail:^(NSError *error) {
        
    }];
}

@end
