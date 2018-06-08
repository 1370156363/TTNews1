//
//  AddMessageView.m
//  QuestionEveryday
//
//  Created by 薛立强 on 2017/6/20.
//  Copyright © 2017年 薛立强. All rights reserved.
//

#import "AddMessageView.h"

#define ADDTITLESTR @"标题不超过20个字"
#define ADDMESSAGESTR @"内容不超过200个字"

/** 定义内容文字最大长度*/
#define CONTENTTLENGTH 200
#define TITLELENGTH 20

@interface AddMessageView()<PYPhotosViewDelegate,UITextViewDelegate>
///发布动态时不显示标题，发布问题显示
@property (nonatomic, assign) BOOL isShowTitleView;

@end

@implementation AddMessageView


-(instancetype)initWithState:(BOOL)state{
    self = [self init];
    if (self) {
        _isShowTitleView = state;
        [self setupViews];
    }
    return self;
}

-(void)setupViews
{
    [self setBackgroundColor:[UIColor whiteColor]];
//    // 1. 常见一个发布图片时的photosView
//    PYPhotosView *publishPhotosView = [PYPhotosView photosView];
//    // 2. 添加本地图片
//    NSMutableArray *imagesM = [[NSMutableArray alloc] initWithArray:_selectedPhotos];
//    publishPhotosView.photoWidth = (SCREEN_WIDTH-40)/3;
//    publishPhotosView.photoHeight = (SCREEN_WIDTH-40)/3;
//    publishPhotosView.photoMargin = 10;
////    publishPhotosView.imagesMaxCountWhenWillCompose = 3;
//    // 2.1 设置本地图片
//    publishPhotosView.images = imagesM;
//    // 3. 设置代理
//    publishPhotosView.delegate = self;
//    self.publishPhotosView = publishPhotosView;
//    // 4. 添加photosView
    //self.textTitleView
    if(!_isShowTitleView){
        [self sd_addSubviews:@[self.textContentView]];
    }
    else{
        [self sd_addSubviews:@[self.textContentView,self.textTitleView]];
    }
//
//    //    添加监听方法
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewEditChanged:) name:UITextViewTextDidChangeNotification object:nil];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
}

-(void)updateConstraints
{
    [super updateConstraints];
    
    self.textTitleView.sd_layout
    .leftSpaceToView(self, 5)
    .rightSpaceToView(self, 5)
    .topSpaceToView(self, 30)
    .heightIs(30);
    self.textContentView.sd_layout
    .leftSpaceToView(self, 5)
    .rightSpaceToView(self, 5)
    .topSpaceToView(self.textTitleView, 20)
    .heightIs(200);
    
//    self.publishPhotosView.sd_layout
//    .topSpaceToView(self.textContentView, 5)
//    .leftSpaceToView(self, 5);
    
}


//-(void)returnAddMorePhotoBlock:(addMorePhotoBlock)block
//{
//    self.block = block;
//}
//#pragma mark - PYPhotosViewDelegate
//- (void)photosView:(PYPhotosView *)photosView didAddImageClickedWithImages:(NSMutableArray *)images
//{
//    NSLog(@"点击了添加图片按钮 --- 添加前有%zd张图片", images.count);
//    if (self.block) {
//        self.block();
//    }
//}

-(void)dealloc
{
    //移除指定的通知，不然会造成内存泄露
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark TextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    //编辑时删除代替placeholder效果的内容
    if ([textView.text isEqualToString:ADDMESSAGESTR] || [textView.text isEqualToString:ADDTITLESTR]) {
        textView.text = @"";
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineSpacing = 8;
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:[UIColor whiteColor]};
        textView.attributedText = [[NSAttributedString alloc]initWithString:textView.text attributes:attributes];
    }
    
    return YES;
}

-(void)textViewEditChanged:(NSNotification *)obj{
    UITextView *textView = (UITextView *)obj.object;
    
    NSString *toBeString = textView.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            
            if (textView.tag ==100 && toBeString.length > CONTENTTLENGTH) {
                textView.text = [toBeString substringToIndex:CONTENTTLENGTH];
            }
            else if (textView.tag ==200 && toBeString.length > TITLELENGTH) {
                textView.text = [toBeString substringToIndex:TITLELENGTH];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (textView.tag ==100 && toBeString.length > CONTENTTLENGTH) {
            textView.text = [toBeString substringToIndex:CONTENTTLENGTH];
        }
        else if (textView.tag ==200 && toBeString.length > TITLELENGTH) {
            textView.text = [toBeString substringToIndex:TITLELENGTH];
        }
    }
    if (textView.tag ==100 && toBeString.length > CONTENTTLENGTH) {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        [SVProgressHUD showWithStatus:@"内容最多只能输入200个字!请您合理安排内容!"];
        [SVProgressHUD dismissWithDelay:2];
    }
    else if (textView.tag ==200 && toBeString.length > TITLELENGTH) {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        [SVProgressHUD showWithStatus:@"标题最多只能输入20个字!请您合理安排内容!"];
        [SVProgressHUD dismissWithDelay:2];
    }
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    //若编辑结束，内容为空，变最开始placeholder效果
    if ([textView.text isEqualToString:@""]) {
        if (textView.tag == 100) {
            self.textContentView.text = ADDMESSAGESTR;
        }
        else if(textView.tag == 200) {
            self.textContentView.text = ADDTITLESTR;
        }
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineSpacing = 8;
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:[UIColor grayColor]};
        self.textContentView.attributedText = [[NSAttributedString alloc]initWithString:self.textContentView.text attributes:attributes];
    }
}

- (BOOL) textView: (UITextView *) textView  shouldChangeTextInRange: (NSRange) range replacementText: (NSString *)text {
    if( [ @"\n" isEqualToString: text]){
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        return NO;
    }
    return YES;
}

//#pragma mark 获取当前视图控制器
//- (UIViewController*)getCurrentViewController{
//    UIResponder *next = [self nextResponder];
//    do {
//        if ([next isKindOfClass:[UIViewController class]]) {
//            return (UIViewController *)next;
//        }
//        next = [next nextResponder];
//    } while (next != nil);
//    return nil;
//}
//

#pragma mark lazyLoad
-(UITextView*)textContentView
{
    if (!_textContentView) {
        _textContentView = [[UITextView alloc]init];
        _textContentView.delegate = self;
        _textContentView.text = ADDMESSAGESTR;
        _textContentView.layer.cornerRadius = 10;
        _textContentView.layer.borderWidth = 0.5;
        _textContentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _textContentView.backgroundColor = [UIColor whiteColor];
        _textContentView.tag = 100;
        //有内容时该设置才生效，需要切记
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineSpacing = 8;
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:[UIColor grayColor]};
        _textContentView.attributedText = [[NSAttributedString alloc]initWithString:_textContentView.text attributes:attributes];
        _textContentView.returnKeyType = UIReturnKeyDone;
    }
    return _textContentView;
}

-(UITextView*)textTitleView{
    if (!_textTitleView) {
        _textTitleView = [[UITextView alloc]init];
        _textTitleView.delegate = self;
        _textTitleView.text = ADDTITLESTR;
        _textTitleView.tag = 200;
        _textTitleView.layer.cornerRadius = 5;
        _textTitleView.layer.borderWidth = 0.5;
        _textTitleView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _textTitleView.backgroundColor = [UIColor whiteColor];
        //有内容时该设置才生效，需要切记
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineSpacing = 8;
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:[UIColor grayColor]};
        _textTitleView.attributedText = [[NSAttributedString alloc]initWithString:_textTitleView.text attributes:attributes];
        _textTitleView.returnKeyType = UIReturnKeyDone;
    }
    return _textTitleView;
}

@end
