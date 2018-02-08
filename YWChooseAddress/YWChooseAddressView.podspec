Pod::Spec.new do |s|

  s.name         = "YWChooseAddressView"
  s.version      = "1.0.8"
  s.summary      = "高仿淘宝地区选择器、编辑与新增地址UI"
  s.description  = <<-DESC
                  高仿淘宝地区选择器、编辑地址UI、新增地址UI
                 DESC
  s.homepage     = "https://github.com/90candy/YWChooseAddressView"
  s.license              = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "90Candy" => "90candy.com@gmail.com" }
  s.social_media_url   = "https://www.jianshu.com/u/0f7d26d766f4"
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/90candy/YWChooseAddressView.git", :tag => s.version }
  s.source_files  = "YWChooseAddress/YWChooseAddressView/**/*.{h,m}"
  s.resources = "YWChooseAddress/YWChooseAddressView/Resource/*.{png,json,xib}"
  s.requires_arc = true
  s.dependency "FMDB", "~> 2.7.2"
  
  # pod trunk push YWChooseAddressView.podspec  --allow-warnings
end
