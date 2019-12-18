Pod::Spec.new do |s|
  s.name             = 'xe_shop_sdk'
  s.version          = '0.0.1'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  
  s.resources = "Assets/**/*.{bundle}"
  
  s.frameworks   = 'WebKit', 'UIKit', 'Foundation'
  s.vendored_frameworks = 'Framework/**/*.framework'

  s.ios.deployment_target = '8.0'
end

