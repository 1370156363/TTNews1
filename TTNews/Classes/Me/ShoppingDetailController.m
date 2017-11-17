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
        imageView.frame = CGRectMake(20, 10, SCREEN_WIDTH-20, SCREEN_WIDTH*0.3);
        [label appendView:imageView];
    }
    [label setFrameWithOrign:CGPointMake(0,0) Width:SCREEN_WIDTH];
    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, label.size.height+20)];
}

- (IBAction)btnPayClick:(UIButton *)sender {
    UserPayController *col = [UserPayController new];
    col.modelList = self.modelList;
    [self.navigationController pushViewController:col animated:YES];
}

@end
