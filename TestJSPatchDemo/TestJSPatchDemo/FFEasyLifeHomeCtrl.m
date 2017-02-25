//
//  ViewController.m
//  TestJSPatchDemo
//
//  Created by occ on 2017/2/8.
//  Copyright © 2017年 occ. All rights reserved.
//

#import "FFEasyLifeHomeCtrl.h"
//#import "FFEasyLifePictureCtrl.h"


#import "YSAlertView.h"

#import "FFTestObject.h"
#import "FFTestDeadlock.h"

@interface FFEasyLifeHomeCtrl ()<YSAlertViewDelegate> {
    
    NSArray      *_oneArrays;

}

@property (nonatomic, strong) NSString     *oneString;

@property (nonatomic, strong) UILabel      *titleLab;

@property (nonatomic, strong) UIImageView  *recordImageView;

@property (nonatomic, strong) UIButton     *catButton;

@property (nonatomic, strong) NSArray      *nameArrays;

@property (nonatomic, strong) UIButton     *imgButton;

@property (nonatomic, strong) UIButton     *oneButton;

@property (nonatomic, strong) UIButton     *twoButton;

@property (nonatomic, strong) UILabel      *oneLab;

@property (nonatomic, strong) NSArray      *twoArrays;

@property (nonatomic, copy) NSString       *testResultString;

@property (nonatomic, copy) NSString       *__testTwoLineString;


@property (nonatomic, strong) FFTestObject *testObject;


@end

@implementation FFEasyLifeHomeCtrl

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    self.catButton.enabled = NO;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"首页";
    
    self.nameArrays = @[@"0A",@"1B",@"2C",@"3D",@"4E"];
    self.twoArrays = @[@"two1",@"two2",@"two3"];
    self.testResultString = @"";
    self.__testTwoLineString = @"__testTwoLineString";
    self.oneString = @"one";
    
    self.testObject = [[FFTestObject alloc] init];
    self.testObject.name = @"object_name";
    self.testObject.users = @[@"object_ming",@"object_li"];
    self.testObject.info =  [NSMutableDictionary dictionaryWithObjectsAndKeys:@"v1",@"key1",@"v2",@"key2",nil];
    self.testObject.number = [NSNumber numberWithInt:2];
    self.testObject.age = 2;
    
    [self.view addSubview:self.recordImageView];
    [self.view addSubview:self.titleLab];
    [self.view addSubview:self.catButton];
    [self.view addSubview:self.imgButton];
    [self.view addSubview:self.oneButton];
    [self.view addSubview:self.twoButton];
    
    [self.view addSubview:self.oneLab];
        
    [self testArray];
    [self testLable];
    [self testButton];
    [self testView];
    [self testEvent];
    [self testObjectEvent];
    

    FFTestDeadlock *obj = [[FFTestDeadlock alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        //A线程
        @synchronized (obj) {//X锁
            sleep(3);
            [obj methodA]; //methodA被JS替换，调用会进JS，请求JSCore的锁
        }
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
        //B线程
        [obj methodA];  //methodA被JS替换，调用会进JS，请求JSCore的锁

    });
    
    

}


// MARK: - 方法


- (void)testArray {//数组越界
    NSString *testName = self.nameArrays[5];
    NSLog(@"----- testName: %@",testName);
}

- (void)testLable {
    self.titleLab.text = @"首页";
}

- (void)testButton {
}

- (void)testView {

}

- (void)testEvent {
}

- (void)p_testLineFunction {
    NSLog(@"---- p_testLineFunction");    
    self.testResultString = [self.testResultString stringByAppendingString:@"p_testLine"];
}

- (void)_testLineFuntcionTwo {
    self.testResultString = [self.testResultString stringByAppendingString:@"_testLine"];
}

- (void)testObjectEvent {
    
}


- (void)testResult {
    [self p_testLineFunction];
    [self _testLineFuntcionTwo];
    
    NSLog(@"testResutlString:  %@",self.testResultString);
    NSLog(@"testResutlString:  %@",self.__testTwoLineString);
    NSLog(@"testObject->info:  %@",self.testObject.info);
    NSLog(@"testObject->users:  %@",self.testObject.users);
    NSLog(@"testObject->name:  %@",self.testObject.name);
    
    NSLog(@"oneString:  %@",self.oneString);

}

- (void)testPointer:(NSError **)error {
    NSError *err = [[NSError alloc]initWithDomain:@"com.jspatch" code:42 userInfo:nil];
    *error = err;
}

// MARK: - action

- (void)actionPicture:(UIButton *)button {
    
}

- (void)actionImg:(UIButton *)button {
    NSLog(@"---- oneArray:%@",_oneArrays);
    [self testResult];

}





// MARK: - getter

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 30)];
        _titleLab.text = @"hello!!!";
    }
    return _titleLab;
}

- (UILabel *)oneLab {
    if (!_oneLab) {
        _oneLab = [[UILabel alloc] initWithFrame:CGRectMake((k_SCREEN_WIDTH - 140) / 2.0, 94, 140, 30)];
        _oneLab.backgroundColor = [UIColor lightGrayColor];
    }
    return _oneLab;
}

- (UIImageView *)recordImageView {
    if (!_recordImageView) {
        _recordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 130, 150, 90)];
        _recordImageView.backgroundColor = [UIColor grayColor];
        _recordImageView.image = [UIImage imageNamed:@"1.jpeg"];
    }
    return _recordImageView;
}

- (UIButton *)catButton {
    if (!_catButton) {
        _catButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _catButton.backgroundColor = k_COLORRANDOM;
        [_catButton setTitle:@"美图" forState:UIControlStateNormal];
        [_catButton addTarget:self action:@selector(actionPicture:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _catButton;
}

- (UIButton *)imgButton {
    if (!_imgButton) {
        _imgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _imgButton.frame = CGRectMake(0, self.view.bounds.size.height - 49, self.view.bounds.size.width / 4.0, 49);
        _imgButton.backgroundColor = k_COLORRANDOM;
        [_imgButton setTitle:@">热土<" forState:UIControlStateNormal];
        [_imgButton addTarget:self action:@selector(actionImg:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _imgButton;
}

- (UIButton *)oneButton {
    
    if (!_oneButton) {
        _oneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _oneButton.frame = CGRectMake(10, self.view.bounds.size.height - 100, 100, 30);
        _oneButton.titleLabel.font = [UIFont systemFontOfSize:11];
        _oneButton.backgroundColor = [UIColor orangeColor];
        [_oneButton setTitle:@"oc未实现事件方法" forState:UIControlStateNormal];
        [_oneButton addTarget:self action:@selector(actionOneButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _oneButton;
}

- (UIButton *)twoButton {
    
    if (!_twoButton) {
        _twoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _twoButton.frame = CGRectMake(120, self.view.bounds.size.height - 100, 100, 30);
        _twoButton.backgroundColor = [UIColor orangeColor];
        [_twoButton setTitle:@"oc未定义事件" forState:UIControlStateNormal];
    }
    return _twoButton;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
    
    

    

@end



