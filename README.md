# DDModel
ps:my English isn't 100% fluent,but I am trying to improve it.

##a HTTP-JSON-ORM-Persisent Object Kit.  
DDModel inherit SQLitePersisentObject so you can save objects into SQLite immediately.   
DDModel package the http request to reduce the UIViewController & http code coupling, you won't worried how to package http request in your project any more when you use the DDModelKit.   
Your development will be simple.

##Installation

[![Version](http://cocoapod-badges.herokuapp.com/v/DDModel/badge.png)](http://cocoadocs.org/docsets/DDModel/) [![Platform](http://cocoapod-badges.herokuapp.com/p/DDModel/badge.png)](http://cocoadocs.org/docsets/DDModel/)   
DDModel is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "DDModel"
Alternatively, you can just drag the files from `DDModel / Classes` into your own project. 

## Usage

To run the example project; clone the repo, and run `pod install` from the Project directory first.

1.import `DDModelKit.h` in your project 

2.initialize a DDModelHttpClient in your gobal object, such as AppDelegate;
for example: 
```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [DDModelHttpClient startWithURL:@"https://api.app.net/" delegate:self]; // initialzie a DDModelHttpClient
    
    return YES;
}
```

You can set response type use the property of DDModelHttpClient like this: `[DDModelHttpClient sharedInstance].type = DDResponseXML`. so httpClient will handle the reponse datatype is XML.

Please implement the Protocol Methods `- (NSDictionary *)encodeParameters:(NSDictionary *)params;` or `- (NSString *)decodeResponseString:(NSString *)responseString; ` if you want to handle http request parameters or response string.

you should implement the Protocol Method `- (BOOL)checkResponseValueAvaliable:(NSDictionary *)values failure:(DDResponseFailureBlock)failure` if you have custom business logic in your API.

for example:

```
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

- (BOOL)checkResponseValueAvaliable:(NSDictionary *)values
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
```
{"created_at":"2015-03-09T06:45:45Z","num_stars":0,"num_replies":0,"source":{"link":"http://themodernink.com/portfolio/dash-for-app-net/","name":"Dash","client_id":"nxz5USfARxELsYVpfPJc3mYaX42USb2E"},"text":"K\u00f6nnen wir bitte nochmal Sonntag haben? So einen wie gestern - nur mit anderem Spielergebnis der Eintracht? ","num_reposts":0,"id":"54842887","canonical_url":"https://alpha.app.net/berenike/post/54842887","entities":{"mentions":[],"hashtags":[],"links":[]},"html":"<span itemscope=\"https://app.net/schemas/Post\">K&#246;nnen wir bitte nochmal Sonntag haben? So einen wie gestern - nur mit anderem Spielergebnis der Eintracht? </span>","machine_only":false,"user":{"username":"berenike","avatar_image":{"url":"https://d1f0fplrc06slp.cloudfront.net/assets/user/68/b6/70/68b6700000000000.gif","width":500,"is_default":false,"height":500},"description":{"text":"irgendwie is hier anders.\r\nhttp://keinnaturtalent.wordpress.com\r\nhttp://franziskanaja.tumblr.com/","html":"<span itemscope=\"https://app.net/schemas/Post\">irgendwie is hier anders.&#13;<br><a href=\"http://keinnaturtalent.wordpress.com\">http://keinnaturtalent.wordpress.com</a>&#13;<br><a href=\"http://franziskanaja.tumblr.com/\">http://franziskanaja.tumblr.com/</a></span>","entities":{"mentions":[],"hashtags":[],"links":[{"url":"http://keinnaturtalent.wordpress.com","text":"http://keinnaturtalent.wordpress.com","pos":27,"len":36},{"url":"http://franziskanaja.tumblr.com/","text":"http://franziskanaja.tumblr.com/","pos":65,"len":32}]}},"locale":"de_DE","created_at":"2013-05-26T12:20:30Z","canonical_url":"https://alpha.app.net/berenike","cover_image":{"url":"https://d2rfichhc2fb9n.cloudfront.net/image/5/77Bi7kWHejTDAceY-gaw4B0h2SF7InMiOiJzMyIsImIiOiJhZG4tdXNlci1hc3NldHMiLCJrIjoiYXNzZXRzL3VzZXIvZTEvNDcvNDAvZTE0NzQwMDAwMDAwMDAwMC5qcGciLCJvIjoiIn0","width":960,"is_default":false,"height":300},"timezone":"Europe/Berlin","counts":{"following":40,"posts":682,"followers":43,"stars":340},"type":"human","id":"108262","name":"Franziska Naja"},"thread_id":"54842887","pagination_id":"54842887"}
```
Model Define:   
```
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
            failure:(DDResponseFailureBlock)failure;

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
    [[self class] get:@"stream/0/posts/stream/global" params:params showHUD:show parentViewController:viewController success:success failure:failure];
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
```
/**
 *  start a singleton HTTP client with url<启动一个设置URL单例HTTP请求>
 *
 *  @param url HTTP target url<http目标URL>
 */
+ (void)startWithURL:(NSString *)url;

/**
 *  start a singleton HTTP client with url and delegate
 *
 *  @param url      HTTP target url
 *  @param delegate DDHttpClientDelegate
 */
+ (void)startWithURL:(NSString *)url delegate:(id<DDHttpClientDelegate>)delegate;

/**
 *  set the HTTP header field value
 *
 *  @param keyValue keyValue
 */
+ (void)addHTTPHeaderFieldValue:(NSDictionary *)keyValue;

/**
 *  remove the HTTP header field value
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
- (BOOL)checkResponseValueAvaliable:(NSDictionary *)values failure:(DDResponseFailureBlock)failure;

@end

```

##### DDModel.h

```
/**
 *  set the parse node, every subclass override the method if you want parse any node
 *
 *  @return node
 */
+ (NSString *)parseNode;

/**
 *  handle the mappings about the json key-value transform to a model object.
    The method support for KeyPathValue. e.g. you have a  @property name, you want get value from "{user:{name:'mike',id:10011},picture:'https://xxxx/headerimage/header01.jpg'}", you just set mapping dictionary is @{@"user.name":@"name"}.
 *
 *  @return mappings
 */
+ (NSDictionary *)parseMappings;

/**
 *  Get json data from http server by HTTP GET Mehod.
 *
 *  @param path           HTTP Path
 *  @param params         GET Paramtters
 *  @param show           is show the HUD on the view
 *  @param viewController parentViewController
 *  @param success        success block
 *  @param failure        failre block
 *
 */
+ (void)get:(NSString *)path
     params:(id)params
    showHUD:(BOOL)show
parentViewController:(id)viewController
    success:(DDResponseSuccessBlock)success
    failure:(DDResponseFailureBlock)failure;

/**
 *  Get json data from http server by HTTP POST Mehod.
 *
 *  @param path           HTTP Path
 *  @param params         GET Paramtters
 *  @param show           is show the HUD on the view
 *  @param viewController parentViewController
 *  @param success        success block
 *  @param failure        failre block
 *
 */
+ (void)post:(NSString *)path
      params:(id)params
     showHUD:(BOOL)show
parentViewController:(id)viewController
     success:(DDResponseSuccessBlock)success
     failure:(DDResponseFailureBlock)failure;

/**
 *  Upload a data stream to http server by HTTP POST Method.
 *
 *  @param path           HTTP Path
 *  @param stream         stream data
 *  @param params         POST Parameters
 *  @param userInfo       userInfo dictionary
 *  @param show           is show the HUD on the view
 *  @param viewController parentViewController
 *  @param success        success block
 *  @param failure        failure block
 */
+ (void)post:(NSString *)path
  fileStream:(NSData *)stream
      params:(id)params
    userInfo:(id)userInfo
     showHUD:(BOOL)show
parentViewController:(id)viewController
     success:(DDUploadReponseSuccessBlock)success
     failure:(DDResponseFailureBlock)failure;

/**
 *  cancel all the request in the viewController.
 *
 *  @param viewController viewcontroller
 */
+ (void)cancelRequest:(id)viewController;

/**
 *  Prase self entity into a dictionary
 *
 *  @return a dictionary of self entity
 */
- (NSDictionary *)propertiesOfObject;
```

## Updates

- 0.3 add the xml parser function
- 0.2 add the function of check api business logic 

## Requirements

- Xcode 6
- iOS 5.1.1 or Mac OSX 10.8

## Author

DeJohn Dong, dongjia_9251@126.com

## License

DDModel is available under the MIT license. See the LICENSE file for more info.
