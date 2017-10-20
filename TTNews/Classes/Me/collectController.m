//
//  collectController.m
//  Aerospace
//
//  Created by 王迪 on 2017/2/22.
//  Copyright © 2017年 王迪. All rights reserved.
//

#import "collectController.h"
#import "SinglePictureNewsTableViewCell.h"


#define  Margion 5

@interface collectController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView     *m_Scrollview;
@property(nonatomic,strong)UITableView      *L_tableview;
@property(nonatomic,strong)UITableView      *C_tableview;
@property(nonatomic,strong)UITableView      *R_Tableview;
@property(nonatomic,strong)UIView           *line;
@end

@implementation collectController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.L_tableview.backgroundColor=[UIColor clearColor];
    self.C_tableview.backgroundColor=[UIColor clearColor];
    self.R_Tableview.backgroundColor=[UIColor clearColor];
    self.line.backgroundColor=RGB(240, 240, 240);
    self.title=@"收藏/历史";
    [self setupBasic];
}

#pragma mark 基本设置
- (void)setupBasic
{
    self.L_tableview.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    self.C_tableview.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    self.R_Tableview.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(0xfa5054,0x444444,0xfa5054);
}

-(IBAction)BtnSelect:(UIButton *)sender
{
    NSInteger tag=sender.tag/100-1;
    self.m_Scrollview.contentOffset=CGPointMake((winsize.width-2*Margion)*tag, 0);
    
    UIView *topView=[self.view viewWithTag:1000];
    CGFloat lineWidth=topView.frame.size.width/3;
    [self.line mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(tag*lineWidth);
    }];
    [UIView animateWithDuration:0.35 animations:^{
        [topView layoutIfNeeded];
    }];
    
    if (tag==2) {
        [self kg_hidden:NO];
    }
    else{
        [self kg_hidden:YES];
    }
}

-(UIView *)line
{
    if (!_line)
    {
        _line=[UIView new];
        UIView *topView=[self.view viewWithTag:1000];
        CGFloat lineWidth=topView.frame.size.width/3;
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
        _m_Scrollview.contentSize=CGSizeMake(winsize.width*3-6*Margion, 0);
        _m_Scrollview.pagingEnabled=YES;
        _m_Scrollview.delegate=self;
        _m_Scrollview.showsHorizontalScrollIndicator=NO;
    }
    return _m_Scrollview;
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
             make.left.equalTo(self.C_tableview.mas_right);
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

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = (NSInteger) (offsetX/(winsize.width-2*Margion));
    NSLog(@"-index=%zi",index);
    UIView *topView=[self.view viewWithTag:1000];
    CGFloat lineWidth=topView.frame.size.width/3;
    [self.line mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(index *lineWidth);
    }];
    [UIView animateWithDuration:0.35 animations:^{
        [topView layoutIfNeeded];
    }];
    if (index==2) {
        [self kg_hidden:NO];
    }
    else{
        [self kg_hidden:YES];
    }
}

@end
