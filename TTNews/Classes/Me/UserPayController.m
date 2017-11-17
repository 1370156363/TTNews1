//
//  UserPayController.m
//  TTNews
//
//  Created by 薛立强 on 2017/11/9.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "UserPayController.h"
#import "MyShoppongTableCell.h"
#import "AddressTableCell.h"
#import "AddressManageController.h"


@interface UserPayController ()

@property (strong, nonatomic) UITableView *tableview;
@property (strong, nonatomic) NSDictionary* addressDic;

@end

@implementation UserPayController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:self.tableview];
    self.title = @"购买";
    [self.tableview registerNib:[UINib nibWithNibName:@"MyShoppongTableCell" bundle:nil] forCellReuseIdentifier:@"MyShoppongTableCellIdentify"];
    [self request];
}

//网络请求
-(void)request{
    NSMutableDictionary *prms = [@{
                                   @"uid":[[OWTool Instance] getUid]
                                   }mutableCopy];
    weakSelf(ws)
    [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:kNetworkGetAllAddress withUserInfo:prms success:^(NSArray *message)
     {
         if (message.count> 0) {
             _addressDic = message[0];
         }
         else{
             _addressDic = nil;
         }
         [ws.tableview reloadData];
     } failure:^(NSError *error) {
         
     } visibleHUD:NO];
}

#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"identify"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle     reuseIdentifier:@"identify"];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.imageView.clipsToBounds = YES;
        
    }
    if (section == 0) {
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.text = self.modelList[@"title"];
        NSMutableAttributedString *stringTotal = [[NSMutableAttributedString alloc]initWithString:@"总计 "];
        NSMutableAttributedString *stringPrice = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@",self.modelList[@"price"]]];
        // 设置价格为蓝色
        [stringPrice addAttribute:NSForegroundColorAttributeName value:navColor range:NSMakeRange(0, stringPrice.length)];
        
        NSMutableAttributedString *stringNum = [[NSMutableAttributedString alloc]initWithString:@"   数量 1"];
        //设置数量颜色
        [stringNum addAttribute:NSForegroundColorAttributeName value:navColor range:NSMakeRange(6, 1)];
        
        [stringTotal appendAttributedString:stringPrice];
        [stringTotal appendAttributedString:stringNum];
        
        cell.detailTextLabel.attributedText = stringTotal;
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://xinwen.52jszhai.com",self.modelList[@"fengmian"]]] placeholderImage:ImageNamed(@"tupianGL")];
    }
    else if (section == 1){
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        if (_addressDic != nil) {
            cell.textLabel.text = _addressDic[@"consignee"];
            UILabel *labPhone = [cell viewWithTag:100];
            if (labPhone == nil) {
                labPhone = [[UILabel alloc]init];
                labPhone.tag = 100;
                [cell.contentView addSubview:labPhone];
                labPhone.sd_layout
                .topSpaceToView(cell.contentView, 10)
                .rightSpaceToView(cell.contentView, 10)
                .widthIs(100)
                .heightIs(20);
            }
            labPhone.text =_addressDic[@"mobile"];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@%@%@",_addressDic[@"province"],_addressDic[@"city"],_addressDic[@"district"],_addressDic[@"address"]]];
            // 创建图片图片附件
            NSTextAttachment *attach = [[NSTextAttachment alloc] init];
            attach.image = [UIImage imageNamed:@"dingwei"];
            attach.bounds = CGRectMake(0, 0, 16, 16);
            NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
            [string insertAttributedString:attachString atIndex:0];
            cell.detailTextLabel.attributedText = string;
          
        }
        else{
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:@"请添加准确的收货人信息，去添加"];
            // 设置“去添加”为蓝色
            [string addAttribute:NSForegroundColorAttributeName value:navColor range:NSMakeRange(11, 3)];
            [string addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:24] range:NSMakeRange(11, 3)];
            [string addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(11, 3)];
        }
    }
    else if (section ==2){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.image = ImageNamed(@"zhifubaoZF");
    }
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *labViewSction = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 40)];
    labViewSction.textColor = [UIColor blackColor];
    labViewSction.font = [UIFont systemFontOfSize:18];
    if (section == 0) {
        return [UIView new];
    }
    else if (section == 1) {
        labViewSction.text = @"请选择收货地址：";
    }
    else if (section == 2){
        labViewSction.text = @"请选择付款方式：";
    }
    return labViewSction;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //地址
    if (indexPath.section == 1) {
        AddressManageController *col = [[AddressManageController alloc]init];
        col.isSelectAddress = YES;
        weakSelf(ws)
        col.AddressSelectBlock = ^(NSDictionary *model) {
            _addressDic = model;
            [ws.tableview reloadSection:1 withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        [self.navigationController pushViewController:col animated:YES];
    }
}

#pragma mark lazyLoad

-(UITableView*)tableview{
    
    if (_tableview == nil) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, winsize.width, winsize.height-64) style:UITableViewStylePlain];
        _tableview.showsVerticalScrollIndicator = NO;
        _tableview.backgroundColor = [UIColor clearColor];
        _tableview.separatorColor = RGB(240, 240, 240);
        _tableview.separatorInset = UIEdgeInsetsMake(0, 16, 0, 0);
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [UIView new];
    }
    return _tableview;
}

@end
