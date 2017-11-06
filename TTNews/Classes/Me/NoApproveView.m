//
//  NoApproveView.m
//  TTNews
//
//  Created by 薛立强 on 2017/11/5.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "NoApproveView.h"

@interface NoApproveView()

/** 未认证图标*/
@property (nonatomic, strong) UIImageView   * imgViewNoApprove;
/** 标题*/
@property (nonatomic, strong) UILabel       * labTitle;
/** 描述*/
@property (nonatomic, strong) UILabel       * labDescript;
/** 认证按钮*/
@property (nonatomic, strong) UIButton      * btnStartApprove;

@end

@implementation NoApproveView

-(instancetype)init{
    self = [super init];
    if (self) {
        [self setupviews];
        [self initSubviews];
    }
    return self;
}

-(void)initSubviews{
    
    [self.imgViewNoApprove setImage:ImageNamed(@"weiwancheng")];
    [self.labTitle setText:@"未提交认证!"];
    [self.labDescript setText:@"进行用户认证可获取更高权限"];
    [self.btnStartApprove setTitle:@"开始认证" forState: UIControlStateNormal];
}

-(void)setupviews{
    
    [self setBackgroundColor:RGB(240,240,240)];
    
    [self sd_addSubviews:@[self.imgViewNoApprove, self.labTitle, self.labDescript,self.btnStartApprove]];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
}

-(void)updateConstraintsIfNeeded{
    
    [super updateConstraintsIfNeeded];
    
    self.btnStartApprove.sd_layout
    .bottomSpaceToView(self, 200)
    .centerXEqualToView(self);
    [self.btnStartApprove setupAutoSizeWithHorizontalPadding:20 buttonHeight:50];
    
    self.labDescript.sd_layout
    .bottomSpaceToView(self.btnStartApprove, 20)
    .heightIs(25)
    .centerXEqualToView(self);
    [self.labDescript setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];
    
    self.labTitle.sd_layout
    .bottomSpaceToView(self.labDescript, 10)
    .heightIs(40)
    .centerXEqualToView(self);
    [self.labTitle setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];
    
    self.imgViewNoApprove.sd_layout
    .bottomSpaceToView(self.labTitle, 10)
    .heightIs(160)
    .widthIs(160)
    .centerXEqualToView(self);
}

-(void)btnApproveClick{
    if (self.block) {
        self.block();
    }
}

-(void)ApproveReturnBlock:(ApproveBtnClick)block{
    self.block = block;
}

#pragma mark lazyLoad
-(UIImageView *) imgViewNoApprove{
    
    if (_imgViewNoApprove == nil) {
        _imgViewNoApprove = [[UIImageView alloc]init];
        _imgViewNoApprove.contentMode = UIViewContentModeScaleAspectFit;
        _imgViewNoApprove.clipsToBounds = YES;
    }
    return _imgViewNoApprove;
}

-(UILabel *) labTitle{
    
    if (_labTitle == nil) {
        _labTitle = [[UILabel alloc]init];
        _labTitle.textColor =  [UIColor blackColor];
        _labTitle.font = [UIFont systemFontOfSize:22];
        _labTitle.contentMode = UIViewContentModeCenter;
    }
    return _labTitle;
}

-(UILabel *) labDescript{
    
    if (_labDescript == nil) {
        _labDescript = [[UILabel alloc]init];
        _labDescript.textColor =  [UIColor lightGrayColor];
        _labDescript.font = [UIFont systemFontOfSize:16];
        _labDescript.contentMode = UIViewContentModeCenter;
    }
    return _labDescript;
}

-(UIButton *) btnStartApprove{
    
    if (!_btnStartApprove) {
        _btnStartApprove = [UIButton buttonWithType:UIButtonTypeSystem];
        _btnStartApprove.layer.borderWidth = 1.0f;
        _btnStartApprove.layer.cornerRadius = 10;
        _btnStartApprove.clipsToBounds = YES;
        _btnStartApprove.layer.borderColor = navColor.CGColor;
        [_btnStartApprove setTitleColor:navColor forState:UIControlStateNormal];
        [_btnStartApprove.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [_btnStartApprove addTarget:self action:@selector(btnApproveClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnStartApprove;
}

@end
