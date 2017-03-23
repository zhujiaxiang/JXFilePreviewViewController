# JXFilePreviewViewController
This rookie's Project is used to download files and review them with one line of code (sadly,now more...)!
## TODO
1.change from GCD ->operation + GCD
2.use barrier
3.datatask | downloadtask
## Installation

[CocoaPods](http://cocoapods.org) is the recommended way of installation, as this avoids including any binary files into your project.

### CocoaPods (recommended)

JXFilePreviewViewController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your [Podfile](http://cocoapods.org/#get_started) and run `pod install`.

```ruby
pod "JXFilePreviewViewController"
```

### Manually

Clone(`git clone https://github.com/zhujiaxiang/JXFilePreviewViewController.git`) or  Download [JXFilePreviewViewController](https://github.com/zhujiaxiang/JXFilePreviewViewController/archive/master.zip), then drag `JXFilePreviewViewController` subdirectory to your Project.


## Usage

In your Project,add `#import <JXFilePreviewViewController/JXFilePreviewViewController.h>` statement and implement //delegate(TODO). As shown below:

```Objc
 NSURL *url = [NSURL URLWithString:@"http://www.neegle.net/kunlunMedia/upload/201708/a494d97e-7967-4e9a-b445-05c9152a4d78.zip"];
    JXFilePreviewViewController *vc = [[JXFilePreviewViewController alloc]initWithFileURL:url fileTitle:@"testTxt"];
    
    [self.navigationController pushViewController:vc animated:YES];

```

## Requirements

* Deployment Target iOS8.0+
* ARC
* AutoLayout


## Contribute

Please post any issues and ideas in the GitHub issue tracker and feel free to submit pull request with fixes and improvements. Keep in mind; a good pull request is small, well explained and should benifit most of the users.


## License

JXFilePreviewViewController is available under the MIT license. See the LICENSE file for more info.
