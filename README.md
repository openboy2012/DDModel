# DDModel
ps:my English isn't 100% fluent,but I am trying to improve it.

##a HTTP-JSON-ORM-Persisent Object Kit.  
DDModel inherit SQLitePersisentObject so you can save objects into SQLite immediately.   
DDModel package the http request to reduce the UIViewController & http code coupling, you won't worried how to package http request in your project any more when you use the DDModelKit.   
Your development will be simple.  

if you should support iOS 6.0, please use the version 0.x,  
now, I will have more working on the version 1.x, 1.x version need iOS 7.0 and Later.

##Installation

[![Version](http://cocoapod-badges.herokuapp.com/v/DDModel/badge.png)](http://cocoadocs.org/docsets/DDModel/) [![Platform](http://cocoapod-badges.herokuapp.com/p/DDModel/badge.png)](http://cocoadocs.org/docsets/DDModel/)   
DDModel is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "DDModel"
Alternatively, you can just drag the files from `DDModel / Classes` into your own project. then you should clone the repositories: [AFNetworking](https://github.com/AFNetworking/AFNetworking)、[XMLDictionary](https://github.com/nicklockwood/XMLDictionary)、[JTObjectMapping](https://github.com/jamztang/JTObjectMapping)、[SQLitePersistentObject](https://github.com/openboy2012/DDSQLiteKit)、[MBProgressHUD](https://github.com/jdg/MBProgressHUD)

## Usage

To run the example project; clone the repo, and run `pod install` from the Project directory first.

1.import `DDModelKit.h` in your project 

2.initialize a DDModelHttpClient in your gobal object, such as AppDelegate;
for example: 
```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [DDModelHttpClient startWithURL:@"https://api.app.net/" delegate:self]; // initialzie a DDModelHttpClient
    
    return YES;
}
```

You can set response type use the property of DDModelHttpClient like this: `[DDModelHttpClient sharedInstance].type = DDResponseXML`. so httpClient will handle the reponse datatype is XML.

Please implement the Protocol Methods `- (NSDictionary *)encodeParameters:(NSDictionary *)params;` or `- (NSString *)decodeResponseString:(NSString *)responseString; ` if you want to handle http request parameters or response string.

you should implement the Protocol Method `- (BOOL)checkResponseValueAvailable:(NSDictionary *)values failure:(DDResponsesFailureBlock)failure` if you have custom business logic in your API.

for example:

```objective-c
#pragma mark - DDHttpClient Delegate Method

- (NSDictionary *)encodeParameters:(NSDictionary *)params{

    // encode the the paramters
    NSMutableDictionary *finalParams = [NSMutableDictionary dictionaryWithDictionary:params];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *times = [formatter stringFromDate:[NSDate date]];
    [finalParams setObject:times forKey:@"time"];
    NSString *parameterString = [self ddEncode:finalParams];
    NSString *beforeSign = [NSString stringWithFormat:@"%@&%@&%@",PLATFORM,APP_KEY,parameterString];
    [finalParams setObject:[beforeSign md5] forKey:@"sign"];
    return finalParams;
}

- (NSString *)decodeResponseString:(NSString *)responseString{
    NSLog(@"responseString = %@",responseString);
    return responseString;
}

- (BOOL)checkResponseValueAvailable:(NSDictionary *)values
                            failure:(DDResponseFailureBlock)failure{
    // handler your owner business logic
    if([[values objectForKey:@"returnCode"] isEqualToString:@"0000"])
        return YES;
    else{
        if(failure){
            failure([NSError errorWithDomain:@"ddmodel.validate.error" code:1001 userInfo:nil],[values objectForKey:@"returnMessage"]);
        }
        return NO;
    }
}

```

3.create any entity inherit DDModel Class.
Define the property according the JSON value Property.
for exmale:   
JSON:   
```javascript
{"created_at":"2015-03-09T06:45:45Z","num_stars":0,"num_replies":0,"source":{"link":"http://themodernink.com/portfolio/dash-for-app-net/","name":"Dash","client_id":"nxz5USfARxELsYVpfPJc3mYaX42USb2E"},"text":"K\u00f6nnen wir bitte nochmal Sonntag haben? So einen wie gestern - nur mit anderem Spielergebnis der Eintracht? ","num_reposts":0,"id":"54842887","canonical_url":"https://alpha.app.net/berenike/post/54842887","entities":{"mentions":[],"hashtags":[],"links":[]},"html":"<span itemscope=\"https://app.net/schemas/Post\">K&#246;nnen wir bitte nochmal Sonntag haben? So einen wie gestern - nur mit anderem Spielergebnis der Eintracht? </span>","machine_only":false,"user":{"username":"berenike","avatar_image":{"url":"https://d1f0fplrc06slp.cloudfront.net/assets/user/68/b6/70/68b6700000000000.gif","width":500,"is_default":false,"height":500},"description":{"text":"irgendwie is hier anders.\r\nhttp://keinnaturtalent.wordpress.com\r\nhttp://franziskanaja.tumblr.com/","html":"<span itemscope=\"https://app.net/schemas/Post\">irgendwie is hier anders.&#13;<br><a href=\"http://keinnaturtalent.wordpress.com\">http://keinnaturtalent.wordpress.com</a>&#13;<br><a href=\"http://franziskanaja.tumblr.com/\">http://franziskanaja.tumblr.com/</a></span>","entities":{"mentions":[],"hashtags":[],"links":[{"url":"http://keinnaturtalent.wordpress.com","text":"http://keinnaturtalent.wordpress.com","pos":27,"len":36},{"url":"http://franziskanaja.tumblr.com/","text":"http://franziskanaja.tumblr.com/","pos":65,"len":32}]}},"locale":"de_DE","created_at":"2013-05-26T12:20:30Z","canonical_url":"https://alpha.app.net/berenike","cover_image":{"url":"https://d2rfichhc2fb9n.cloudfront.net/image/5/77Bi7kWHejTDAceY-gaw4B0h2SF7InMiOiJzMyIsImIiOiJhZG4tdXNlci1hc3NldHMiLCJrIjoiYXNzZXRzL3VzZXIvZTEvNDcvNDAvZTE0NzQwMDAwMDAwMDAwMC5qcGciLCJvIjoiIn0","width":960,"is_default":false,"height":300},"timezone":"Europe/Berlin","counts":{"following":40,"posts":682,"followers":43,"stars":340},"type":"human","id":"108262","name":"Franziska Naja"},"thread_id":"54842887","pagination_id":"54842887"}
```
Model Define:   
```objective-c
@interface User : DDModel

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *avatarImageURLString;

@end

@interface Post : DDModel

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) User *user;


+ (void)getPostList:(id)params
           parentVC:(id)viewController
            showHUD:(BOOL)show
            success:(DDResponseSuccessBlock)success
            failure:(DDResponsesFailureBlock)failure;

@end

#import "Post.h"

@implementation Post

+ (NSString *)parseNode{
    return @"data";
}

// ovrride this method if your define propery is not the same key in json string. or the object contain Nested objects
+ (NSDictionary *)parseMappings{
    id userHandler = [User mappingWithKey:@"user" mapping:[User parseMappings]];
    NSDictionary *jsonMappings = @{@"user":userHandler};
    return jsonMappings;
}

// a demo method of get data
+ (void)getPostList:(id)params
           parentVC:(id)viewController
            showHUD:(BOOL)show
            success:(DDResponseSuccessBlock)success
            failure:(DDResponseFailureBlock)failure
{
    [[self class] get:@"stream/0/posts/stream/global" params:params showHUD:show parentViewController:viewController successBlock:success failureBlock:failure];
}

@end

@implementation User

+ (NSDictionary *)parseMappings{
    // support for KeyPath
    return @{@"avatar_image.url":@"avatarImageURLString"};
}

@end
```

4.Please see more in demo project,thanks.

## Methods

##### DDModelHttpClient.h
```objective-c
/**
 *  Start a singleton HTTP client with url.
 *
 *  @param url HTTP target url
 */
+ (void)startWithURL:(NSString *)url;

/**
 *  Start a singleton HTTP client with url & delegate
 *
 *  @param url      HTTP target url
 *  @param delegate DDHttpClientDelegate
 */
+ (void)startWithURL:(NSString *)url delegate:(id<DDHttpClientDelegate>)delegate;

/**
 *  Set the HTTP header field value
 *
 *  @param keyValue keyValue
 */
+ (void)addHTTPHeaderFieldValue:(NSDictionary *)keyValue;

/**
 *  Remove the HTTP header field value
 *
 *  @param keyValue keyValue
 */
+ (void)removeHTTPHeaderFieldValue:(NSDictionary *)keyValue;

@protocol DDHttpClientDelegate <NSObject>

@optional
/**
 *  Parameter encode method if you should encode the parameter in your HTTP client
 *
 *  @param params original parameters
 *
 *  @return endcoded parameters
 */
- (NSDictionary *)encodeParameters:(NSDictionary *)params;

/**
 *  Response String decode methods in you HTTP client
 *
 *  @param responseString origin responseString
 *
 *  @return new responseString
 */
- (NSString *)decodeResponseString:(NSString *)responseString;

/**
 *  Check the response values is an avaliable value.
    e.g. You will sign in an account but you press a wrong username/password, server will response a error for you, you can catch them use this protocol methods and handle this error exception.
 *
 *  @param values  should check value
 *  @param failure failure block
 *
 *  @return true or false
 */
- (BOOL)checkResponseValueAvailable:(NSDictionary *)values failure:(DDResponseFailureBlock)failure;

@end

```

##### DDModel.h

```objective-c
@protocol DDMappings <NSObject>

/**
 *  Set the parse node, every subclass override the method if you want parse any node
 *
 *  @return node
 */
+ (NSString *)parseNode;

/**
 *  Handle the mappings about the json key-value transform to a model object.
 The method support for KeyPathValue. e.g. you have a  @property name, you want get value from "{user:{name:'mike',id:10011},picture:'https://xxxx/headerimage/header01.jpg'}", you just set mapping dictionary is @{@"user.name":@"name"}.
 *
 *  @return mappings
 */
+ (NSDictionary *)parseMappings;

@end

/**
 *  Get json data first from db cache then from http server by HTTP GET Mehod.
 *
 *  @param path           HTTP Path
 *  @param params         GET Paramtters
 *  @param dbResult       db cache result block
 *  @param success        success block
 *  @param failure        failre block
 *
 *  @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)get:(NSString *)path
                       params:(id)params
                    dbSuccess:(DDSQLiteBlock)dbResult
                      success:(DDResponseSuccessBlock)success
                      failure:(DDResponsesFailureBlock)failure;

/**
 *  Get json data first from db cache then from http server by HTTP POST Mehod.
 *
 *  @param path           HTTP Path
 *  @param params         GET Paramtters
 *  @param dbResult       db cache result block
 *  @param success        success block
 *  @param failure        failre block
 *
 *  @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)post:(NSString *)path
                        params:(id)params
                     dbSuccess:(DDSQLiteBlock)dbResult
                       success:(DDResponseSuccessBlock)success
                       failure:(DDResponsesFailureBlock)failure;

/**
 *  Get json data from http server by HTTP GET Mehod.
 *
 *  @param path           HTTP Path
 *  @param params         GET Paramtters
 *  @param success        success block
 *  @param failure        failre block
 *
 *  @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)get:(NSString *)path
                       params:(id)params
                      success:(DDResponseSuccessBlock)success
                      failure:(DDResponsesFailureBlock)failure;

/**
 *  Get json data from http server by HTTP POST Mehod.
 *
 *  @param path           HTTP Path
 *  @param params         POST Paramtters
 *  @param success        success block
 *  @param failure        failre block
 *
 *  @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)post:(NSString *)path
                        params:(id)params
                       success:(DDResponseSuccessBlock)success
                       failure:(DDResponsesFailureBlock)failure;

/**
 *  Upload a data stream to http server by HTTP POST Method.
 *
 *  @param path           HTTP Path
 *  @param stream         stream data
 *  @param params         POST Parameters
 *  @param userInfo       userInfo dictionary
 *  @param success        success block
 *  @param failure        failure block
 *
 *  @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)post:(NSString *)path
                    fileStream:(NSData *)stream
                        params:(id)params
                      userInfo:(id)userInfo
                       success:(DDUploadReponseSuccessBlock)success
                       failure:(DDResponsesFailureBlock)failure;

/**
 *  Parse self entity into a dictionary
 *
 *  @return a dictionary of self entity
 */
- (NSDictionary *)propertiesOfObject;

```

you can see more method in the project, there are aslo have many categories in the project.

## Updates
- 1.1 Code refactoring and add the feature about url change when http client runing.
- 1.0 Use the NSURLSession replace NSURLConnection

- 0.4 Add the db cache function
- 0.3 Add the xml parser function
- 0.2 Add the function of check api business logic 

## Requirements

- Xcode 6
- iOS 5.1.1 or Mac OSX 10.8 (0.x)/ iOS 7.0 and Later or OSX 10.9 (1.x)

## Author

DeJohn Dong, dongjia_9251@126.com

## License

DDModel is available under the MIT license. See the LICENSE file for more info.
