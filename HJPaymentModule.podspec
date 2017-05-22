#
#  Be sure to run `pod spec lint HJPaymentModule.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "HJPaymentModule"
  s.version      = "0.0.1"
  s.summary      = "对Alipay、微信支付、银联支付三方支付进行聚合"

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC
        1、集成alipay 、 微信支付、 银联支付三种支付方式，并暴露统一API进行管理
                   DESC

  s.homepage     = "https://github.com/Hjayth/HJPaymentModule"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

#  s.license      = "MIT (example)"
  s.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  s.author             = { "hjayth" => "18622995206@163.com" }
  # Or just: s.author    = "hjayth"
  # s.authors            = { "hjayth" => "18622995206@163.com" }
  # s.social_media_url   = "http://twitter.com/hjayth"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  # s.platform     = :ios
  #s.platform     = :ios, "8.0"

  #  When using multiple platforms
  s.ios.deployment_target = "8.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  s.source       = { :git => "https://github.com/Hjayth/HJPaymentModule.git", :tag => "#{s.version}" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  s.source_files  = "HJPaymentModule/HJPaymentModule.h"


#subspec
  s.subspec 'HJPaymentService' do |ss|
    ss.source_files = 'SYPayKit/Core/*.{h,m,c,swift}'
    ss.frameworks = 'SystemConfiguration','CFNetwork'
end

s.subspec 'AliPay' do |ss|
  ss.source_files = 'HJPaymentMoudle/PayChannels/AliPay/*.{h,m}'
  ss.resource = 'HJPaymentMoudle/PayChannels/AliPay/**/AlipaySDK.bundle'
  ss.frameworks = 'CoreTelephony', 'SystemConfiguration', 'CoreMotion'
  ss.vendored_frameworks = 'HJPaymentMoudle/PayChannels/AliPay/**/AlipaySDK.framework'
  ss.libraries = 'c++', 'sqlite3', 'z'
  ss.dependency 'HJPaymentMoudle/HJPaymentService'
end

s.subspec 'WXPay' do |ss|
  ss.source_files = 'HJPaymentMoudle/PayChannels/WXPay/**/*.{h,m}'
  ss.vendored_libraries = 'HJPaymentMoudle/PayChannels/WXPay/**/*.a'
  ss.libraries = 'c++', 'sqlite3', 'z'
  ss.frameworks = 'CoreTelephony'
#ss.dependency 'WechatOpenSDK'
  ss.dependency 'HJPaymentMoudle/HJPaymentService'
end

s.subspec 'Unpay' do |ss|
  ss.source_files = 'HJPaymentMoudle/PayChannels/Unpay/**/*.{h,m}'
  ss.vendored_libraries = 'HJPaymentMoudle/PayChannels/Unpay/**/*.a'
  ss.libraries = 'c++', 'sqlite3', 'z'
  ss.dependency 'HJPaymentMoudle/HJPaymentService'
end

  # s.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
