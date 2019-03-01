Pod::Spec.new do |s|
  s.name = "LocalServer"
  s.version = "1.3.1"
  s.summary = "Micro Feature"
  s.description = <<-DESC
                  LocalServer is resposible for ...
                  DESC
  s.homepage = "https://github.com/dineybomfim/LocalServer.git"
  s.documentation_url = "https://github.com/dineybomfim/LocalServer/documentation"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = 'Diney Bomfim'
  s.source = { :git => "https://github.com/dineybomfim/LocalServer.git", :tag => s.version, :submodules => true }
  s.swift_version = '4.2'

  s.requires_arc = true
  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.11'
  s.tvos.deployment_target = '10.0'
  s.watchos.deployment_target = '2.0'

  s.public_header_files = 'LocalServer/**/*.h'
  s.source_files = 'LocalServer/**/*.{h,m,swift}'
  s.exclude_files = 'LocalServer/**/Info.plist'

  s.ios.frameworks = 'Foundation', 'WebKit'

end
