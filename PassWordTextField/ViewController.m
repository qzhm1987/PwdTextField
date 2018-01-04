//
//  ViewController.m
//  PassWordTextField
//
//  Created by Mac on 2018/1/4.
//  Copyright © 2018年 BeiJingXiaoMenTong. All rights reserved.
//

#import "ViewController.h"
#import "UIView+category.h"


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//密码位数
static NSInteger const kDotsNumber = 5;

//假密码点点的宽和高  应该是等高等宽的正方形 方便设置为圆
static CGFloat const kDotWith_height = 10;


@interface ViewController ()<UITextFieldDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = UIColorFromRGB(0xF9F9F9);
    [self.view addSubview:self.pwdTF];
    [self addDotViews];
    
    // Do any additional setup after loading the view, typically from a nib.
}




-(void)addDotViews{
    //密码输入框的宽度
    CGFloat passwordFieldWidth = CGRectGetWidth(self.pwdTF.frame);
    //六等分 每等分的宽度
    CGFloat password_width = passwordFieldWidth / kDotsNumber;
    //密码输入框的高度
    CGFloat password_height = CGRectGetHeight(self.pwdTF.frame);
    for (int i = 0; i < kDotsNumber; i ++)
    {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(i * password_width, 0, 1, password_height)];
        line.backgroundColor = UIColorFromRGB(0xdddddd);
        [self.pwdTF addSubview:line];
        //假密码点的x坐标
        CGFloat dotViewX = (i + 1)*password_width - password_width / 2.0 - kDotWith_height / 2.0;
        CGFloat dotViewY = (password_height - kDotWith_height) / 2.0;
        UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(dotViewX, dotViewY, kDotWith_height, kDotWith_height)];
        dotView.backgroundColor = UIColorFromRGB(0x222222);
        
        [dotView setCornerRadius:kDotWith_height/2.0];
        dotView.hidden = YES;
        [self.pwdTF addSubview:dotView];
        [self.dotArray addObject:dotView];
    }
    
    
    
}

-(UITextField *)pwdTF{
    if (!_pwdTF) {
        _pwdTF = [[UITextField alloc]initWithFrame:CGRectMake(40, 200, kScreenWidth-80, 40)];
        _pwdTF.delegate = self;
        _pwdTF.backgroundColor = [UIColor whiteColor];
        _pwdTF.textColor = [UIColor clearColor];
        _pwdTF.tintColor = [UIColor clearColor];
        _pwdTF.keyboardType = UIKeyboardTypeNumberPad;
        _pwdTF.secureTextEntry = YES;
        [_pwdTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
    }
    return _pwdTF;
    
}

-(NSMutableArray *)dotArray{
    if (!_dotArray) {
        _dotArray  = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _dotArray;
}


-(void)textFieldDidChange:(UITextField *)textfield{
    
    NSLog(@"text = %@",textfield.text);
     [self setDotsViewHidden];
    for (int i = 0; i < self.pwdTF.text.length; i ++)
    {
        if (self.dotArray.count > i )
        {
            UIView *dotView = self.dotArray[i];
            [dotView setHidden:NO];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //删除键
    if (string.length == 0)
    {
        return YES;
    }
    
    if (self.pwdTF.text.length >= kDotsNumber)
    {
        return NO;
    }
    
    return YES;
}

//将所有的假密码点设置为隐藏状态
- (void)setDotsViewHidden
{
    for (UIView *view in self.dotArray)
    {
        [view setHidden:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
