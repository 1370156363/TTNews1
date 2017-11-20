//
//  OperationController.m
//  TTNews
//
//  Created by 薛立强 on 2017/11/10.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "OperationController.h"
#import "KGTableviewCellModel.h"
#import "EditDetailEdit.h"
#import "ImageTableCell.h"
#import "PhoneVerifyController.h"

@interface OperationController (){
    ///证件号
    NSString * IDNumber;
    ///姓名
    NSString * realName;
    ///证件照
    int        identificationPhotoID;
    ///电话
    NSString * phoneNumber;
    ///邮箱
    NSString * email;
    ///运营所在地
    NSString * address;
    ///其他联系方式
    NSString * otherContact;
    ///媒体材料
    NSString * mediaMaterial;
    ///材料证明
    int        materialCertifyID;
    
}
@property (nonatomic, strong) NSMutableArray <KGTableviewCellModel*> *arrayDataItems;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) UIView *footView;

@end

@implementation OperationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrayDataItems = [NSMutableArray new];
    self.tableview.tableFooterView = self.footView;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableview wh_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        DismissKeyboard;
    }];
    [self.tableview registerNib:[UINib nibWithNibName:@"ImageTableCell" bundle:nil] forCellReuseIdentifier:@"ImageTableCellIdentify"];
    [self.tableview registerClass:[EditDetailEdit class] forCellReuseIdentifier:@"EditDetailEditIdentify"];
    [self loadData];
    // Do any additional setup after loading the view from its nib.
}

///刷新
-(void)loadData
{
    KGTableviewCellModel *model=[[KGTableviewCellModel alloc] init];
    model.title=@"姓名";
    model.detail=@"请输入姓名";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"证件号";
    model.detail=@"请输入证件号";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"证件照";
    model.detail=@"参考示例提供手持身份证正面照片，要求所有信息清晰可见，并于运营者信息一致";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"联系电话";
    model.detail=@"请输入联系电话";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"联系邮箱";
    model.detail=@"请输入联系邮箱";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"运营所在地";
    model.detail=@"请输入运营所在地";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"其他联系方式";
    model.detail=@"请输入其他联系方式";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"媒体资料";
    model.detail=@"提供本人专栏或其他媒体平台上的主页链接URL，所提供的链接将作为我们审核的重要依据";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"材料证明";
    model.detail=@"请提供图片形式的证明（如您的专栏、微博微信公众号的后台管理页面），这有助于我们为您规避潜在恶意冒充风险。";
    [self.arrayDataItems addObject:model];
    
    [self.tableview reloadData];
}


#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayDataItems.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2 || indexPath.row == 8) {
        
        ImageTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageTableCellIdentify" forIndexPath:indexPath];
        cell.labTitleName.text =self.arrayDataItems[indexPath.row].title;
        cell.labDetailText.text =self.arrayDataItems[indexPath.row].detail;
        if (indexPath.row == 2) {
            [cell.imgPhoto setImage:ImageNamed(@"tupianGL")];
        }
        else
            [cell.imgPhoto setImage:ImageNamed(@"tupianGL")];
        return cell;
        
    }
    else{
        EditDetailEdit *cell = [tableView dequeueReusableCellWithIdentifier:@"EditDetailEditIdentify" forIndexPath:indexPath];
        cell.model =self.arrayDataItems[indexPath.row];
        return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    if (row ==2 || row == 8) {
        return 120;
    }
    else if(row == 7){
        return 100;
    }
    return 50;
}
-(void)btnNextClick{
    if ([self checkInput]) {
        [self updateRequestModel];
        NSDictionary * dic =@{
                                 @"zhengjianhao":IDNumber,
                                 @"zhengjianphoto":@(identificationPhotoID),
                                 @"mobile":phoneNumber,
                                 @"email":email,
                                 @"address":address,
                                 @"cailiao":mediaMaterial,
                                 @"cailiaophoto":@(materialCertifyID),
                                 @"nickname":realName,
                                 };
        [self.prms addEntriesFromDictionary:dic];
        PhoneVerifyController *col = [PhoneVerifyController new];
        col.prms = self.prms;
        [self.navigationController pushViewController:col animated:YES];
    }
}
    
-(void) updateRequestModel{
    EditDetailEdit *cell;
    ImageTableCell *cellImg;
    for (int index = 0; index < self.arrayDataItems.count; index++) {
        if (index != 2 && index != 8) {
            cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            if(index == 0){
                realName = cell.labelDetail.text;
            }
            else if(index == 1){
                IDNumber = cell.labelDetail.text;
            }
            else if(index == 3){
                phoneNumber = cell.labelDetail.text;
            }
            else if(index == 4){
                email = cell.labelDetail.text;
            }
            else if(index == 5){
                address = cell.labelDetail.text;
            }
            else if(index == 6){
                otherContact = cell.labelDetail.text;
            }
            else if(index == 7){
                mediaMaterial = cell.labelDetail.text;
            }
        }
        else{
            cellImg = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            if(index == 2){
                identificationPhotoID = cellImg.aproveImgId;
            }
            else if(index == 8){
                materialCertifyID = cellImg.aproveImgId;
            }
        }
    }
}

-(BOOL)checkInput{
    
    EditDetailEdit *cell;
    ImageTableCell *cellImg;
    for (int index = 0; index < self.arrayDataItems.count; index++) {
        if (index != 2 && index != 8) {
            cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            if (cell.labelDetail.text.length == 0) {
                NSString *str =[NSString stringWithFormat:@"请输入%@",((KGTableviewCellModel*)(self.arrayDataItems[index])).title];
                [SVProgressHUD showInfoWithStatus:str];
                [SVProgressHUD dismissWithDelay:2.0];
                return false;
            }
        }
        else{
            cellImg = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            if (cellImg.aproveImgId == 0) {
                NSString *str =[NSString stringWithFormat:@"请上传%@",((KGTableviewCellModel*)(self.arrayDataItems[index])).title];
                [SVProgressHUD showInfoWithStatus:str];
                [SVProgressHUD dismissWithDelay:2.0];
            }
        }
    }
    
    return true;
}

-(UIView*)footView{
    if (_footView == nil) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        UIButton *btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnNext setTitle:@"下一步" forState:UIControlStateNormal];
        btnNext.frame = _footView.frame;
        [btnNext setBackgroundColor:navColor];
        [btnNext.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [btnNext addTarget:self action:@selector(btnNextClick) forControlEvents:UIControlEventTouchUpInside];
        [btnNext.titleLabel setTextColor:[UIColor whiteColor]];
        [_footView addSubview:btnNext];
    }
    return _footView;
}


@end
