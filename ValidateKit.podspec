Pod::Spec.new do |s|
  s.name                      = 'ValidateKit'
  s.version                   = '0.9.9'
  s.summary                   = 'ValidateKit is a framework for validating data of model.'
  s.homepage                  = 'https://github.com/redwerk/ValidateKit'
  s.license                   = { :type => 'MIT', :file => 'LICENSE' }
  s.author                    = { 'Volodymyr Sakhan' => 'info@redwerk.com' }
  s.source                    = { :git => 'https://github.com/redwerk/ValidateKit.git', :tag => s.version.to_s }
  s.ios.deployment_target     = '8.0'
  s.tvos.deployment_target    = '9.0'
  s.watchos.deployment_target = '2.0'
  s.osx.deployment_target     = '10.10'
  s.source_files              = 'Sources/**/*'
  s.frameworks                = 'Foundation'
  s.swift_versions            = ['4.2', '5.0', '5.1']
end
