//
//  JXFilePreviewViewController.h
//  JXFilePreviewViewController
//
//  Created by 朱佳翔 on 2017/2/23.
//  Copyright © 2017年 朱佳翔. All rights reserved.
//

#import <QuickLook/QuickLook.h>

@interface JXFilePreviewViewController : QLPreviewController

- (nullable instancetype)initWithFileURL:(nullable NSURL *)fileURL fileTitle:(nullable NSString *)fileTitle;

@end
