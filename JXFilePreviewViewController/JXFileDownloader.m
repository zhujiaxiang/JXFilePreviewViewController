//
//  JXFileDownloader.m
//  JXFilePreviewViewController
//
//  Created by 朱佳翔 on 2017/2/23.
//  Copyright © 2017年 朱佳翔. All rights reserved.
//

#import "JXFileDownloader.h"
#import "JXFileCache.h"

static NSString *const kDefaultNamespace = @"com.shenji.JXFileCache";

@interface JXFileDownloader () <NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate,JXFileDownloaderDelegate>

@property(nonatomic, copy) JXFileDownloadCompletionBlock completedBlock;
typedef void (^KLCheckCacheCompletionBlock)(NSURL *__nullable localFileURL);

@property(nonatomic, strong) dispatch_queue_t ioQueue;



@property(nonatomic, strong) NSMutableData *fileData;
@property(nonatomic, assign) NSInteger expectedSize;
@property(nonatomic, strong) NSURL *fileURL;
@property(nonatomic, assign) BOOL isDownloading;

@end

@implementation JXFileDownloader

+ (instancetype)sharedDownloader
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        // Create IO serial queue
        _ioQueue = dispatch_queue_create("net.shenji.JXFilePreview.io", DISPATCH_QUEUE_SERIAL);
        self.isDownloading = NO;
    }
    return self;
}

- (void)downloadFileWithURL:(nonnull NSURL *)fileURL completed:(nonnull JXFileDownloadCompletionBlock)completedBlock
{
    if (self.isDownloading == NO) {
        self.isDownloading = YES;
        // Session
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                              delegate:self
                                                         delegateQueue:nil];
        
        self.fileURL = fileURL;
        
        self.completedBlock = completedBlock;
        
        NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:fileURL];
        
        [downloadTask resume];
    }
    
}
#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
    NSLog(@"%lf", 1.0 * totalBytesWritten / totalBytesExpectedToWrite);
    if ([self.delegate respondsToSelector:@selector(jx_fileDownloader:totalBytesWritten:totalBytesExpectedToWrite:WebURL:)]) {
        [self.delegate jx_fileDownloader:self totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite WebURL:self.fileURL];
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    
    NSURL *localFileURL = nil;
    NSData *fileData = [NSData dataWithContentsOfURL:location];
    
    if (fileData) {
        
        localFileURL = [[JXFileCache sharedCache] storeLocalFileURLByFullNamespace:kDefaultNamespace URL:self.fileURL contents:fileData attributes:nil];
        !self.completedBlock ?: self.completedBlock(localFileURL, nil);
        self.isDownloading = NO;
        if ([self.delegate respondsToSelector:@selector(jx_fileDownloader:didFinishedDownloadingFromWebURL:ToURL:)]) {
            [self.delegate jx_fileDownloader:self didFinishedDownloadingFromWebURL:self.fileURL ToURL:localFileURL];
        }
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error
{
    !self.completedBlock ?: self.completedBlock(nil, error);
}

- (void)diskFileExistsWithWebURL:(nonnull NSURL *)webURL completed:(JXCheckCacheCompletionBlock)completedBlock
{
    dispatch_async(_ioQueue, ^{
        
        NSURL *localFileURL = nil;
        NSString *filePath = [[JXFileCache sharedCache] defaultFileCachePathForWebURL:webURL];
        BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
        if (exists) {
            localFileURL = [NSURL fileURLWithPath:filePath];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            !completedBlock ?: completedBlock(localFileURL);
        });
    });
}
@end
