//
//  ViewController.m
//  iOSPrinciple_LLVMAndClang
//
//  Created by WhatsXie on 2018/5/14.
//  Copyright © 2018年 WhatsXie. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self debugTest];
}

- (void)debugTest {
#ifdef TESTMODE
    //测试服务器相关的代码
#else
    //生产服务器相关代码
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
