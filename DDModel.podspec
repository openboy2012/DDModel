Pod::Spec.new do |s|
 s.name     = 'DDModel'
 s.version  = '0.4'
 s.license  = 'MIT'
 s.summary  = 'a HTTP-JSON-ORM-Persisent Object Kit'
 s.homepage = 'https://github.com/openboy2012/DDModel.git'
 s.author   = { 'DeJohn Dong' => 'dongjia_9251@126.com' }
 s.source   = { :git => 'https://github.com/openboy2012/DDModel.git',:tag=>s.version.to_s}
 s.ios.deployment_target = '6.0'
 s.public_header_files = 'Classes/DDModelKit.h'
 s.source_files = 'Classes/DDModelKit.h'
 s.requires_arc = true
 s.subspec 'Categories' do |ss|
   ss.source_files = 'DDModel/Classes/{NS}*.{h,m}'
 end
 s.subsepc 'Cache' do |ss|
   ss.dependency 'DDModel/Categories'
   ss.dependency 'SQLitePersistentObject','~> 0.3'

   ss.source_files = 'DDModel/Classes/DDCache.{h,m}'
 end
 s.subspec 'HTTP' do |ss|
   ss.dependency 'DDModel/Categories'
   ss.dependency 'AFNetworking', '2.5.1'
   ss.dependency 'MBProgressHUD','0.9.1'

   ss.source_files = 'DDModel/Classes/DDModelHttpClient.{h,m}'
 end
 s.subspec 'Core' do |ss|
   ss.dependency 'JTObjectMapping','1.1.2'
   ss.dependency 'XMLDictionary','1.4'

   ss.source_files = 'DDModel/Classes/{DD}*.{h,m}'
 end
end


