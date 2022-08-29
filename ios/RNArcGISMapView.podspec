
require 'json'

package = JSON.parse(File.read(File.join(__dir__, '../package.json')))

Pod::Spec.new do |s|
  s.name         = 'RNArcGISMapView'
  s.version      = package['version']
  s.summary      = package['description']
  s.license      = package['license']

  s.authors      = package['author']
  s.homepage     = package['homepage']
  s.platforms    = { :ios => "9.0", :osx => "10.13" }

  s.source       = { :git => "https://github.com/lane-cn/ll-arcgis-mapview.git", :tag => "#{s.version}" }
  s.source_files  = "src/**/*.{h,m,swift}"

  s.dependency 'React'
  s.dependency 'ArcGIS-Runtime-SDK-iOS', '100.14.1'

end

  
