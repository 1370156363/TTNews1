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

@interface MyCommentViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *dataArr;
    ///评论数据
    NSMutableArray *commentArr;
}


@property (weak, nonatomic) IBOutlet UITableView *MainTabView;

@end

@implementation MyCommentViewController

///获取评论的网络连接
-(void)getCommet{
//KNetworkGetCommnet
    NSMutableDictionary * dict=[[NSMutableDictionary alloc] initWithObjectsAndKeys:self.video.id,@"id",@"4",@"model_id", nil];
    [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:KNetworkGetCommnet withUserInfo:dict success:^(id message) {
        if ([message[@"1"] isEqualToString:@"1"]) {
            commentArr=message[@"data"];
            if (commentArr) {

                if (commentArr.count!=0) {
                    [self.MainTabView reloadData];
                }

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
    [self getCommet];

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





@end
