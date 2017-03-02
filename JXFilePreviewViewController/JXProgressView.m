//
//  JXProgressView.m
//  JXUIKit
//
//  Created by 朱佳翔 on 2017/3/1.
//  Copyright © 2017年 zjx. All rights reserved.
//

#import "JXProgressView.h"

@implementation JXProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.progressBackgroundView = ({
            
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor lightGrayColor];
            view.layer.masksToBounds = YES;
            view.layer.cornerRadius = self.progressCornerRadius;
            
            [self addSubview:view];
            
            view;
        });
        
        self.progressView = ({
            
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor colorWithRed:0.37 green:0.82 blue:0.26 alpha:1];
            view.layer.masksToBounds = YES;
            view.layer.cornerRadius = self.progressCornerRadius;
            
            
            
            [self.progressBackgroundView addSubview:view];
            
            view;
        });
    }
    return self;
}



- (void)setProgressValue:(CGFloat)progressValue
{
    self.progressBackgroundView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.progressView.frame = CGRectMake(0, 0, self.frame.size.width * progressValue, self.frame.size.height);
}


@end
