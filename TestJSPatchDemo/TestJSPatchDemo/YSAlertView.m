//
//  YSAlertView.m
//  PodTest
//
//  Created by occ on 15/9/14.
//  Copyright (c) 2015年 occ. All rights reserved.
//

#import "YSAlertView.h"


#define kFFEasyLifeAlertHeight GetScaleWidth(150)

#define kFFEasyLifeAlertWidth GetScaleWidth(315)

//#define k_UIColorFromRGB(rgbValue)\
//\
//[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
//green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
//blue:((float)(rgbValue & 0xFF))/255.0 \
//alpha:1.0]

//static int const kFFEasyLifeAlertColor  =  0Xff6b13;



@implementation YSAlertView {
    NSString *_title;
    NSString *_message;
    NSString *_cancel;
    NSString *_sure;
    
    UIView *_chunkView;
    UILabel *_messageLab;
    
    UIButton *_cancelButton;
    UIButton *_sureButton;
}


+ (YSAlertView *)sharedInstance
{
    
    static YSAlertView *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<YSAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    if (self == nil) {
        self = [[YSAlertView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
    }
    self.needDismiss = YES;
    self.isUpdate = NO;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _title = title;
    _message = message;
    _cancel = cancelButtonTitle;
    _sure = otherButtonTitles;
    _delegate = delegate;
    
    [self initView];
    return self;
}

- (void)initTitle:(NSString *)title message:(NSString *)message delegate:(id /*<YSAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    
    self.needDismiss = YES;
    self.isUpdate = NO;
    
    if (self != nil) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    }
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _title = title;
    _message = message;
    _cancel = cancelButtonTitle;
    _sure = otherButtonTitles;
    _delegate = delegate;
    
    [self initView];
}

-(void)initView {
    
    if (!_chunkView) {
        
        _chunkView = [[UIView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - kFFEasyLifeAlertWidth) / 2.0, ([UIScreen mainScreen].bounds.size.height - kFFEasyLifeAlertHeight) / 2.0, kFFEasyLifeAlertWidth, kFFEasyLifeAlertHeight)];
        _chunkView.backgroundColor = [UIColor whiteColor];
        _chunkView.layer.cornerRadius = 10;
        _chunkView.layer.masksToBounds = YES;
        [self addSubview:_chunkView];
        
        _messageLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kFFEasyLifeAlertWidth - 30, kFFEasyLifeAlertHeight - 44)];
        _messageLab.textAlignment = NSTextAlignmentCenter;
        _messageLab.numberOfLines = 0;
        _messageLab.font = [UIFont systemFontOfSize:18];
        _messageLab.textColor = k_UIColorFromRGB(0X333333);
        [_chunkView addSubview:_messageLab];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kFFEasyLifeAlertHeight - 44, kFFEasyLifeAlertWidth, 0.5)];
        lineView.backgroundColor = k_UIColorFromRGB(0Xe6e8eb);
        [_chunkView addSubview:lineView];
        
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _cancelButton.frame = CGRectMake(0, kFFEasyLifeAlertHeight - 44, kFFEasyLifeAlertWidth / 2.0, 44);
        [_cancelButton setTitleColor:k_UIColorFromRGB(0X333333) forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(actionCancel) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.userInteractionEnabled = NO;
        [_chunkView addSubview:_cancelButton];
        
        
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureButton setTitle:_sure forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _sureButton.frame = CGRectMake(kFFEasyLifeAlertWidth / 2.0, kFFEasyLifeAlertHeight - 44, kFFEasyLifeAlertWidth / 2.0, 44);
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureButton.backgroundColor = k_UIColorFromRGB(0XFF5E00);
        [_sureButton addTarget:self action:@selector(actionSure) forControlEvents:UIControlEventTouchUpInside];
        _sureButton.userInteractionEnabled = NO;
        [_chunkView addSubview:_sureButton];
    }
    
    _messageLab.text = [NSString stringWithFormat:@"%@",_message];
    [_cancelButton setTitle:_cancel forState:UIControlStateNormal];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _sureButton.userInteractionEnabled = YES;
        _cancelButton.userInteractionEnabled = YES;
    });
    
    CAKeyframeAnimation *animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    animation.delegate = self;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
    
    [_chunkView.layer addAnimation:animation forKey:nil];
}

#pragma mark -
#pragma mark - action
-(void)actionCancel {
    if ([_delegate respondsToSelector:@selector(alertYSView:clickedButtonAtIndex:)]) {
        [_delegate alertYSView:self clickedButtonAtIndex:0];
    }
    
    if (!self.isUpdate) {
        [self dismissAnimated:YES];
    }
}

-(void)actionSure {
    if ([_delegate respondsToSelector:@selector(alertYSView:clickedButtonAtIndex:)]) {
        [_delegate alertYSView:self clickedButtonAtIndex:1];
    }
    [self dismissAnimated:YES];
}


- (void)show:(UIView *)superView {
    
    [superView addSubview:self];
    [superView bringSubviewToFront:self];
    
}
- (void)dismissAnimated:(BOOL)animated {
    [self removeFromSuperview];
}

@end
