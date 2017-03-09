//
//  JXFilePreviewViewController.h
//  JXFilePreviewViewController
//
//  Created by 朱佳翔 on 2017/2/23.
//  Copyright © 2017年 朱佳翔. All rights reserved.
//

#import <QuickLook/QuickLook.h>

typedef NS_ENUM(NSInteger, JXNetworkReachabilityStatus) {
    JXNetworkReachabilityStatusUnknown = -1,
    JXNetworkReachabilityStatusNotReachable = 0,
    JXNetworkReachabilityStatusReachableViaWWAN = 1,
    JXNetworkReachabilityStatusReachableViaWiFi = 2
};

@class JXFilePreviewViewController;

@protocol JXFilePreviewViewControllerDelegate <NSObject>

@required

- (JXNetworkReachabilityStatus)jx_statusReachabilityOfPreviewViewController:(nullable JXFilePreviewViewController *)viewController;

@end

@interface JXFilePreviewViewController : QLPreviewController

@property(nonatomic, weak, nullable) id<JXFilePreviewViewControllerDelegate> jx_delegate;

- (nullable instancetype)initWithFileURL:(nullable NSURL *)fileURL fileTitle:(nullable NSString *)fileTitle;

@end
