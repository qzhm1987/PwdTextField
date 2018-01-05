//
//  ViewController.m
//  PassWordDemo
//
//  Created by Mac on 2018/1/4.
//  Copyright © 2018年 BeiJingXiaoMenTong. All rights reserved.
//

#import "ViewController.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define WIDTH 55 //密码输入框的宽度正方形
@interface ViewController ()<UITextFieldDelegate>



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 150, 50);
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    NSLog(@"height = %d",height);
}


-(void)btnClick {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.bgView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [_bgView addGestureRecognizer:tap];
    [self.bgView addSubview:self.inputView];
    [self.inputView addSubview:self.lineView];
    [self.inputView addSubview:self.label];
    [self.inputView addSubview:self.pwdTF];
    [self addDotViews];
    
    
    
    
    
    
    
    
}
-(void)tap:(UIGestureRecognizer *)tap{
    [_bgView removeFromSuperview];
    NSLog(@"移除");
    
    
}


-(void)addDotViews{
    _numArray = [[NSMutableArray alloc]initWithCapacity:5];
    for (NSInteger i = 0; i<5; i++) {
        UIView *line = [UIView new];
        line.frame = CGRectMake(WIDTH*i, 0, 1, WIDTH);
        line.backgroundColor = [UIColor lightGrayColor];
        [self.pwdTF addSubview:line];
        UILabel *label = [UILabel new];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [self.pwdTF.text substringWithRange:NSMakeRange(i, 1)];
        label.font = [UIFont boldSystemFontOfSize:30.0f];
        label.frame= CGRectMake(WIDTH*i, 0, WIDTH, WIDTH);
        [self.pwdTF addSubview:label];
        [_numArray addObject:label];
    }
    
}

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor colorWithRed:0.3f green:0.3f blue:0.3f alpha:0.3f];
        _bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    return _bgView;
}

-(UIView *)inputView{
    if (!_inputView) {
        _inputView  = [UIView new];
        _inputView.layer.cornerRadius = 5.0f;
        _inputView.backgroundColor = [UIColor whiteColor];
        _inputView.center = CGPointMake(SCREEN_WIDTH/2.0f, 300);
        _inputView.bounds = CGRectMake(0, 0, SCREEN_WIDTH-20, 180);
    }
    return _inputView;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor lightGrayColor];
        _lineView.frame = CGRectMake(10, 40, SCREEN_WIDTH-40, 1);
    }
    return _lineView;
}
-(UILabel *)label{
    if (!_label) {
        _label = [UILabel new];
        _label.text = @"密码设置";
        _label.frame = CGRectMake(0, 5, SCREEN_WIDTH-20, 30);
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

-(UITextField *)pwdTF{
    if (!_pwdTF) {
        _pwdTF = [[UITextField alloc]init];//WithFrame:CGRectMake(30, 80, 45*5, 45)];
        _pwdTF.bounds = CGRectMake(0, 0, WIDTH*5, WIDTH);
        _pwdTF.center = CGPointMake((SCREEN_WIDTH-20)/2.0f, 100);
        _pwdTF.delegate = self;
        _pwdTF.text = @"88888";
        _pwdTF.keyboardType  = UIKeyboardTypePhonePad;
        _pwdTF.backgroundColor = [UIColor whiteColor];
        _pwdTF.tintColor = [UIColor clearColor];
        _pwdTF.textColor  = [UIColor clearColor];
        _pwdTF.layer.borderWidth = 1.0f;
        _pwdTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_pwdTF addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _pwdTF;
}

-(void)textFieldChange:(UITextField *)textField{
    NSLog(@"text  = %@",textField.text);
    for (NSInteger a= 0; a<textField.text.length; a++) {
        UILabel *label =self.numArray[a];
        label.text = [textField.text substringWithRange:NSMakeRange(a, 1)];
    }
    //删除
    for (NSInteger i = 0; i<self.numArray.count-textField.text.length; i++) {
        UILabel *label = self.numArray[4-i];
        label.text = @"";
    }
    
    if (textField.text.length >4) {
        NSLog(@"网络请求设置密码");
    }
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //删除键
    if (string.length == 0)
    {
        return YES;
    }
    
    if (self.pwdTF.text.length >= 5)
    {
        return NO;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
