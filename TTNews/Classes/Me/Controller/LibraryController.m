//
//  LibraryController.m
//  TTNews
//
//  Created by 西安云美 on 2017/7/26.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "LibraryController.h"
#import "home1CollectionViewCell.h"
#import "LSYReadPageViewController.h"

@interface LibraryController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *mainCollectionView;
    NSMutableArray *arrayList;
}
@end

@implementation LibraryController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"图书馆";
    arrayList = [[NSMutableArray alloc] init];
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, winsize.width, self.view.frame.size.height) collectionViewLayout:layout];
//    [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:KThirdJHNetworkGetBook withUserInfo:nil success:^(id message) {
//        
//        if([message[@"resultcode"] intValue] == 200){
//            [arrayList addObjectsFromArray:message[@"result"]];
//        }
//        else{
//            [SVProgressHUD showInfoWithStatus:@"接口错误"];
//        }
//            
//    } failure:^(NSError *error) {
//        
//    } visibleHUD:NO];
    //4.设置代理
    mainCollectionView.delegate = self;
    mainCollectionView.dataSource = self;
    mainCollectionView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:mainCollectionView];

    [mainCollectionView registerNib:[UINib nibWithNibName:@"home1CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cellId"];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

//item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    home1CollectionViewCell *cell = (home1CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    return cell;
}

//定义没个Cell大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize siz=CGSizeMake(winsize.width/2-20, 200);
    return siz;
}

//定义每个Section 的margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //return UIEdgeInsetsMake(2,34/BoundWidth*100,2, 34/BoundWidth*100);//分别为上、左、下、右
    return UIEdgeInsetsMake(2,4,2,4);
}

//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LSYReadPageViewController *pageView = [[LSYReadPageViewController alloc] init];
    
    //pageView.resourceURL =[NSURL URLWithString:@"http://123.56.151.112/taojin/liangzishihua.txt"];
    
    
    NSURL *fileURL = [NSURL fileURLWithPath:@"http://123.56.151.112/taojin/liangzishihua.txt"];
    
    pageView.resourceURL = fileURL;    //文件位置
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        pageView.model = [LSYReadModel getLocalModelWithURL:fileURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self presentViewController:pageView animated:YES completion:nil];
        });
    });
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//
//        pageView.model = [LSYReadModel getLocalModelWithURL:pageView.resourceURL];
//
//        dispatch_async(dispatch_get_main_queue(), ^
//                       {
//                           [self presentViewController:pageView animated:YES completion:nil];
//                           //[self.navigationController pushViewController:pageView animated:YES];
//                       });
//    });

}

@end
