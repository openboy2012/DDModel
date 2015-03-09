# DDModel
ps:my English isn't 100% fluent,but I am trying to improve it.

##a HTTP-JSON-ORM-Persisent Object Kit.  
This model package the http request and reduce the UIViewController and http code coupling.  
Use the this model you can immediately convert a JSON to entity.  
You can also use custom parse methods 

##Installation

[![Version](http://cocoapod-badges.herokuapp.com/v/SQLitePersistentObject/badge.png)](http://cocoadocs.org/docsets/SQLitePersistentObject/) [![Platform](http://cocoapod-badges.herokuapp.com/p/SQLitePersistentObject/badge.png)](http://cocoadocs.org/docsets/SQLitePersistentObject/)   
FlickerNumber is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "DDModel"
Alternatively, you can just drag the files from `DDModel / Classes` into your own project. 

## Usage


###use code
1.import the header 'DDModelKit.h'  
2.initialize a DDModelHttpClient in your launching appDelegate use the method 'startWithURL:'.   
you also can initialized a clinet with the 'startWithURL:delegate:' if you want to custom the http parameteters or the response string, then please immplement the Protocol Methods '- (NSDictionary *)encodeParameters:(NSDictionary *)params;' and '- (NSString *)decodeResponseString:(NSString *)responseString;'  
3.create any entity inherit DDModel Class.
  define the property according the JSON value Property. e.g. {"name":"DeJohn",email:"dongjia_9251@126.com"},your property is name & email, the JSON string will immediately convert to entity.
  create your custom http request methods in the created entity class for get the initialzed entity from server  
  override the 'parseNode:' & 'parseMappings' if you need.  
4.please see more in the Demo Project.

## Methods

## Updates

## Requirements

- Xcode 6
- iOS 5.1.1 or Mac OSX 10.8

## Author

DeJohn Dong, dongjia_9251@126.com

## License

SQLitePersistentObject is available under the MIT license. See the LICENSE file for more info.
