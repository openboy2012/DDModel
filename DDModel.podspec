Pod::Spec.new do |s|
s.name     = 'DDModel'
s.version  = '0.1.1'
s.license  = 'MIT'
s.summary  = 'a HTTP-JSON-ORM-Persisent Object Kit'
s.homepage = 'https://github.com/openboy2012/DDModel.git'
s.author   = { 'DeJohn Dong' => 'dongjia_9251@126.com' }
s.source   = { :git => 'https://github.com/openboy2012/DDModel.git',:tag => 0.1.1}
s.ios.deployment_target = '6.0'
s.public_header_file = 'DDModel/Classes/*.h'
s.source_files = 'DDModel/Classes/*.{h,m}'
s.requires_arc = true
s.dependency 'AFNetworking','~>2.5.0'
s.dependency 'SQLitePersistentObject','~>0.1'
s.dependency 'JTObjectMapping','~>1.1.2'
s.dependency 'MBProgressHUD','~> 0.9'
end

