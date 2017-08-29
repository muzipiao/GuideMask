
Pod::Spec.new do |s|

  s.name         = "GuideMask"
  s.version      = "1.0.1"
  s.summary      = "高亮待提示视图的提示遮罩层"
  s.homepage     = "https://github.com/muzipiao/GuideMask"
  s.license      = "MIT"
  s.author       = { "lifei" => "lifei_zdjl@126.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/muzipiao/GuideMask.git", :tag => s.version}

  s.source_files = "GuideMask/**/*.{h,m}"
  s.requires_arc = true

end
