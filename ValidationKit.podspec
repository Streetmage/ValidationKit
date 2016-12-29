Pod::Spec.new do |s|

  s.name         = "ValidationKit"
  s.version      = "0.0.5"
  s.summary      = "ValidationKit is a framework for checking data input on various constrainsts."
  s.homepage     = "https://github.com/Streetmage/ValidationKit"
  s.license      = "MIT"

  s.author = "Streetmage"

  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/Streetmage/ValidationKit.git", :tag => "0.0.4" }

  s.source_files  = "ValidationKit/ValidationKit.h", "ValidationKit/VLDHelpers.h", "ValidationKit/CommonValidators/**/*.{h,m}", "ValidationKit/CommonValidators/**/*.{h,m}", "ValidationKit/TextValidators/**/*.{h,m}", "ValidationKit/TextContainers/**/*.{h,m}", "ValidationKit/Categories/**/*.{h,m}"

  s.framework  = "UIKit"

  s.requires_arc = true

end
