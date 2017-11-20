//
//  SearchInfoViewController.m
//  TTNews
//
//  Created by mac on 2017/10/21.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "SearchInfoViewController.h"
#define  Margion 5
#import "SinglePictureNewsTableViewCell.h"


@interface SearchInfoViewController ()<UIScrollViewDelegate,UITextFieldDelegate>

//@property(nonatomic,strong)
@property (weak, nonatomic) IBOutlet UITextField *searchTextfield;


@property(nonatomic,strong)UIScrollView     *m_Scrollview;
@property(nonatomic,strong)UITableView      *L_tableview;
@property(nonatomic,strong)UITableView      *C_tableview;
@property(nonatomic,strong)UITableView      *M_Tableview;
@property(nonatomic,strong)UITableView      *R_Tableview;

@property(nonatomic,strong)UIView           *line;

@property (weak, nonatomic) IBOutlet UITextField *textView;

@end

@implementation SearchInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    self.searchTextfield.layer.cornerRadius=5;
    [self setupBasic];
    self.line.backgroundColor=navColor;
    self.textView.delegate=self;
    self.textView.returnKeyType=UIReturnKeyDone;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark 基本设置
- (void)setupBasic
{
    self.L_tableview.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafe);
    self.C_tableview.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafaa2);
    self.R_Tableview.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfaa3fa);
    self.M_Tableview.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);

//    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(0xfa5054,0x444444,0xfa5054);
}
///选择方法
- (IBAction)SelectAction:(UIButton *)sender {
//    sender.selected=!sender;

    NSInteger tag=sender.tag/100-1;
    self.m_Scrollview.contentOffset=CGPointMake((winsize.width-2*Margion)*tag, 0);

    UIView *topView=[self.view viewWithTag:2000];
    CGFloat lineWidth=topView.frame.size.width/4;
    [self.line mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(tag*lineWidth);
    }];
    [UIView animateWithDuration:0.35 animations:^{
        [topView layoutIfNeeded];
    }];

    if (tag==4) {
        [self kg_hidden:NO];
    }
    else{
        [self kg_hidden:YES];
    }

}

#pragma mark -懒加载
-(UIView *)line
{
    if (!_line)
    {
        _line=[UIView new];
        UIView *topView=[self.view viewWithTag:2000];
        CGFloat lineWidth=topView.frame.size.width/4;
        [topView addSubview:_line];
        [_line mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.width.mas_equalTo(lineWidth);
             make.left.equalTo(topView);
             make.height.mas_equalTo(2);
             make.bottom.equalTo(topView);
         }];
    }
    return _line;
}

-(UIScrollView *)m_Scrollview
{
    if (!_m_Scrollview)
    {
        _m_Scrollview=[[UIScrollView alloc] init];
        [self.view addSubview:_m_Scrollview];
        [_m_Scrollview mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(self.view).offset(114);
             make.left.equalTo(self.view).offset(Margion);
             make.right.equalTo(self.view).offset(-Margion);
             make.bottom.equalTo(self.view.mas_bottom);
         }];
        _m_Scrollview.contentSize=CGSizeMake(winsize.width*4-8*Margion, 0);
        _m_Scrollview.pagingEnabled=YES;
        _m_Scrollview.delegate=self;
        _m_Scrollview.showsHorizontalScrollIndicator=NO;
    }
    return _m_Scrollview;
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = (NSInteger) (offsetX/(winsize.width-2*Margion));
    NSLog(@"-index=%zi",index);
    UIView *topView=[self.view viewWithTag:2000];
    CGFloat lineWidth=topView.frame.size.width/4;
    [self.line mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(index *lineWidth);
    }];
    [UIView animateWithDuration:0.35 animations:^{
        [topView layoutIfNeeded];
    }];
    if (index==3) {
        [self kg_hidden:NO];
    }
    else{
        [self kg_hidden:YES];
    }
}


-(UITableView *)L_tableview
{
    if (!_L_tableview)
    {
        _L_tableview=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [self.m_Scrollview addSubview:_L_tableview];
        _L_tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_L_tableview mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.height.width.equalTo(self.m_Scrollview);
             make.left.mas_equalTo(0);
         }];

        [_L_tableview cb_makeDataSource:^(CBTableViewDataSourceMaker *make) {
            [make makeSection:^(CBTableViewSectionMaker *section) {
                section.cell([SinglePictureNewsTableViewCell class])
                .data(@[@{}])
                .adapter(^(SinglePictureNewsTableViewCell * cell,NSDictionary * data,NSUInteger index)
                         {

                         })
                .autoHeight();
            }];
        }];
        [_L_tableview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBoard)]];
    }
    return _L_tableview;
}

-(void)hiddenKeyBoard
{
    DismissKeyboard;
}

-(UITableView *)C_tableview
{
    if (!_C_tableview)
    {
        _C_tableview=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [self.m_Scrollview addSubview:_C_tableview];
        _C_tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_C_tableview mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.height.width.equalTo(self.m_Scrollview);
             make.left.equalTo(self.L_tableview.mas_right);
         }];
        [_C_tableview cb_makeDataSource:^(CBTableViewDataSourceMaker *make) {
            [make makeSection:^(CBTableViewSectionMaker *section) {
                section.cell([SinglePictureNewsTableViewCell class])
                .data(@[@{}])
                .adapter(^(SinglePictureNewsTableViewCell * cell,NSDictionary * data,NSUInteger index)
                         {

                         })
                .autoHeight();
            }];
        }];
    }
    return _C_tableview;
}

-(UITableView *)M_Tableview
{
    if (!_M_Tableview)
    {
        _M_Tableview=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [self.m_Scrollview addSubview:_M_Tableview];
        _M_Tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_M_Tableview mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.height.width.equalTo(self.m_Scrollview);
             make.left.equalTo(self.C_tableview.mas_right);
         }];
        [_M_Tableview cb_makeDataSource:^(CBTableViewDataSourceMaker *make) {
            [make makeSection:^(CBTableViewSectionMaker *section) {
                section.cell([SinglePictureNewsTableViewCell class])
                .data(@[@{}])
                .adapter(^(SinglePictureNewsTableViewCell * cell,NSDictionary * data,NSUInteger index)
                         {

                         })
                .autoHeight();
            }];
        }];
    }

    return _R_Tableview;
}

-(UITableView *)R_Tableview
{
    if (!_R_Tableview)
    {
        _R_Tableview=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [self.m_Scrollview addSubview:_R_Tableview];
        _R_Tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_R_Tableview mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.height.width.equalTo(self.m_Scrollview);
             make.left.equalTo(self.M_Tableview.mas_right);
         }];
        [_R_Tableview cb_makeDataSource:^(CBTableViewDataSourceMaker *make) {
            [make makeSection:^(CBTableViewSectionMaker *section) {
                section.cell([SinglePictureNewsTableViewCell class])
                .data(@[@{}])
                .adapter(^(SinglePictureNewsTableViewCell * cell,NSDictionary * data,NSUInteger index)
                         {

                         })
                .autoHeight();
            }];
        }];
    }

    return _R_Tableview;
}
#pragma mark -搜索

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

///确定搜索按钮
- (IBAction)okAction:(UIButton *)sender {
    [self SendMessage];
}

///发功消息事件
-(void)SendMessage{

    if (self.textView.text.length==0) {
        return;
    }
    NSMutableDictionary * dict=[[NSMutableDictionary alloc] initWithObjectsAndKeys:self.textView.text,@"keyword", nil];

    [[KGNetworkManager sharedInstance] invokeNetWorkAPIWith:KNetworkSearch withUserInfo:dict success:^(id message) {
        [SVProgressHUD dismiss];

//        [self getCommet];
        self.textView.text=@"";
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    } visibleHUD:NO];
}

@end
