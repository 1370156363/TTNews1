//
//  InputPanel.m
//  QQCar
//
//  Created by qqcy on 15/1/13.
//  Copyright (c) 2015年 yilong zhang. All rights reserved.
//

#import "InputPanel.h"

@implementation InputPanel

static InputPanel* g_instance = nil;

@synthesize m_Input;
@synthesize m_Commit;
@synthesize m_Title;
@synthesize m_IsShown;
@synthesize m_Src;
@synthesize m_Target;
@synthesize m_Sel;
@synthesize m_type;

@synthesize _CallBack;


- (void)dealloc
{
    self._CallBack = nil;
}

+ (InputPanel*)Inputpanel
{
    if (nil == g_instance)
    {
        g_instance = [[[NSBundle mainBundle] loadNibNamed:@"InputPanel" owner:self options:nil] objectAtIndex:0];
        g_instance.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, g_instance.frame.size.height);
        //g_instance.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height + g_instance.frame.size.height / 2);
        g_instance.m_Commit.layer.cornerRadius = 5;
        g_instance._CallBack = nil;
        [g_instance addTarget:g_instance Sel:@selector(OnCommitDown:)];
        
        g_instance.m_Input.delegate = g_instance;
        
        UIWindow* window = [[[UIApplication sharedApplication] windows] firstObject];
        [window addSubview:g_instance];
    }
    
    return g_instance;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if ([super initWithCoder:aDecoder])
    {
        [self resetListener];
        
        m_Target = nil;
        m_Sel    = nil;
        m_IsShown= NO;
        
        return self;
    }
    
    return nil;
}

- (void)setTitle:(NSString *)title TextField:(id)src
{
    m_Title.text = title;
    m_Src        = src;

    if ([src isKindOfClass:[UITextField class]])
    {
        UITextField* field = (UITextField*)src;
        
        m_Input.text         = field.text;
        m_Input.keyboardType = field.keyboardType;
        m_Input.returnKeyType = UIReturnKeyDone;//field.returnKeyType;
        m_Input.secureTextEntry = field.secureTextEntry;
        m_Input.delegate = self;
        m_type = field.tag;
    }

    [m_Input becomeFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(m_type == 200)
    {
        if(textField.text.length == 11)
        {
            if([string isEqualToString:@""])
            {
                return YES;
            }else{
                return NO;
            }
            
        }
    }
    return YES;
}

- (void)addTarget:(id)target Sel:(SEL)sel
{
    if (m_Target)
    {
        [m_Commit removeTarget:m_Target action:m_Sel forControlEvents:UIControlEventTouchUpInside];
    }
    
    m_Target = target;
    m_Sel    = sel;
    
    [m_Commit addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
}

- (void)resetListener
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillHidde:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardDidHidde:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardDidChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)cancelListener
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
}

- (void)KeyboardWillShow:(NSNotification *)notification
{
    if (m_Src && !m_IsShown)
    {
        NSDictionary *info = [notification userInfo];
        //NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
        CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        //CGSize keyboardSize = [value CGRectValue].size;
        //CGRect beginKeyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:duration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(didShown)];
        self.frame = CGRectMake(self.frame.origin.x, endKeyboardRect.origin.y - self.frame.size.height, self.frame.size.width, self.frame.size.height);
        [UIView commitAnimations];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self OnCommitDown:nil];
    
    return YES;
}

- (void)didShown
{
    m_IsShown = YES;
}

- (void)KeyboardDidShow:(NSNotification *)notification
{
    //m_IsShown = YES;
}

- (void)KeyboardWillHidde:(NSNotification *)notification
{
    if (m_Src)
    {
        m_Src = nil;
        
        NSDictionary *info = [notification userInfo];
        CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        
        [UIView beginAnimations:nil context:nil];
        g_instance.center = CGPointMake(g_instance.center.x, [[UIScreen mainScreen] bounds].size.height + g_instance.frame.size.height / 2);
        [UIView setAnimationDuration:duration];
        [UIView commitAnimations];
    }
}

- (void)KeyboardDidHidde:(NSNotification *)notification
{
    //m_Src        = nil;
    //m_Title.text = nil;
    //m_Input.text = nil;
    
    //[m_Commit removeTarget:m_Target action:m_Sel forControlEvents:UIControlEventTouchUpInside];
    
    //m_Target = nil;
    //m_Sel    = nil;

}

- (void)KeyboardWillChange:(NSNotification *)notification
{
    if (m_Src && m_IsShown)
    {
        NSDictionary *info = [notification userInfo];
        CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

        [UIView beginAnimations:nil context:nil];
        self.frame = CGRectMake(self.frame.origin.x, endKeyboardRect.origin.y - self.frame.size.height, self.frame.size.width, self.frame.size.height);
        [UIView setAnimationDuration:duration];
        [UIView commitAnimations];
    }
}

- (void)KeyboardDidChange:(NSNotification *)notification
{
}

- (void)OnCommitDown:(UIButton*)sender
{
    if ([m_Src isKindOfClass:[UITextField class]])
    {
        ((UITextField*)m_Src).text = m_Input.text;
    }
    
    if (self._CallBack) self._CallBack(self, 0);
    
    m_IsShown = NO;
    self._CallBack = nil;
    
    [m_Input resignFirstResponder];
}

- (void)hidde
{
    m_IsShown = NO;
    self._CallBack = nil;
    
    [m_Input resignFirstResponder];
}

- (void)setCallBack:(InputPanelCallback)callback
{
    self._CallBack = callback;
}

@end
