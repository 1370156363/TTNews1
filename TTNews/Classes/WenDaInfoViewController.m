//
//  WenDaInfoViewController.m
//  TTNews
//
//  Created by mac on 2017/10/21.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "WenDaInfoViewController.h"
///评论
#import "CommentTableViewCell.h"
///文字
#import "WenDaMessageTableViewCell.h"
//图片
#import "WenDaInfoImgTableViewCell.h"

#import "WenDaComment.h"
#import "UIView+Extension.h"

#import "IDMPhotoBrowser.h"


#define INTERVAL_KEYBOARD 0

@interface WenDaInfoViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *commentArr;

}

@property (nonatomic, strong) NSMutableArray    *dataListArr;

@property (weak, nonatomic) IBOutlet UILabel *TitleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UITableView *MainTabView;

@property (weak, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UITextField *textView;

///发送
@property (weak, nonatomic) IBOutlet UIButton *OkAction;
- (IBAction)okAction:(UIButton *)sender;

///键盘
/***键盘高度***/
@property (nonatomic, assign)CGFloat keyboardHeight;

/***当前键盘是否可见*/
@property (nonatomic,assign)BOOL keyboardIsVisiable;
@property (nonatomic,assign) CGFloat origin_y;

//键盘设置
@property (nonatomic, copy) void (^keyIsVisiableBlock)(BOOL keyboardIsVisiable);

@end

@implementation WenDaInfoViewController

-(NSMutableArray *)dataListArr{
    if (!_dataListArr) {
        _dataListArr=[[NSMutableArray alloc] init];
    }
    return _dataListArr;
}

///发功消息事件
-(void)SendMessage{

    if (self.textView.text.length==0) {
        return;
    }
    NSMutableDictionary * dict=[[NSMutableDictionary alloc] initWithObjectsAndKeys:self.wenda.id,@"id",[[OWTool Instance] getUid],@"uid",self.textView.text,@"title", nil];
    [[KGNetworkManager sharedInstance] invokeNetWorkAPIWith:KNetworkWenAddWenDaComment withUserInfo:dict success:^(id message) {
        [SVProgressHUD dismiss];
        [self getAnswer];
        self.textView.text=@"";
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    } visibleHUD:YES];
}


-(void)getAnswer{
    NSMutableDictionary * dict=[[NSMutableDictionary alloc] initWithObjectsAndKeys:self.wenda.id,@"id", nil];
        //获取验证码
	[[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:KNetworkWenDaComment withUserInfo:dict success:^(id message) {
        [SVProgressHUD dismiss];
        ///每一次都重置
        if (!commentArr) {
            commentArr=[[NSMutableArray alloc] init];
        }
        else{
            [self.dataListArr removeAllObjects];
            [commentArr removeAllObjects];
        }

        NSNumber *num=message[@"status"];
        [self showTabview];
        
        if ([num integerValue]==1) {
            commentArr=[WenDaComment mj_objectArrayWithKeyValuesArray:message[@"data"]];
            if (commentArr.count==0) {
            }
            else{
                [self.dataListArr addObject:@"pinglun"];
            }
        }
        [self.MainTabView reloadData];


    } failure:^(NSError *error)
      {
          [SVProgressHUD showErrorWithStatus:@"网络错误"];
      } visibleHUD:YES];


}

-(void)showTabview{
    ///文字
    [self.dataListArr addObject:self.wenda.description];

    NSArray *imags=[self.wenda.fengmian componentsSeparatedByString:@","];
    for (NSString *url in imags) {
        NSString *urls=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,url];
        [self.dataListArr addObject:urls];
    }

//    CGIMAGEGETIMAGEWIDTH(image)

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    [self initNavigationWithImgAndTitle:@"详情" leftBtton:nil rightButImg:nil rightBut:nil navBackColor:navColor];
    self.TitleLab.text=self.wenda.title;
    self.timeLab.text=self.wenda.create_time;
    [self getAnswer];
    self.MainTabView.delegate=self;
    self.MainTabView.dataSource=self;
    // 去掉分割线
    self.MainTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册
    [self.MainTabView registerNib:[UINib nibWithNibName:NSStringFromClass([WenDaMessageTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"titleLab"];
    // 注册
    [self.MainTabView registerNib:[UINib nibWithNibName:NSStringFromClass([WenDaInfoImgTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"imageCell"];
    // 注册
    [self.MainTabView registerNib:[UINib nibWithNibName:NSStringFromClass([CommentTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"commentCell"];

    self.textView.delegate=self;
    self.textView.returnKeyType=UIReturnKeyDone;

    self.OkAction.layer.cornerRadius=5;

    ///添加通知
    [self addEventListening];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - TableView DataSource

// Default is 1 if not implemented
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataListArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ((section+1)==self.dataListArr.count) {
        NSString *str=[self.dataListArr lastObject];
        if ([str isEqualToString:@"pinglun"]) {
            return commentArr.count;
        }
        else{
            return 1;
        }
    }
    else{
        return 1;
    }
}
//每个section头部标题高度（实现这个代理方法后前面 sectionFooterHeight 设定的高度无效）
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
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
    NSString *cellId;

    NSString *str =self.dataListArr[indexPath.section];
    if (indexPath.section==0) {
        WenDaMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleLab"];
        cell.comment=self.wenda;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:[UIColor whiteColor]];

        return cell;
    }
    else if(indexPath.section+1==self.dataListArr.count &&
            [(NSString *)[self.dataListArr lastObject] isEqualToString:@"pinglun"]){

        CommentTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"commentCell"];
        cell.comment=commentArr[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:[UIColor whiteColor]];
        
        return cell;
    }
    else{
        ///图片
        WenDaInfoImgTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"imageCell"];
        cell.url=str;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:[UIColor whiteColor]];

        return cell;
    }

}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    if (indexPath.section==0) {
//        ///标题
//        return [tableView fd_heightForCellWithIdentifier:@"titleLab" configuration:^(WenDaMessageTableViewCell *cell) {
//            // 配置 cell 的数据源，和 "cellForRow" 干的事一致，比如：
//            cell.comment=self.wenda;
//        }];
//    }
//    else if(indexPath.section+1==self.dataListArr.count &&
//            [(NSString *)[self.dataListArr lastObject] isEqualToString:@"pinglun"])
//    {
//        return [tableView fd_heightForCellWithIdentifier:@"commentCell" configuration:^(CommentTableViewCell *cell) {
//            cell.comment=commentArr[indexPath.row];
//        }];
//    }
//    else{
//        return [tableView fd_heightForCellWithIdentifier:@"imageCell" configuration:^(WenDaInfoImgTableViewCell *cell) {
//            NSString *str =self.dataListArr[indexPath.section];
//            ///图片
//            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
//            UIImage *image=[UIImage imageWithData:data];
//            cell.Image=image;
//        }];
//    }
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[WenDaInfoImgTableViewCell class]]) {

    }
}

#pragma mark -发送

- (IBAction)okAction:(UIButton *)sender {
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    ///发布消息
    [self SendMessage];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    ///键盘落下
    // 关闭键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    // 关闭键盘
    [self.textView resignFirstResponder];
    return YES;
}


// 添加通知
-(void)addEventListening
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark 键盘设置
- (void)keyboardWillShow:(NSNotification *)notification
{
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;

    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset = (self.footView.frame.origin.y+self.footView.frame.size.height+INTERVAL_KEYBOARD) - (self.view.frame.size.height - kbHeight);

    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    //将视图上移计算好的偏移
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }

}

- (void)keyboardWillHidden:(NSNotification *)notification
{
    // 键盘动画时间
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}
@end
