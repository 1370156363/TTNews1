//
//  FocusCell.m
//  TTNews
//
//  Created by 西安云美 on 2017/7/26.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "FocusCell.h"

@interface FocusCell ()
{
    IBOutlet UIButton *img0;
    IBOutlet UIButton *img1;
    IBOutlet UIButton *img2;
    IBOutlet UIButton *img3;
    IBOutlet UILabel *txtLitle;
}
@end

@implementation FocusCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x343434, 0xfafafa);
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.contentView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x343434, 0xfafafa);
    txtLitle.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self==[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self=[[NSBundle mainBundle] loadNibNamed:@"FocusCell" owner:self options:nil][0];
    }
    return self;
}
@end
