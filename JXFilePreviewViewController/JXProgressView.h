//
//  JXProgressView.h
//  JXUIKit
//
//  Created by 朱佳翔 on 2017/3/1.
//  Copyright © 2017年 zjx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXProgressView : UIView

@property (strong,nonatomic) UIColor *progressBackGroundColor;       //背景色
@property (strong,nonatomic) UIColor *progressTintColor;             //进度条颜色
@property (assign,nonatomic) CGFloat progressValue;                  //进度条进度的值
@property (assign,nonatomic) NSInteger progressCornerRadius;         //进度条圆角
@property (assign,nonatomic) NSInteger progressBorderWidth;          //进度条边宽度

@property(strong, nonatomic) UIView *progressBackgroundView;
@property(strong, nonatomic) UIView *progressView;
@property(strong, nonatomic) UILabel *progressLabel;

@end
