//
//  ShoppingDetailController.m
//  TTNews
//
//  Created by 薛立强 on 2017/11/6.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//


#import "ShoppingDetailController.h"
#import "UIImageView+WebCache.h"
#import "UserPayController.h"

@interface ShoppingDetailController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labPrice;
//@property (weak, nonatomic) IBOutlet UITextView *textViewContent;
@property (nonatomic, strong) NSDictionary *modelList;
@property (weak, nonatomic) IBOutlet UIView *viewBack;

@end

@implementation ShoppingDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(MainColor,0x444444,MainColor);
    
    [self request];
    // Do any additional setup after loading the view from its nib.
}

//网络请求
-(void)request{
    NSMutableDictionary *prms = [@{
                                   @"id":_ID,
                                   }mutableCopy];
    weakSelf(ws)
    [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:KNetworkGetShoppingDetail withUserInfo:prms success:^(NSDictionary *message)
     {
         if ([message[@"status"] intValue] == 1) {
             _modelList = message[@"info"];
             [ws SetTextViewModel];
         }
         else
         {
             [SVProgressHUD showInfoWithStatus:@"暂无数据！"];
             [SVProgressHUD dismissWithDelay:2];
         }
     } failure:^(NSError *error) {
         
     } visibleHUD:NO];
}

-(void)SetTextViewModel{
    
    self.labTitle.text = _modelList[@"title"];
    self.labPrice.text = [NSString stringWithFormat:@"￥%@",_modelList[@"price"]];
    
    NSArray *imgs = [_modelList[@"albumsf"] componentsSeparatedByString:@","];
    
    TYAttributedLabel *label = [[TYAttributedLabel alloc]init];
    [self.scrollView addSubview:label];
    
    // 文字间隙
    label.characterSpacing = 2;
    // 文本行间隙
    label.linesSpacing = 6;
    
    NSString *text = _modelList[@"content"];
    [label appendText:text];
    
    for (int index = 0; index < imgs.count; index ++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://xinwen.52jszhai.com",imgs[index]]] placeholderImage:ImageNamed(@"tupianGL")];
        imageView.frame = CGRectMake(0, 10, SCREEN_WIDTH, SCREEN_WIDTH*0.3);
        [label appendView:imageView];
    }
    [label setFrameWithOrign:CGPointMake(5,0) Width:SCREEN_WIDTH-10];
    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, label.size.height+20)];
}

- (IBAction)btnPayClick:(UIButton *)sender {
    UserPayController *col = [UserPayController new];
    col.modelList = self.modelList;
    [self.navigationController pushViewController:col animated:YES];
}

@end
