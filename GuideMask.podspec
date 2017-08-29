
Pod::Spec.new do |s|

  s.name         = "GuideMask"
  s.version      = "1.0.2"
  s.summary      = "快速添加新功能提示，只需传入相应待提示的View和新功能小图片名称即可"
  s.homepage     = "https://github.com/muzipiao/GuideMask"
  s.license      = "MIT"
  s.author       = { "lifei" => "lifei_zdjl@126.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/muzipiao/GuideMask.git", :tag => s.version}

  s.source_files = "GuideMask/**/*.{h,m}"
  s.requires_arc = true

end
