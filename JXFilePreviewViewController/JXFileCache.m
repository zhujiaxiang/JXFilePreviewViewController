//
//  JXFileCache.m
//  JXFilePreviewViewController
//
//  Created by 朱佳翔 on 2017/2/23.
//  Copyright © 2017年 朱佳翔. All rights reserved.
//

#import "JXFileCache.h"
#import <CommonCrypto/CommonDigest.h>

static NSString *const kDefaultNamespace = @"com.zjx.JXFileCache";

@implementation JXFileCache

+ (instancetype)sharedCache
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (nullable NSString *)makeDiskCachePath:(nonnull NSString *)fullNamespace
{
    NSArray<NSString *> *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths[0] stringByAppendingPathComponent:fullNamespace];
}

- (nullable NSString *)cachedFileNameForKey:(nullable NSString *)key
{
    const char *str = key.UTF8String;
    if (str == NULL) {
        str = "";
    }
    unsigned char r[16];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%@",
                                                    r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10],
                                                    r[11], r[12], r[13], r[14], r[15], [key.pathExtension isEqualToString:@""] ? @"" : [NSString stringWithFormat:@".%@", key.pathExtension]];

    return filename;
}

- (nullable NSURL *)storeLocalFileURLByFullNamespace:(nullable NSString *)fullNamespace URL:(nonnull NSURL *)url contents:(nullable NSData *)data attributes:(nullable NSDictionary<NSString *, id> *)attr
{
    NSURL *localFileURL = nil;
    //构建缓存目录
    NSString *dirPath = nil;

    if (fullNamespace) {
        dirPath = [self makeDiskCachePath:fullNamespace];
    } else {
        dirPath = [self makeDiskCachePath:[NSBundle mainBundle].bundleIdentifier];
    }

    //构建缓存文件的路径
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", dirPath, [self cachedFileNameForKey:url.absoluteString]];

    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:dirPath]) {
        [fm createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:attr error:NULL];
    }
    BOOL createFileSuccess = [fm createFileAtPath:filePath
                                         contents:data
                                       attributes:attr];
    if (createFileSuccess) {
        localFileURL = [NSURL fileURLWithPath:filePath];
    }

    return localFileURL;
}

- (NSString *)defaultFileCachePathForWebURL:(nonnull NSURL *)url
{
    NSString *dirPath = [self makeDiskCachePath:kDefaultNamespace];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", dirPath, [self cachedFileNameForKey:url.absoluteString]];

    return filePath;
}

- (void)clearAllCaches
{
    NSFileManager *fm = [NSFileManager defaultManager];

    NSString *dirPathStr = nil;

    if (kDefaultNamespace) {
        dirPathStr = [self makeDiskCachePath:kDefaultNamespace];
    } else {
        dirPathStr = [self makeDiskCachePath:[NSBundle mainBundle].bundleIdentifier];
    }

    if ([fm fileExistsAtPath:dirPathStr]) {
        BOOL success = [fm removeItemAtPath:dirPathStr error:nil];

        NSLog(@"%i",success);
    }
}
@end
