//
//  ViewController.m
//  LHCategoryTool
//
//  Created by mo2323 on 2018/9/14.
//  Copyright © 2018年 mo2323. All rights reserved.
//

#import "ViewController.h"
#import "NSString+LHEncrypt.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *string = @"nsiahihsssssssssss";
    NSString *key = @"lianghuikkkkkkkgkgddddddddddd";
    NSString *encryptString = [string DESAndECBEncryptedStringUsingKey:key];
    NSLog(@"encrypt: %@",encryptString);
    NSString *dencryptString = [encryptString decryptedDESAndECBStringUsingKey:key];
    NSLog(@"dencrypt: %@",dencryptString);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
