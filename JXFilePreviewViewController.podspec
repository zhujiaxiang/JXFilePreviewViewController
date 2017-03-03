#
# Be sure to run `pod lib lint HJShareMenu.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "JXFilePreviewViewController"
  s.version          = "0.1.0"
  s.summary          = "AFilePreview"
  s.homepage         = "https://github.com/zhujiaxiang/JXFilePreviewViewController"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "朱佳翔" => "zjxbaozoudhm@gmail.com" }
  s.source           = { :git => "https://github.com/zhujiaxiang/JXFilePreviewViewController.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files  = "JXFilePreviewViewController/**/*.{h,m}"
  s.public_header_files = "JXFilePreviewViewController/**/*.h"
  s.resources = "JXFilePreviewViewController/Image.xcassets/**/*.png"

  s.dependency 'Masonry', '~> 1.0.0'
end
