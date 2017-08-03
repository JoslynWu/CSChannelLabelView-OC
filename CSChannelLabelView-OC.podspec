Pod::Spec.new do |s|
  s.name         = "CSChannelLabelView-OC"
  s.version      = "0.0.1"
  s.summary      = "一个轻量的文字频道View。多个频道可滚动，少量频道可适配间距。"
  s.license      = { :type => 'Apache License', :file => 'LICENSE' }
  s.authors      = { 'Joslyn' => 'cs_joslyn@foxmail.com' }
  s.homepage     = 'https://github.com/JoslynWu/CSChannelLabelView-OC'
  s.social_media_url   = "http://www.jianshu.com/u/fb676e32e2e9"

  s.ios.deployment_target = '8.0'

  s.source       = { :git => 'https://github.com/JoslynWu/CSChannelLabelView-OC.git', :tag => s.version}
  
  s.requires_arc = true
  s.source_files = 'Sources/*.{h,m}'
  s.public_header_files = 'Sources/*.{h}'

end
