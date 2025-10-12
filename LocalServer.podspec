Pod::Spec.new do |s|
  s.name = "LocalServer"
  s.version = "2.1.6"
  s.summary = "Micro Feature"
  s.description = <<-DESC
                  LocalServer is resposible for ...
                  DESC
  s.homepage = "https://github.com/db-in/LocalServer.git"
  s.documentation_url = "https://db-in.github.io/LocalServer/"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = 'Diney Bomfim'
  s.source = { :git => "https://github.com/db-in/LocalServer.git", :tag => s.version, :submodules => true }
  s.swift_version = '5.0'

  s.requires_arc = true
  s.ios.deployment_target = '15.0'
  s.osx.deployment_target = '12.0'
  s.tvos.deployment_target = '15.0'
  s.watchos.deployment_target = '9.0'
  s.user_target_xcconfig = { 'GENERATE_INFOPLIST_FILE' => 'YES', 'MARKETING_VERSION' => "#{s.version}" }
  s.pod_target_xcconfig = { 'GENERATE_INFOPLIST_FILE' => 'YES', 'MARKETING_VERSION' => "#{s.version}"  }

  s.public_header_files = 'LocalServer/**/*.h'
  s.source_files = 'LocalServer/**/*.{h,m,swift}'
  s.exclude_files = 'LocalServer/**/Info.plist'

  s.frameworks = 'Foundation'
  s.ios.frameworks = 'WebKit'

end
