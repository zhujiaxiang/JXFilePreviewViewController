//
//  ViewController.m
//  JXFilePreviewDemo
//
//  Created by zjx on 2017/2/23.
//  Copyright © 2017年 zjx. All rights reserved.
//

#import "ViewController.h"
#import "JXFilePreviewViewController.h"
#import "JXFileCache.h"

#import <Masonry.h>

static NSString *const kDefaultDirPath = @"com.zjx.JXFileCache";

@interface ViewController () <JXFilePreviewViewControllerDelegate>

@property(nonatomic, strong) UIButton *downloadZipButton;
@property(nonatomic, strong) UIButton *downloadExcelButton;
@property(nonatomic, strong) UIButton *downloadPdfButton;
@property(nonatomic, strong) UIButton *downloadPptButton;
@property(nonatomic, strong) UIButton *downloadWordButton;
@property(nonatomic, strong) UIButton *downloadTxtButton;
@property(nonatomic, strong) UIButton *clearAllCachesButton;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.downloadZipButton = ({

        UIButton *view = [[UIButton alloc] init];
        view.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:17];
        view.titleLabel.textColor = [UIColor whiteColor];
        view.layer.cornerRadius = 3.0f;
        view.layer.masksToBounds = YES;
        view.backgroundColor = [UIColor blackColor];
        [view setTitle:@"downloadZip" forState:UIControlStateNormal];
        [view addTarget:self action:@selector(onClickdownloadZipButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view.mas_centerX).offset(10.0f);
            make.centerY.mas_equalTo(self.view.mas_centerY).offset(-150.0f);
            make.height.mas_equalTo(20.0f);
        }];
        view;

    });

    self.downloadExcelButton = ({

        UIButton *view = [[UIButton alloc] init];
        view.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:17];
        view.titleLabel.textColor = [UIColor blackColor];
        view.layer.cornerRadius = 3.0f;
        view.layer.masksToBounds = YES;
        view.backgroundColor = [UIColor blackColor];
        [view setTitle:@"downloadExcel" forState:UIControlStateNormal];
        [view addTarget:self action:@selector(onClickdownloadExcelButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view.mas_centerX).offset(10.0f);
            make.top.mas_equalTo(self.downloadZipButton.mas_bottom).offset(10.0f);
            make.height.mas_equalTo(20.0f);
        }];
        view;

    });

    self.downloadPdfButton = ({

        UIButton *view = [[UIButton alloc] init];
        view.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:17];
        view.titleLabel.textColor = [UIColor whiteColor];
        view.layer.cornerRadius = 3.0f;
        view.layer.masksToBounds = YES;
        view.backgroundColor = [UIColor blackColor];
        [view setTitle:@"downloadPdf" forState:UIControlStateNormal];
        [view addTarget:self action:@selector(onClickdownloadPdfButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view.mas_centerX).offset(10.0f);
            make.top.mas_equalTo(self.downloadExcelButton.mas_bottom).offset(10.0f);
            make.height.mas_equalTo(20.0f);
        }];
        view;

    });

    self.downloadPptButton = ({

        UIButton *view = [[UIButton alloc] init];
        view.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:17];
        view.titleLabel.textColor = [UIColor blackColor];
        view.layer.cornerRadius = 3.0f;
        view.layer.masksToBounds = YES;
        view.backgroundColor = [UIColor blackColor];
        [view setTitle:@"downloadPpt" forState:UIControlStateNormal];
        [view addTarget:self action:@selector(onClickdownloadPptButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view.mas_centerX).offset(10.0f);
            make.top.mas_equalTo(self.downloadPdfButton.mas_bottom).offset(10.0f);
            make.height.mas_equalTo(20.0f);
        }];
        view;

    });

    self.downloadWordButton = ({

        UIButton *view = [[UIButton alloc] init];
        view.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:17];
        view.titleLabel.textColor = [UIColor whiteColor];
        view.layer.cornerRadius = 3.0f;
        view.layer.masksToBounds = YES;
        view.backgroundColor = [UIColor blackColor];
        [view setTitle:@"downloadWord" forState:UIControlStateNormal];
        [view addTarget:self action:@selector(onClickdownloadWordButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view.mas_centerX).offset(10.0f);
            make.top.mas_equalTo(self.downloadPptButton.mas_bottom).offset(10.0f);
            make.height.mas_equalTo(20.0f);
        }];
        view;

    });

    self.downloadTxtButton = ({

        UIButton *view = [[UIButton alloc] init];
        view.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:17];
        view.titleLabel.textColor = [UIColor blackColor];
        view.layer.cornerRadius = 3.0f;
        view.layer.masksToBounds = YES;
        view.backgroundColor = [UIColor blackColor];
        [view setTitle:@"downloadTxt" forState:UIControlStateNormal];
        [view addTarget:self action:@selector(onClickdownloadTxtButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view.mas_centerX).offset(10.0f);
            make.top.mas_equalTo(self.downloadWordButton.mas_bottom).offset(10.0f);
            make.height.mas_equalTo(20.0f);
        }];
        view;

    });

    self.clearAllCachesButton = ({

        UIButton *view = [[UIButton alloc] init];
        view.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:17];
        view.titleLabel.textColor = [UIColor blackColor];
        view.layer.cornerRadius = 3.0f;
        view.layer.masksToBounds = YES;
        view.backgroundColor = [UIColor blackColor];
        [view setTitle:@"clearAllCaches" forState:UIControlStateNormal];
        [view addTarget:self action:@selector(onClickclearAllCachesButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view.mas_centerX).offset(10.0f);
            make.top.mas_equalTo(self.downloadTxtButton.mas_bottom).offset(10.0f);
            make.height.mas_equalTo(20.0f);
        }];
        view;
    });
}

- (JXNetworkReachabilityStatus)jx_statusReachabilityOfPreviewViewController:(JXFilePreviewViewController *)viewController
{
    return JXNetworkReachabilityStatusReachableViaWWAN;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onClickdownloadZipButton:(UIButton *)sender
{
    NSURL *url = [NSURL URLWithString:@"http://www.neegle.net/kunlunMedia/upload/201708/a494d97e-7967-4e9a-b445-05c9152a4d78.zip"];
    JXFilePreviewViewController *vc = [[JXFilePreviewViewController alloc] initWithFileURL:url fileTitle:@"testZip"];
    vc.jxdelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onClickdownloadExcelButton:(UIButton *)sender
{
    NSURL *url = [NSURL URLWithString:@"http://www.neegle.net/kunlunMedia/upload/201709/5d5b7229-96a2-446b-a8bf-ae2cfccf6362.xlsx"];
    JXFilePreviewViewController *vc = [[JXFilePreviewViewController alloc] initWithFileURL:url fileTitle:@"testExcel"];
    vc.jxdelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onClickdownloadPdfButton:(UIButton *)sender
{
    NSURL *url = [NSURL URLWithString:@"http://www.neegle.net/kunlunMedia/upload/201709/3a906b1a-5a6a-4264-9d15-65e0e82e2310.pdf"];
    JXFilePreviewViewController *vc = [[JXFilePreviewViewController alloc] initWithFileURL:url fileTitle:@"testPdf"];
    vc.jxdelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onClickdownloadPptButton:(UIButton *)sender
{
    NSURL *url = [NSURL URLWithString:@"http://www.neegle.net/kunlunMedia/upload/201709/6b8d6830-d55d-4a4c-9a5f-98be1c195f23.ppt"];
    JXFilePreviewViewController *vc = [[JXFilePreviewViewController alloc] initWithFileURL:url fileTitle:@"testPpt"];
    vc.jxdelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onClickdownloadWordButton:(UIButton *)sender
{
    NSURL *url = [NSURL URLWithString:@"http://www.neegle.net/kunlunMedia/upload/201709/bf5e2a8c-60ef-4907-bb40-b11ab841d495.docx"];
    JXFilePreviewViewController *vc = [[JXFilePreviewViewController alloc] initWithFileURL:url fileTitle:@"testWord"];
    vc.jxdelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onClickdownloadTxtButton:(UIButton *)sender
{
    NSURL *url = [NSURL URLWithString:@"http://www.neegle.net/kunlunMedia/upload/201709/eb8ce21a-1f19-40e4-a237-f1c2f48f1254.txt"];
    JXFilePreviewViewController *vc = [[JXFilePreviewViewController alloc] initWithFileURL:url fileTitle:@"testTxt"];
    vc.jxdelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onClickclearAllCachesButton:(UIButton *)sender
{
    [[JXFileCache sharedCache] clearAllCaches];
}
@end
