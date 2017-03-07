//
//  JXFilePreviewViewController.m
//  JXFilePreviewViewController
//
//  Created by 朱佳翔 on 2017/2/23.
//  Copyright © 2017年 朱佳翔. All rights reserved.
//

#import "JXFilePreviewViewController.h"
#import "JXFileDownloadView.h"
#import "JXFileDownloader.h"
#import <Masonry/Masonry.h>

@interface _JXFilePreviewItem : NSObject <QLPreviewItem>

- (nullable instancetype)initWithFileURL:(nonnull NSURL *)fileURL fileTitle:(nullable NSString *)fileTitle;

@end

@implementation _JXFilePreviewItem {
    NSURL *_previewItemURL;
    NSString *_previewItemTitle;
}

- (instancetype)initWithFileURL:(NSURL *)fileURL fileTitle:(NSString *)fileTitle
{
    if (self = [super init]) {
        _previewItemURL = fileURL;
        _previewItemTitle = fileTitle;
    }
    return self;
}

- (NSURL *)previewItemURL
{
    return _previewItemURL;
}

- (NSString *)previewItemTitle
{
    return _previewItemTitle;
}

@end


@interface JXFilePreviewViewController () <QLPreviewControllerDelegate, QLPreviewControllerDataSource, JXFileDownloadViewDelegate, JXFileDownloaderDelegate>

@property(nonnull, nonatomic, copy) NSURL *webFileURL;
@property(nonnull, nonatomic, copy) NSURL *localFileURL;
@property(nonnull, nonatomic, copy) NSString *fileTitle;
@property(nonnull, nonatomic, strong) UILabel *label;
@property(nonnull, nonatomic, strong) JXFileDownloadView *downloadView;
@property(nonatomic, assign) BOOL isDownloading;
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, assign) float totalBytesWritten;
@property(nonatomic, assign) float totalBytesExpectedToWrite;


@end

@implementation JXFilePreviewViewController

#pragma mark - Init

- (instancetype)initWithFileURL:(NSURL *)fileURL fileTitle:(NSString *)fileTitle
{
    if (self = [super init]) {
        _webFileURL = fileURL;
        _fileTitle = fileTitle;
        self.downloadView = [[JXFileDownloadView alloc] init];
        if ([fileURL.pathExtension isEqualToString:@"doc"] || [fileURL.pathExtension isEqualToString:@"docx"]) {
            self.downloadView.extensionView.image = [UIImage imageNamed:@"icon_file_word"];
        } else if ([fileURL.pathExtension isEqualToString:@"xls"] || [fileURL.pathExtension isEqualToString:@"xlsx"]) {
            self.downloadView.extensionView.image = [UIImage imageNamed:@"icon_file_excel"];
            
        } else if ([fileURL.pathExtension isEqualToString:@"ppt"] || [fileURL.pathExtension isEqualToString:@"pptx"]) {
            self.downloadView.extensionView.image = [UIImage imageNamed:@"icon_file_ppt"];
        } else if ([fileURL.pathExtension isEqualToString:@"pdf"]) {
            self.downloadView.extensionView.image = [UIImage imageNamed:@"icon_file_pdf"];
        } else if ([fileURL.pathExtension isEqualToString:@"txt"]) {
            self.downloadView.extensionView.image = [UIImage imageNamed:@"icon_file_txt"];
        } else {
            self.downloadView.extensionView.image = [UIImage imageNamed:@"icon_file_unknown"];
        }
    }
    
    self.dataSource = self;
    self.delegate = self;
    return self;
}

#pragma mark - View Lifecycle

#pragma mark - Private APIs

- (void)calProgress
{
    float progress = (float)self.totalBytesWritten / self.totalBytesExpectedToWrite;
    NSLog(@" %@ ,progress = %f", [NSThread currentThread], progress);
    self.downloadView.progressView.progressValue = progress;
    if (self.totalBytesExpectedToWrite > 1000 && self.totalBytesExpectedToWrite < 1000000) {
        self.downloadView.progressLabel.text = [NSString stringWithFormat:@"%.f %%  %.2f kb/%.2f kb", progress * 100, (float)self.totalBytesWritten / 1000, (float)self.totalBytesExpectedToWrite / 1000];
    } else if (self.totalBytesExpectedToWrite > 1000000) {
        self.downloadView.progressLabel.text = [NSString stringWithFormat:@"%.f %%  %.2f mb/%.2f mb", progress * 100, (float)self.totalBytesWritten / 1000000, (float)self.totalBytesExpectedToWrite / 1000000];
    } else {
        self.downloadView.progressLabel.text = [NSString stringWithFormat:@"%.f %%  %.2f b/%.2f b", progress * 100, (float)self.totalBytesWritten, (float)self.totalBytesExpectedToWrite];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.downloadView.fileTitleLabel.text = self.fileTitle;
    
    [JXFileDownloader sharedDownloader].delegate = self;
    
    [[JXFileDownloader sharedDownloader] diskFileExistsWithWebURL:self.webFileURL
                                                        completed:^(NSURL *_Nullable localFileURL) {
                                                            if (localFileURL) {
                                                                // 已离线缓存，直接预览
                                                                self.localFileURL = localFileURL;
                                                                [self reloadData];
                                                            } else {
                                                                
                                                                [self.view addSubview:self.downloadView];
                                                                [[JXFileDownloader sharedDownloader] downloadFileWithURL:_webFileURL
                                                                                                               completed:^(NSURL *_Nullable localFileURL, NSError *_Nullable error) {
                                                                                                                   NSLog(@"%@", localFileURL);
                                                                                                                   if (localFileURL) {
                                                                                                                       self.localFileURL = localFileURL;
                                                                                                                   }
                                                                                                               }];
                                                            }
                                                        }];
}

#pragma mark - JXFileDownloadViewDelegate

- (void)jx_fileDownloadView:(JXFileDownloadView *)downloadView didTappedDownloadButton:(UIButton *)downloadButton
{
    downloadButton.hidden = YES;
}

#pragma mark - QLPreviewControllerDataSource

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    if (!self.localFileURL) {
        return nil;
    }
    return [[_JXFilePreviewItem alloc] initWithFileURL:self.localFileURL fileTitle:self.fileTitle];
}

#pragma mark - JXFileDownloaderDelegate
- (void)jx_fileDownloader:(JXFileDownloader *)JXFileDownloader totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite WebURL:(nonnull NSURL *)url
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (url.absoluteString == self.webFileURL.absoluteString) {
            self.totalBytesWritten = (float)totalBytesWritten;
            self.totalBytesExpectedToWrite = (float)totalBytesExpectedToWrite;
            if (!self.timer) {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(calProgress) userInfo:nil repeats:YES];
                [self.timer fire];
            }
            
        } else {
            
            NSLog(@"%@", url.absoluteString);
            NSLog(@"%@", self.webFileURL.absoluteString);
            self.downloadView.progressLabel.text = @"另一个文件正在下载中，请稍等";
        }
    });
    
    if (totalBytesWritten == totalBytesExpectedToWrite) {
        [self.timer invalidate];
    }

}

- (void)jx_fileDownloader:(JXFileDownloader *)JXFileDownloader didFinishedDownloadingFromWebURL:(NSURL *)url ToURL:(NSURL *)location
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self calProgress];
    });
     if (url.absoluteString == self.webFileURL.absoluteString){
         dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 /*延迟执行时间*/ * NSEC_PER_SEC));
         
         dispatch_after(delayTime, dispatch_get_main_queue(), ^{
             
             self.localFileURL = location;
             
             [self reloadData];
             [self.downloadView removeFromSuperview];
             [self.timer invalidate];
         });
        
    } else {
        [JXFileDownloader diskFileExistsWithWebURL:self.webFileURL
                                         completed:^(NSURL *_Nullable localFileURL) {
                                             if (localFileURL) {
                                                 // 已离线缓存，直接预览
                                                 self.localFileURL = localFileURL;
                                                 [self reloadData];
                                             } else {
                                                 
                                                 [JXFileDownloader downloadFileWithURL:_webFileURL
                                                                             completed:^(NSURL *_Nullable localFileURL, NSError *_Nullable error) {
                                                                                 NSLog(@"%@", localFileURL);
                                                                                 if (localFileURL) {
                                                                                 }
                                                                             }];
                                             }
                                         }];
    }
}
@end
