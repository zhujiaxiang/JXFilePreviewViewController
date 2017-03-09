//
//  JXFileDownloader.h
//  JXFilePreviewViewController
//
//  Created by 朱佳翔 on 2017/2/23.
//  Copyright © 2017年 朱佳翔. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^JXFileDownloadCompletionBlock)(NSURL *__nullable localFileURL, NSError *__nullable error);
typedef void (^JXCheckCacheCompletionBlock)(NSURL *__nullable localFileURL);

@class JXFileDownloader;

@protocol JXFileDownloaderDelegate <NSObject>

@optional

- (void)jx_fileDownloader:(nullable JXFileDownloader *)fileDownloader totalBytesWritten:(int64_t)totalBytesWritten
    totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
                       WebURL:(nonnull NSURL *)url;

- (void)jx_fileDownloader:(nullable JXFileDownloader *)fileDownloader didFinishedDownloadingFromURL:(nonnull NSURL *)fromURL toURL:(nonnull NSURL *)toURL;

@end

@interface JXFileDownloader : NSObject

+ (nullable instancetype)sharedDownloader;

@property(nonatomic, weak, nullable) id<JXFileDownloaderDelegate> delegate;

- (void)downloadFileWithURL:(nonnull NSURL *)fileURL;

- (void)diskFileExistsWithWebURL:(nonnull NSURL *)webURL completed:(nullable JXCheckCacheCompletionBlock)completedBlock;

@end
