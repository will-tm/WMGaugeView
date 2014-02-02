Pod::Spec.new do |spec|
  spec.name 			= ‘WMGaugeView'
  spec.version 			= '0.0.1'
  spec.summary			= 'Provides a gauge control for ios'
  spec.platform 		= :ios
  spec.license			= 'MIT'
  spec.ios.deployment_target 	= '7.0'
  spec.authors			= ‘William Markezana'
  spec.homepage			= 'https://github.com/Will-tm/WMGaugeView'
  spec.source_files 		= ‘WMGaugeView/*.{h,m}'  
  spec.source			= { :git => 'https://github.com/Will-tm/WMGaugeView.git', :tag => 'v0.0.1' }
  spec.framework  = 'UIKit'
  spec.requires_arc = true

end
