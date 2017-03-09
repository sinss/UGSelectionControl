Pod::Spec.new do |s|
  s.name             = 'UGSelectionControl'
  s.version          = '0.1.0'
  s.summary          = 'My first cocoapods files'

  s.description      = <<-DESC
This fantastic view changes its color gradually makes your app look fantastic!
                       DESC

  s.homepage         = 'https://github.com/sinss/UGSelectionControl'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'leo.chang' => 'sinss0000@gmail.com' }
  s.source           = { :git => 'https://github.com/sinss/UGSelectionControl.git', :tag => s.version.to_s }

  s.requires_arc = true
  s.ios.deployment_target = '9.3'
  s.source_files = 'UniSelectionField/Classes/*'

end
