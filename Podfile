source 'https://github.com/CocoaPods/Specs.git'

inhibit_all_warnings!
use_frameworks!
platform :ios, '10.0'

target 'ModuleIntegrationTests' do
	pod 'LocalServer', :path => './'
end

target 'SampleApp' do
	pod 'LocalServer', :path => './'
end

target 'SampleAppUITests' do
	pod 'LocalServer', :path => './'
end

target 'SampleAppUnitTests' do
	pod 'LocalServer', :path => './'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.2'
        end
    end
end
