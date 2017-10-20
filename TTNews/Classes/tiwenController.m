//
//  tiwenController.m
//  TTNews
//
//  Created by 西安云美 on 2017/7/26.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "tiwenController.h"
#import "BiaoqianController.h"

@interface tiwenController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    IBOutlet UITextField  *titlefield;
    IBOutlet UITextView   *content;
    IBOutlet UIButton     *photoBtn;
    IBOutlet UILabel      *placeholderLabel;
}
@end

@implementation tiwenController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"提问";
    [self setDoneBarButtonWithSelector:@selector(nextStep) andTitle:@"下一步"];
}

-(void)nextStep
{
    BiaoqianController *biaoqian=[[BiaoqianController alloc] init];
    [self.navigationController pushViewController:biaoqian animated:YES];
}

-(IBAction)BtnSelect:(UIButton *)sender
{
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
    [photoBtn setImage:info[UIImagePickerControllerEditedImage] forState:UIControlStateNormal];
    [self dismissViewController];
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        placeholderLabel.hidden = NO;
    } else {
        placeholderLabel.hidden = YES;
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    DismissKeyboard;
}
@end
