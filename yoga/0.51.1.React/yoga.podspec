
source = { :git => ENV['INSTALL_YOGA_FROM_LOCATION'] || 'https://github.com/facebook/react-native.git' }
source[:tag] = "v0.51.1"

Pod::Spec.new do |spec|
  spec.name = 'yoga'
  spec.version = "0.51.1.React"
  spec.license =  { :type => 'MIT' }
  spec.homepage = 'https://facebook.github.io/yoga/'
  spec.documentation_url = 'https://facebook.github.io/yoga/docs/api/c/'

  spec.summary = 'Yoga is a cross-platform layout engine which implements Flexbox.'
  spec.description = 'Yoga is a cross-platform layout engine enabling maximum collaboration within your team by implementing an API many designers are familiar with, and opening it up to developers across different platforms.'

  spec.authors = 'Facebook'
  spec.source = source

  spec.module_name = 'yoga'
  spec.requires_arc = false
  spec.compiler_flags = [
      '-fno-omit-frame-pointer',
      '-fexceptions',
      '-Wall',
      '-Werror',
      '-std=c++1y',
      '-fPIC'
  ]

  # Pinning to the same version as React.podspec.
  spec.platforms = { :ios => "8.0", :tvos => "9.2" }

  # Set this environment variable when not using the `:path` option to install the pod.
  # E.g. when publishing this spec to a spec repo.
  source_files = 'yoga/**/*.{cpp,h}'
  source_files = File.join('ReactCommon/yoga', source_files) if ENV['INSTALL_YOGA_WITHOUT_PATH_OPTION']
  spec.source_files = source_files
end