//
//  MyCommentViewController.m
//  TTNews
//
//  Created by mac on 2017/10/30.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "MyCommentViewController.h"
#import "NewsTableViewCell.h"
#import "NewsTableViewCell.h"

#import "CommentTableViewCell.h"
#import "WenDaComment.h"

#define INTERVAL_KEYBOARD 0


@interface MyCommentViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSArray *dataArr;
    ///评论数据
    NSMutableArray *commentArr;
}


@property (weak, nonatomic) IBOutlet UITableView *MainTabView;
@property (weak, nonatomic) IBOutlet UITextField *textView;
@property (weak, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UIButton *okBtu;
- (IBAction)okAction:(UIButton *)sender;

@end

@implementation MyCommentViewController

///获取评论的网络连接
-(void)getCommet{
//KNetworkGetCommnet
    NSMutableDictionary * dict=[[NSMutableDictionary alloc] initWithObjectsAndKeys:self.video.id,@"id",self.video.model_id,@"model_id", nil];
    [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:KNetworkGetCommnet withUserInfo:dict success:^(id message) {

        NSNumber *num=message[@"status"];
        if ([num integerValue]==1) {
            if (!commentArr) {
                commentArr=[[NSMutableArray alloc] init];
            }
            commentArr=[WenDaComment mj_objectArrayWithKeyValuesArray:message[@"data"]];
            if (commentArr.count!=0) {
                [self.MainTabView reloadData];
            }

        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    } visibleHUD:NO];

}
#pragma mark -界面设置
- (void)viewDidLoad {
    [super viewDidLoad];
    ///
    [self setupBasic];
    if (!dataArr) {
        dataArr=@[@"1",@"2"];
    }
    if (!commentArr) {
        commentArr=[[NSMutableArray alloc] init];
    }

    self.MainTabView.delegate=self;
    self.MainTabView.dataSource=self;
    [self.MainTabView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.okBtu.layer.cornerRadius=5;
    self.textView.delegate=self;
    self.textView.returnKeyType=UIReturnKeyDone;

    [self getCommet];

    ///添加通知
    [self addEventListening];
}


-(void)setupBasic{
    [self initNavigationWithImgAndTitle:@"评论详情" leftBtton:nil rightButImg:nil rightBut:nil navBackColor:navColor];

    self.view.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);

    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(MainColor,0x444444,MainColor);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - TableView DataSource

// Default is 1 if not implemented
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return commentArr.count+1;
}

#pragma mark -UITableViewDataSource 返回tableView每一组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

//每个section头部标题高度（实现这个代理方法后前面 sectionFooterHeight 设定的高度无效）
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 2;
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
    ///支付
    NSString *cellId;

    if (indexPath.section==0) {
        NewsTableViewCell *cell;
        cell=[tableView dequeueReusableCellWithIdentifier:@"news"];
        cell =[[NSBundle mainBundle] loadNibNamed:@"NewsTableViewCell" owner:self options:nil][0];
        cell.txtLab.text=self.video.title;

        NSArray *imagss=[self.video.fengmian componentsSeparatedByString:@","];
        if (imagss.count!=0) {
            [cell.myImage1 setBackgroundColor:[UIColor redColor]];
            [cell.myImage1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,imagss[0]]] placeholderImage:nil];
        }
        return cell;
    }
    else{
        ///commnet cell
        CommentTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"commentCell"];
        cell =[[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:self options:nil][0];
        cell.comment=commentArr[indexPath.section-1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [cell setBackgroundColor:[UIColor whiteColor]];

        return cell;
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

///发功消息事件
-(void)SendMessage{
    if (self.textView.text.length==0) {
        return;
    }
    NSMutableDictionary * dict=[[NSMutableDictionary alloc] initWithObjectsAndKeys:self.video.id,@"id",[[OWTool Instance] getUid],@"uid",self.video.model_id,@"model_id",self.textView.text,@"title", nil];
    [[KGNetworkManager sharedInstance] invokeNetWorkAPIWith:KnetworkAddPingLun withUserInfo:dict success:^(id message) {
        [SVProgressHUD dismiss];
        [self getCommet];
        self.textView.text=@"";
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    } visibleHUD:YES];
}

@end
