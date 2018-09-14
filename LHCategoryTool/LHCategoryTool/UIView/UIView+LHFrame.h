//
//  UIView+JSView.h
//  oCoffee
//
//  Created by xlg on 15/6/3.
//  Copyright (c) 2015年 osell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LHFrame)

@property (readonly) CGPoint bottomLeft;
@property (readonly) CGPoint bottomRight;
@property (readonly) CGPoint topRight;
@property (readonly) CGPoint topLeft;

@property CGFloat height;
@property CGFloat width;

@property CGFloat top;
@property CGFloat left;

@property CGFloat bottom;
@property CGFloat right;

- (void) moveBy: (CGPoint) delta;
- (void) scaleBy: (CGFloat) scaleFactor;
- (void) fitInSize: (CGSize) aSize;

-(void)removeAllSubViews;
-(void)removeSubViewWithTag:(NSInteger)tag;
-(void)resAllInputViews;
-(UIView*)findFirstResponder ;

@end
