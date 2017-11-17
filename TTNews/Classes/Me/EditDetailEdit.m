//
//  EditDetailEdit.m
//  Upeer
//
//  Created by Mac on 2016/12/19.
//  Copyright © 2016年 www.kc.com. All rights reserved.
//
#define LeftViewWidth 70
#define  NICKNAMELENGTH 300

#import "EditDetailEdit.h"

@interface EditDetailEdit ()<UITextViewDelegate>

@property(nonatomic,assign) BOOL isNickNameLabel;//昵称做长度限制

@end

@implementation EditDetailEdit
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupviews];
    }
    return self;
}
-(void)setupviews{
    
    UILabel *labelName = [[UILabel alloc]init];
    UITextView*labelDetail = [[UITextView alloc]init];
    UIView* lineView = [[ UIView alloc]init];
    UILabel *labelPlacehold = [[UILabel alloc]init];
    _lineView = lineView;
    _labelName = labelName;
    _labelDetail = labelDetail;
    _labPlacehold = labelPlacehold;
    
    [lineView setBackgroundColor:RGB(200, 200, 200)];
    
    [labelName setTextAlignment:NSTextAlignmentLeft];
    [labelName setTextColor:[UIColor blackColor]];
    [labelName setFont:[UIFont systemFontOfSize:16]];
    
    [labelPlacehold setTextAlignment:NSTextAlignmentLeft];
    [labelPlacehold setTextColor:[UIColor lightGrayColor]];
    [labelPlacehold setFont:[UIFont systemFontOfSize:16]];
    
    labelDetail.delegate = self;       //设置代理方法的实现类
    labelDetail.editable = YES;        //是否允许编辑内容，默认为“YES”
    labelDetail.font=[UIFont systemFontOfSize:16]; //设置字体名字和字体大小;
    labelDetail.returnKeyType = UIReturnKeyDefault;//return键的类型
    labelDetail.keyboardType = UIKeyboardTypeDefault;//键盘类型
    labelDetail.textAlignment = NSTextAlignmentLeft; //文本显示的位置默认为居左
    labelDetail.textColor = [UIColor blackColor];
    
    [self.contentView sd_addSubviews:@[_lineView,_labelName,_labelDetail,_labPlacehold]];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

-(void)updateConstraints{
    [super updateConstraints];
    
    self.labelName.sd_layout
    .leftSpaceToView(self.contentView, 5)
    .topSpaceToView(self.contentView, 5)
    .heightIs(30)
    .widthIs(100);
    
    self.labelDetail.sd_layout
    .leftSpaceToView(self.labelName, 5)
    .topSpaceToView(self.contentView, 5)
    .rightSpaceToView(self.contentView, 5)
    .bottomSpaceToView(self.contentView, 10);
    
    self.labPlacehold.sd_layout
    .leftSpaceToView(self.labelName, 10)
    .topSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 5)
    .autoHeightRatio(0);
    
    self.lineView.sd_layout
    .leftSpaceToView(self.contentView, 5)
    .rightSpaceToView(self.contentView, 5)
    .heightIs(1)
    .bottomSpaceToView(self.contentView, 2);
    
    [self setupAutoHeightWithBottomViewsArray:@[self.labPlacehold] bottomMargin:10];
    
}

-(void)setModel:(KGTableviewCellModel *)model{
    _model = model;
    self.labelName.text = model.title;
    self.labPlacehold.text = model.detail;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        //判断输入的字是否是回车，即按下return,默认当什么都不输入时直接返回
        if (textView.text.length == 0) {
            [self.labPlacehold setHidden:NO];
        }
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    NSString *tem = [[text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![text isEqualToString:tem]) {
        return NO;
    }
    
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    [self.labPlacehold setHidden:YES];
    NSString *toBeString = textView.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > NICKNAMELENGTH) {
                textView.text = [toBeString substringToIndex:NICKNAMELENGTH];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > NICKNAMELENGTH) {
            textView.text = [toBeString substringToIndex:NICKNAMELENGTH];
        }
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        [self.labPlacehold setHidden:NO];
    }
}

@end
