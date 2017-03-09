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
@property(nonatomic, assign) JXNetworkReachabilityStatus status;
@property(nonatomic, assign) BOOL allowWWAN;

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

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([self.jx_delegate respondsToSelector:@selector(jx_statusReachabilityOfPreviewViewController:)]) {
        self.status = [self.jx_delegate jx_statusReachabilityOfPreviewViewController:self];
    }

    self.downloadView.fileTitleLabel.text = self.fileTitle;

    [JXFileDownloader sharedDownloader].delegate = self;

    [[JXFileDownloader sharedDownloader] diskFileExistsWithWebURL:self.webFileURL
                                                        completed:^(NSURL *_Nullable localFileURL) {
                                                            if (localFileURL) {
                                                                // 已离线缓存，直接预览
                                                                self.localFileURL = localFileURL;
                                                                [self reloadData];
                                                            } else {
                                                                if (self.status == JXNetworkReachabilityStatusReachableViaWiFi) {
                                                                    [self.view addSubview:self.downloadView];
                                                                    [[JXFileDownloader sharedDownloader] downloadFileWithURL:_webFileURL];
                                                                } else if (self.status == JXNetworkReachabilityStatusReachableViaWWAN) {
                                                                    [self.view addSubview:self.downloadView];
                                                                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"您当前网络环境为2G/3G/4G,下载文件将消耗您的流量，您要继续吗？" preferredStyle:UIAlertControllerStyleAlert];

                                                                    // 添加按钮
                                                                    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                                                                              style:UIAlertActionStyleDestructive
                                                                                                            handler:^(UIAlertAction *action) {
                                                                                                                //                                                                                                                [self.view addSubview:self.downloadView];
                                                                                                                [[JXFileDownloader sharedDownloader] downloadFileWithURL:_webFileURL];
                                                                                                                self.allowWWAN = YES;
                                                                                                            }]];
                                                                    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                                                                              style:UIAlertActionStyleCancel
                                                                                                            handler:^(UIAlertAction *action) {
                                                                                                                [self.navigationController popViewControllerAnimated:NO];
                                                                                                                self.allowWWAN = NO;
                                                                                                            }]];

                                                                    [self presentViewController:alert animated:YES completion:nil];
                                                                } else {
                                                                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"无网络，不可操作！" preferredStyle:UIAlertControllerStyleAlert];

                                                                    // 添加按钮
                                                                    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                                                                              style:UIAlertActionStyleDestructive
                                                                                                            handler:^(UIAlertAction *action) {
                                                                                                                [self.navigationController popViewControllerAnimated:NO];
                                                                                                            }]];

                                                                    [self presentViewController:alert animated:YES completion:nil];
                                                                }
                                                            }
                                                        }];
}

#pragma mark - Private APIs

- (void)calProgress
{
    float progress = (float)self.totalBytesWritten / self.totalBytesExpectedToWrite;
    NSLog(@" %@ ,progress = %f", [NSThread currentThread], progress);
    self.downloadView.progressView.progressValue = progress;
    if (self.totalBytesExpectedToWrite > 1000 && self.totalBytesExpectedToWrite < 1000000) {
        self.downloadView.progressLabel.text = [NSString stringWithFormat:@"%.f %%  %.1f kb/%.1f kb", progress * 100, (float)self.totalBytesWritten / 1000, (float)self.totalBytesExpectedToWrite / 1000];
    } else if (self.totalBytesExpectedToWrite > 1000000) {
        self.downloadView.progressLabel.text = [NSString stringWithFormat:@"%.f %%  %.1f mb/%.1f mb", progress * 100, (float)self.totalBytesWritten / 1000000, (float)self.totalBytesExpectedToWrite / 1000000];
    } else {
        self.downloadView.progressLabel.text = [NSString stringWithFormat:@"%.f %%  %.1f b/%.1f b", progress * 100, (float)self.totalBytesWritten, (float)self.totalBytesExpectedToWrite];
    }
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
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(calProgress) userInfo:nil repeats:NO];

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

- (void)jx_fileDownloader:(JXFileDownloader *)fileDownloader didFinishedDownloadingFromURL:(NSURL *)fromURL toURL:(NSURL *)toURL
{
    if (fromURL.absoluteString == self.webFileURL.absoluteString) {
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 /*延迟执行时间*/ * NSEC_PER_SEC));

        dispatch_after(delayTime, dispatch_get_main_queue(), ^{

            self.localFileURL = toURL;

            [self reloadData];
            [self.downloadView removeFromSuperview];
        });

    } else {
        [fileDownloader diskFileExistsWithWebURL:self.webFileURL
                                       completed:^(NSURL *_Nullable localFileURL) {
                                           if (localFileURL) {
                                               // 已离线缓存，直接预览
                                               self.localFileURL = localFileURL;
                                               [self reloadData];
                                           } else {

                                               [fileDownloader downloadFileWithURL:_webFileURL];
                                           }
                                       }];
    }
}
@end
