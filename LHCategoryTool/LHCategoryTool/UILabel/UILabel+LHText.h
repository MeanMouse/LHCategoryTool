//
//  UILabel+TextSpace.h
//  LHCategoryTool
//
//  Created by 梁辉 on 2017/9/18.
//  Copyright © 2017年 ElonZung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (LHText)

/**
 *  @brief 改变文本行间距
 *  @param space 文本行距
 */
- (void)changeTextLineSpace:(float)space;

/**
 *  @brief 改变文本字间距
 *  @param space 字间距
 */
- (void)changeTextWordSpace:(float)space;

/**
 *  @brief 改变文本行间距和字间距
 *  @param lineSpace 文本行距
 *  @param wordSpace 字间距
 */
- (void)changeTextLineSpace:(float)lineSpace wordSpace:(float)wordSpace;


@end
