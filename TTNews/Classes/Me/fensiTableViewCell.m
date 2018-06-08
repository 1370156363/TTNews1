//
//  fensiTableViewCell.m
//  TTNews
//
//  Created by 薛立强 on 2017/10/28.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "fensiTableViewCell.h"
#import "LoginController.h"

@interface fensiTableViewCell(){
    
}
@property(nonatomic,strong)UIView *separatorView;

@end

@implementation fensiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupview];
    // Initialization code
}

//懒加载创建
-(UIView *)separatorView{
    
    if (_separatorView == nil) {
        
        _separatorView = [[UIView alloc]init];
        _separatorView.backgroundColor = [UIColor lightGrayColor];
        _separatorView.alpha = 0.6;
    }
    return _separatorView;
}

//在layout方法里设置frame
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat w = self.bounds.size.width;
    CGFloat h = 0.5;
    CGFloat x = 30;
    CGFloat y = self.bounds.size.height-h;
    self.separatorView.frame = CGRectMake(x, y, w, h);
}

-(void)setupview{
    _imgHeaderView.layer.cornerRadius = 30;
    _imgHeaderView.contentMode = UIViewContentModeScaleAspectFit;
    _imgHeaderView.clipsToBounds = YES;
    
    _imgHeaderView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick)];
    [_imgHeaderView addGestureRecognizer:tap];
    _btnAttention.layer.cornerRadius = 5.0;
    _btnAttention.layer.borderWidth = 1.0;
    _btnAttention.layer.borderColor = [UIColor redColor].CGColor;
    _btnAttention.userInteractionEnabled = YES;
    self.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x343434, 0xfafafa);
    
    self.contentView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x343434, 0xfafafa);
    _labNickname.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    [self.contentView addSubview:self.separatorView];
 
}
///图像点击事件
-(void)imageViewClick{
    self.ImageBlock();
}
- (IBAction)btnAttentionClick:(UIButton*)sender {
    if([[OWTool Instance] getUid] == nil || [[[OWTool Instance] getUid] isEqualToString:@""]){
        [SVProgressHUD showErrorWithStatus:@"用户未登录!"];
        [SVProgressHUD dismissWithDelay:2.0];
        return;
    }
    else{
        if(_type == NewTableViewCellType_AddFocus){
            if([_model1.uid intValue] == [[[OWTool Instance] getUid] intValue]){
                UIAlertController *alertCol = [UIAlertController alertControllerWithTitle:@"提示" message:@"不能关注自己！" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [alertCol addAction:action];
                [[self parentAcontoller:self] presentViewController:alertCol animated:NO completion:nil];
            }
            else{
                NSMutableDictionary *prms=[@{
                                             @"id":[[OWTool Instance] getUid],
                                             @"uid":_model1.uid,
                                             }mutableCopy];
                [[KGNetworkManager sharedInstance] invokeNetWorkAPIWith:KNetworkAddGUANZHU withUserInfo:prms success:^(NSDictionary *message)
                 {
                     if ([message[@"status"] intValue]==0)
                     {
                         [SVProgressHUD showInfoWithStatus:message[@"msg"]];
                         [SVProgressHUD dismissWithDelay:2];
                     }
                     else{
                         [_btnAttention setTitle:@"已关注" forState:UIControlStateNormal];
                         [_btnAttention setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                         _btnAttention.layer.borderColor = [UIColor lightGrayColor].CGColor;
                         _btnAttention.userInteractionEnabled = false;
                     }
                     //[SVProgressHUD dismiss];
                     
                 } failure:^(NSError *error) {
                     
                 } visibleHUD:NO];
            }
        }
        else{
            NSMutableDictionary *prms=[@{
                                         @"beiyaoqingren_id":[NSString stringWithFormat:@"%d",[_model2.uid intValue]],
                                         @"yaoqingren_id":[[OWTool Instance] getUid],
                                         @"answer_id":_answerID
                                         }mutableCopy];
            [[KGNetworkManager sharedInstance] invokeNetWorkAPIWith:KNetworkAddIQuestionNivite withUserInfo:prms success:^(NSDictionary *message)
             {
                 if ([message[@"status"] intValue]==0)
                 {
                     [SVProgressHUD showInfoWithStatus:message[@"msg"]];
                     [SVProgressHUD dismissWithDelay:2];
                 }
                 else{
                     [_btnAttention setTitle:@"已邀请" forState:UIControlStateNormal];
                     [_btnAttention setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                     _btnAttention.layer.borderColor = [UIColor lightGrayColor].CGColor;
                     _btnAttention.userInteractionEnabled = false;
                 }
                 [SVProgressHUD dismiss];
                 
             } failure:^(NSError *error) {
                 
             } visibleHUD:YES];
        }
    }
}

-(void)setModel:(MyFensiModel *)model{
    _model = model;
    _userID = model.ID;
    _type = NewTableViewCellType_Focus;
    _btnAttention.hidden = YES;
    [_imgHeaderView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,model.avatar]] placeholderImage:[UIImage imageNamed:@"geren"]];
    _labNickname.text = model.nicheng?model.nicheng:model.username;
    _labSignature.text = model.sign?model.sign:@"这个家伙很懒，什么都没有留下！";
}
-(void)setModel1:(AddUserInfoModel *)model1{
    _model1 = model1;
    _userID = model1.uid;
    _type = NewTableViewCellType_AddFocus;
    _btnAttention.hidden = NO;
    if ([_model1.isfirend boolValue]|| [_model1.is_guanzhu boolValue]) {
        [_btnAttention setTitle:@"已关注" forState:UIControlStateNormal];
        [_btnAttention setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _btnAttention.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _btnAttention.userInteractionEnabled = NO;
    }
    [_imgHeaderView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,model1.avatar]] placeholderImage:[UIImage imageNamed:@"geren"]];
    _labNickname.text = model1.nicheng?model1.nicheng:model1.username;
    _labSignature.text = model1.signature?model1.signature:@"这个家伙很懒，什么都没有留下！";
}
-(void)setModel2:(AddUserInfoModel *)model2{
    _model2 = model2;
    _userID = model2.uid;
    _type = NewTableViewCellType_Invit;
    _btnAttention.hidden = NO;
    if ([_model2.is_yaoqing boolValue]) {
        [_btnAttention setTitle:@"已邀请" forState:UIControlStateNormal];
        [_btnAttention setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _btnAttention.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _btnAttention.userInteractionEnabled = NO;
    }
    else{
        [_btnAttention setTitle:@"邀请问答" forState:UIControlStateNormal];
        [_btnAttention setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _btnAttention.layer.borderColor = [UIColor redColor].CGColor;
        _btnAttention.userInteractionEnabled = YES;
    }
    [_imgHeaderView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,model2.avatar]] placeholderImage:[UIImage imageNamed:@"geren"]];
    _labNickname.text = model2.nicheng?model2.nicheng:model2.username;
    _labSignature.text = model2.signature?model2.signature:@"这个家伙很懒，什么都没有留下！";
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self==[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self=[[NSBundle mainBundle] loadNibNamed:@"fensiTableViewCell" owner:self options:nil][0];
    }
    return self;
}

///获取当前视图控制器
-(UIViewController*)parentAcontoller:(UIView*)view{
    UIResponder *responder = [view nextResponder];
    while (responder) {
        if([responder isKindOfClass:[UIViewController class]]){
            return (UIViewController*)responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

@end
