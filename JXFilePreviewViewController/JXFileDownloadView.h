//
//  JXFileDownloadView.h
//  JXUIKit
//
//  Created by 朱佳翔 on 2017/2/27.
//  Copyright © 2017年 zjx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXProgressView.h"


@class JXFileDownloadView;

@protocol JXFileDownloadViewDelegate <NSObject>

@optional

- (void)jx_fileDownloadView:(JXFileDownloadView *)downloadView didTappedDownloadButton:(UIButton *)downloadButton;

@end

@interface JXFileDownloadView : UIView

@property(nonatomic, weak) id<JXFileDownloadViewDelegate> delegate;
@property(nonatomic, strong) NSString *extension;
@property(nonatomic, strong) UIImageView *extensionView;
@property(nonatomic, strong) UILabel *fileTitleLabel;
@property(nonatomic, strong) UIButton *downloadButton;
@property(nonatomic, strong) UILabel *progressLabel;
@property(nonatomic, strong) JXProgressView *progressView;

@end

