//
//  UITextField+LHTool.m
//  LHCategoryTool
//
//  Created by 梁辉 on 2018/4/10.
//  Copyright © 2018年 ElonZung. All rights reserved.
//

#import "UITextField+LHTool.h"
#import "NSString+LHTool.h"

@implementation UITextField (LHTool)

- (BOOL)trimmingEmojiWithReplacementString:(NSString *)string
{
    if ([self isFirstResponder]) {
        
        if ([[[self textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[self textInputMode] primaryLanguage]) {
            return NO;
        }
        
        //判断键盘是不是九宫格键盘
        if ([string isNineKeyBoard]){
            return YES;
        }else{
            if ([string hasEmoji] || [string stringContainsEmoji]){
                return NO;
            }
        }
    }
    return YES;
}

@end
