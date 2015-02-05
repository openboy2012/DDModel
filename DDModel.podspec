Pod::Spec.new do |s|
s.name     = 'DDModel'
s.version  = '0.1'
s.license  = 'MIT'
s.summary  = 'a HTTP-JSON-ORM-Persisent Object Kit'
s.homepage = 'https://github.com/openboy2012/DDModel.git'
s.author   = { 'DeJohn Dong' => 'dongjia_9251@126.com' }
s.source   = { :git => 'https://github.com/openboy2012/DDSQLiteKit.git',:tag => 0.1}
s.ios.deployment_target = '5.1.1'
s.osx.deployment_target = '10.7'
s.source_files = 'DDModel/Classes/*.{h,m}'
s.requires_arc = true
s.dependency 'AFNetworking', '~>2.5.0'
             'SQLitePersistentObject', '~>0.1'
             'JTObjectMappings', '~>1.1.2',
             'MBProgressHUD','~> 0.9'
end

