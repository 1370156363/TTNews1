//
//  ZhuanjiaController.m
//  TTNews
//
//  Created by 西安云美 on 2017/7/25.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "ZhuanjiaController.h"
#import "UserModel.h"

#import "ZhuanJiaTableViewCell.h"


@interface ZhuanjiaController ()
{
    NSMutableArray *guanzhuNum;
    ///进行比对的arr
    NSMutableArray *mutarr;
}

@property (nonatomic, assign) int currentPage;

@property (nonatomic, strong) NSMutableArray    *dataListArr;

@end

@implementation ZhuanjiaController

-(void)getguanzhu{
    NSMutableDictionary * dict=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[[OWTool Instance] getUid],@"uid", nil];
    [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:KNetworkGetGUANZHU withUserInfo:dict success:^(id message) {
        if ([message[@"status"] integerValue]==1) {
            NSMutableArray *newArr=[UserModel mj_objectArrayWithKeyValuesArray:message[@"data"]];
            [guanzhuNum addObjectsFromArray:newArr];
            [self getZhuanJia];
            for (UserModel *user in guanzhuNum) {
                [mutarr addObject:user.id];
            }
        }

    } failure:^(NSError *error) {

    } visibleHUD:YES];
}

-(void)getZhuanJia{

    NSMutableDictionary * dict=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",self.currentPage],@"page", nil];

    [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:KNetworkGetUser withUserInfo:dict success:^(id message) {
        [SVProgressHUD dismiss];
        if ([message[@"status"] integerValue]==1) {
            if (self.currentPage==1) {
                [self.dataListArr removeAllObjects];
            }

            NSMutableArray *newArr=[UserModel mj_objectArrayWithKeyValuesArray:message[@"info"]];

            [self.dataListArr addObjectsFromArray:newArr];
            if (newArr.count==0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            else{
                [self.tableView reloadData];
            }
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];

    } visibleHUD:YES];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];


}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (!self.dataListArr) {
        self.dataListArr=[[NSMutableArray alloc] init];
    }
    if (!guanzhuNum) {
        guanzhuNum=[[NSMutableArray alloc] init];
    }
    if (!mutarr) {
        mutarr=[[NSMutableArray alloc] init];
    }


    [self getguanzhu];
    [self setupBasic];
    [self setupRefresh];

    self.tableView.backgroundColor=HexRGB(0xE4E4E4);

}

#pragma mark 基本设置
- (void)setupBasic {
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);

    [self initNavigationWithImgAndTitle:@"专家团" leftBtton:nil rightButImg:nil rightBut:nil navBackColor:navColor];

    self.currentPage = 1;
}

-(void)setupRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.currentPage = 1;
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

    UserModel *model=self.dataListArr[indexPath.section];

    ZhuanJiaTableViewCell *cell;

    cell=[self.tableView dequeueReusableCellWithIdentifier:@"zhuanjia"];
    cell =[[NSBundle mainBundle] loadNibNamed:@"ZhuanJiaTableViewCell" owner:self options:nil][0];
    //                 cell=[];
    [cell.iconimage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,model.avatar]]];
    
    //                 cell.imageView.image=UIImageNamed(@"qq");
    cell.title.text=model.nicheng;
    if (model.signature.length!=0) {
        cell.detailLab.text=model.signature;
    }
    else{
        cell.detailLab.text=@"这个人很懒,什么都没留下";
    }

    if (mutarr.count!=0) {
        if ([mutarr containsObject:model.uid]) {
            cell.guanzhuBtu.selected=YES;
            [cell.guanzhuBtu setBackgroundColor:HexRGB(0xE4E4E4)];
        }
        else{
            cell.guanzhuBtu.layer.borderColor=[UIColor redColor].CGColor;
            cell.guanzhuBtu.layer.borderWidth=1;
        }
    }
    else{
        cell.guanzhuBtu.layer.borderColor=[UIColor redColor].CGColor;
        cell.guanzhuBtu.layer.borderWidth=1;
    }

//    cell.guanzhuBtu.tag=[model.uid integerValue]+100;
    cell.guanzhuBtu.tag=indexPath.section+100;

    cell.guanzhuBtu.layer.cornerRadius=5;
    cell.guanzhuBtu.userInteractionEnabled=YES;
    [cell.guanzhuBtu addTarget:self action:@selector(guanzhu:) forControlEvents:UIControlEventTouchUpInside];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:[UIColor whiteColor]];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
#pragma mark - /************************* 刷新数据 ***************************/
// ------下拉刷新
- (void)loadData
{

    self.currentPage=1;
    [self getZhuanJia];
}

- (void)loadMoreData
{
    self.currentPage+=1;
    [self getZhuanJia];
}

///关注
-(void)guanzhu:(UIButton *)btu{
    [self addGuanZhu:!btu.selected id:btu.tag-100];
}


-(void)addGuanZhu:(BOOL)isAdd id:(NSInteger)Id {
    UserModel *model=self.dataListArr[Id];

     NSMutableDictionary * dict=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)model.uid],@"uid", nil];
    ///添加即时通讯好友
    [self addContact:model.last_login_ip];
    ///接口没有调试
    if (isAdd) {
        ///添加关注
        [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:KNetworkAddGUANZHU withUserInfo:dict success:^(id message) {
            if ([message[@"status"] integerValue]==1) {
                ///重新修改关注
                [self getguanzhu];
            }
        } failure:^(NSError *error) {

        } visibleHUD:YES];

    }
    else{
        ///取消关注
        [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:KNetworkDelGuanZhu withUserInfo:dict success:^(id message) {
            if ([message[@"status"] integerValue]==1) {
                ///重新修改关注
                [self getguanzhu];
            }
        } failure:^(NSError *error) {

        } visibleHUD:YES];
    }

}

#pragma mark -添加好友
///添加好友申请
-(void)addContact:(NSString *)phoneStr{
//    phoneStr=@"17762274010";
    
    EMError *error = [[EMClient sharedClient].contactManager addContact:phoneStr message:@"我想加您为好友"];
    if (!error) {
        NSLog(@"添加成功");
    }
    else
    {

    }
}
@end
