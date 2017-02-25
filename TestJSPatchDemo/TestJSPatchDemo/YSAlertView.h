//
//  YSAlertView.h
//  PodTest
//
//  Created by occ on 15/9/14.
//  Copyright (c) 2015年 occ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YSAlertViewDelegate;

@interface YSAlertView : UIControl<CAAnimationDelegate>

+ (YSAlertView *)sharedInstance;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<YSAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... ;

- (void)initTitle:(NSString *)title message:(NSString *)message delegate:(id /*<YSAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

@property (nonatomic,assign) id <YSAlertViewDelegate> delegate;
@property (nonatomic,assign) BOOL isUpdate;
@property (nonatomic,assign) BOOL needDismiss;
- (void)show:(UIView *)superView ;
- (void)dismissAnimated:(BOOL)animated;

@end

@protocol YSAlertViewDelegate <NSObject>

- (void)alertYSView:(YSAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;


@end
