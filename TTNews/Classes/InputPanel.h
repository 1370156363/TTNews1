//
//  InputPanel.h
//  QQCar
//
//  Created by qqcy on 15/1/13.
//  Copyright (c) 2015年 yilong zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InputPanel;

typedef void(^InputPanelCallback)(InputPanel*, int code);

@interface InputPanel : UIView <UITextFieldDelegate>

@property(nonatomic, weak) IBOutlet UITextField*     m_Input;
@property(nonatomic, weak) IBOutlet UIButton*        m_Commit;
@property(nonatomic, weak) IBOutlet UILabel*         m_Title;
@property(nonatomic, assign)          BOOL             m_IsShown;
@property(nonatomic, assign)          id               m_Src;

@property(nonatomic, assign)          id               m_Target;
@property(nonatomic, assign)          SEL              m_Sel;
@property(nonatomic, assign) NSInteger m_type;

@property(nonatomic, copy)   InputPanelCallback        _CallBack;

+ (InputPanel*)Inputpanel;

- (void)setTitle:(NSString*)title TextField:(id)src;
- (void)addTarget:(id)target Sel:(SEL)sel;
- (void)cancelListener;
- (void)resetListener;
- (void)KeyboardWillShow:(NSNotification*)notification;
- (void)KeyboardDidShow:(NSNotification*)notification;
- (void)KeyboardWillHidde:(NSNotification*)notification;
- (void)KeyboardDidHidde:(NSNotification*)notification;
- (void)KeyboardWillChange:(NSNotification*)notification;
- (void)KeyboardDidChange:(NSNotification*)notification;
- (void)OnCommitDown:(UIButton*)sender;
- (void)hidde;

- (void)setCallBack:(InputPanelCallback)callback;

@end
