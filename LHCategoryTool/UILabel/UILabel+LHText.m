//
//  UILabel+TextSpace.m
//  LHCategoryTool
//
//  Created by 梁辉 on 2017/9/18.
//  Copyright © 2017年 ElonZung. All rights reserved.
//

#import "UILabel+LHText.h"

@implementation UILabel (LHText)

/**
 *  @brief 改变文本行间距
 *  @param space 文本行距
 */
- (void)changeTextLineSpace:(float)space
{
    NSString *labelText;
    if (self.text == nil) {
        labelText = @"";
    } else {
        labelText = self.text;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.attributedText = attributedString;
    [self sizeToFit];
    
}

/**
 *  @brief 改变文本字间距
 *  @param space 字间距
 */
- (void)changeTextWordSpace:(float)space;
{
    
    NSString *labelText = self.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(space)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.attributedText = attributedString;
    [self sizeToFit];
    
}

/**
 *  @brief 改变文本行间距和字间距
 *  @param lineSpace 文本行距
 *  @param wordSpace 字间距
 */
- (void)changeTextLineSpace:(float)lineSpace wordSpace:(float)wordSpace
{
    
    NSString *labelText = self.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(wordSpace)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.attributedText = attributedString;
    [self sizeToFit];
}


@end
