//
//  Created by mac on 16/10/18.
//  Copyright © 2016年 王迪. All rights reserved.
//

#import "UserDatePicker.h"

@interface UserDatePicker ()

@property(nonatomic, weak) IBOutlet UIDatePicker*          m_Picker;
@property(nonatomic, weak) IBOutlet UIButton*              m_Commit;
@property(nonatomic, weak) IBOutlet UILabel*               m_Title;
@property(nonatomic, strong)          UIView*              m_Shadow;
@property(nonatomic, strong)          UIView*              m_TapHiddenView;

- (IBAction)OnCommitDown:(UIButton*)sender;
- (void)showUserDatePicker;
- (void)hiddeUserDatePicker;

@end

@implementation UserDatePicker

static UserDatePicker* g_instance=nil;

@synthesize m_Commit;
@synthesize m_Picker;
@synthesize m_Title;
@synthesize m_Shadow;
@synthesize m_TapHiddenView;

- (IBAction)OnCommitDown:(UIButton*)sender
{
    [self hiddeUserDatePicker];
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString* date = [format stringFromDate:m_Picker.date];
    [format setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    NSString* udate = [format stringFromDate:m_Picker.date];
    if (self.UserDateBlock)
    {
        self.UserDateBlock(self,date,udate);
    }
}

+ (UserDatePicker*)UserDatePicker
{
    DismissKeyboard;
    if (!g_instance)
    {
        g_instance = [[[NSBundle mainBundle] loadNibNamed:@"UserDatePicker" owner:self options:nil] objectAtIndex:0];
        g_instance.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, g_instance.frame.size.height);
    
        g_instance.m_Commit.layer.cornerRadius = 3;
        g_instance.m_Picker.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
        g_instance.m_Picker.datePickerMode = UIDatePickerModeDate;
        g_instance.m_Shadow = nil;
        
        UIWindow* window = [[[UIApplication sharedApplication] windows] firstObject];
        
        g_instance.m_TapHiddenView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-192)];
        g_instance.m_TapHiddenView.alpha= 0.0;
        [g_instance.m_TapHiddenView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:g_instance action:@selector(hiddeUserDatePicker)]];
        
        g_instance.m_Shadow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        g_instance.m_Shadow.backgroundColor = [UIColor blackColor];
        g_instance.m_Shadow.alpha = 0.0;
        [window addSubview:g_instance.m_Shadow];
        [g_instance.m_Shadow addSubview:g_instance.m_TapHiddenView];
        [window addSubview:g_instance];
    }
    
    return g_instance;
}

- (void)setTitle:(NSString*)title
{
    m_Title.text = title;
    [self showUserDatePicker];
}

- (void)showUserDatePicker
{
    [UIView beginAnimations:nil context:nil];
    m_Shadow.alpha = 0.6;
    m_TapHiddenView.alpha=0.6;
    self.center = CGPointMake(self.center.x, [UIScreen mainScreen].bounds.size.height - self.frame.size.height / 2);
    [UIView commitAnimations];
}

- (void)hiddeUserDatePicker
{
    [UIView beginAnimations:nil context:nil];
    m_Shadow.alpha = 0.0;
    m_TapHiddenView.alpha=0.0;
    self.center = CGPointMake(self.center.x, [UIScreen mainScreen].bounds.size.height + self.frame.size.height / 2);
    [UIView commitAnimations];
}

@end
