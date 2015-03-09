Pod::Spec.new do |s|
 s.name     = 'DDModel'
 s.version  = '0.3.1'
 s.license  = 'MIT'
 s.summary  = 'a HTTP-JSON-ORM-Persisent Object Kit'
 s.homepage = 'https://github.com/openboy2012/DDModel.git'
 s.author   = { 'DeJohn Dong' => 'dongjia_9251@126.com' }
 s.source   = { :git => 'https://github.com/openboy2012/DDModel.git',:tag => s.version.to_s}
 s.ios.deployment_target = '6.0'
 s.public_header_files = 'Classes/*.h'
 s.source_files = 'Classes/DDModelKit.h'
 s.requires_arc = true
 s.subspec 'Core' do |ss|
    ss.source_files = 'Classes/{DD}*.{h,m}'
 end
 s.subspec 'Category' do |ss|
    ss.source_files = 'Classes/{NS}*.{h,m}'
 end
 s.dependency 'AFNetworking','~> 2.5.1'
 s.dependency 'SQLitePersistentObject','~> 0.3'
 s.dependency 'JTObjectMapping','~> 1.1.2'
 s.dependency 'MBProgressHUD','~> 0.9.1'
end


