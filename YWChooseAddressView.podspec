Pod::Spec.new do |s|

  s.name         = "YWChooseAddressView"
  s.version      = "1.0.3"
  s.summary      = "地区选择器"
  s.description  = <<-DESC
                  高仿京东地区选择器
                 DESC
  s.homepage     = "https://github.com/90candy/YWChooseAddressView"
  s.license              = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "90Candy" => "90candy.com@gmail.com" }
  s.social_media_url   = "https://www.jianshu.com/u/0f7d26d766f4"
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/90candy/YWChooseAddressView.git", :tag => s.version }
  s.source_files  = "YWChooseAddress/YWChooseAddressView/**/*.{h,m}"
  s.resources = "YWChooseAddress/YWChooseAddressView/Resource/*.{png,json}"
  s.requires_arc = true
  s.dependency "FMDB", "~> 2.7.2"

end