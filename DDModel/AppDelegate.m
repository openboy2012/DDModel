//
//  AppDelegate.m
//  DDModel
//
//  Created by DeJohn Dong on 15-2-4.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import "AppDelegate.h"
#import "DDModelKit.h"
#import "AFHTTPRequestOperationManager+DDAddition.h"

static OSStatus RNSecTrustEvaluateAsX509(SecTrustRef trust,
                                         SecTrustResultType *result
                                         )
{
    OSStatus status = errSecSuccess;
    SecPolicyRef policy = SecPolicyCreateBasicX509();
    SecTrustRef newTrust;
    CFIndex numberOfCerts = SecTrustGetCertificateCount(trust);
    CFMutableArrayRef certs;
    certs = CFArrayCreateMutable(NULL,
                                 numberOfCerts,
                                 &kCFTypeArrayCallBacks);
    for (NSUInteger index = 0; index < numberOfCerts; ++index) {
        SecCertificateRef cert;
        cert = SecTrustGetCertificateAtIndex(trust, index);
        CFArrayAppendValue(certs, cert);
    }
    status = SecTrustCreateWithCertificates(certs,
                                            policy,
                                            &newTrust);
    if (status == errSecSuccess) {
        status = SecTrustEvaluate(newTrust, result);
    }
    CFRelease(policy);
    CFRelease(newTrust);
    CFRelease(certs);
    
    return status;
}

@interface AppDelegate ()<DDHttpClientDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
#if UseXMLDemo
    [DDModelHttpClient startWithURL:@"http://prov.mobile.arnd.fm" delegate:self];
    [DDModelHttpClient sharedInstance].type = DDResponseXML;
#else
    [DDModelHttpClient startWithURL:@"http://mapi.bstapp.cn" delegate:self];
    [[DDModelHttpClient sharedInstance] dd_setWillSendRequestForAuthenticationChallengeBlock:^(NSURLConnection *connection, NSURLAuthenticationChallenge *challenge) {
        NSURLProtectionSpace *protSpace = challenge.protectionSpace;
        SecTrustRef trust = protSpace.serverTrust;
        SecTrustResultType result = kSecTrustResultFatalTrustFailure;
        
        OSStatus status = SecTrustEvaluate(trust, &result);
        if (status == errSecSuccess &&
            result == kSecTrustResultRecoverableTrustFailure) {
            SecCertificateRef cert = SecTrustGetCertificateAtIndex(trust,
                                                                   0);
            CFStringRef subject = SecCertificateCopySubjectSummary(cert);
            
            CFRange range = CFStringFind(subject, CFSTR(".shipin7.com"),
                                         kCFCompareAnchored|
                                         kCFCompareBackwards);
            if (range.location != kCFNotFound) {
                status = RNSecTrustEvaluateAsX509(trust, &result);
            }
            CFRelease(subject);
        }
        if (status == errSecSuccess) {
            switch (result) {
                case kSecTrustResultInvalid:
                case kSecTrustResultDeny:
                case kSecTrustResultFatalTrustFailure:
                case kSecTrustResultOtherError:
                case kSecTrustResultRecoverableTrustFailure:
                    // 证书有问题
                    NSLog(@"证书有问题");
                    [challenge.sender cancelAuthenticationChallenge:challenge];
                    break;
                    
                case kSecTrustResultProceed:
                case kSecTrustResultUnspecified: {
                    NSURLCredential *cred;
                    cred = [NSURLCredential credentialForTrust:trust];
                    [challenge.sender useCredential:cred
                         forAuthenticationChallenge:challenge];
                }
                    break;
                    
                default:
                    break;
            }
        }
        else {
            // 证书有问题
            NSLog(@"证书有问题");
            [challenge.sender cancelAuthenticationChallenge:challenge];
        }
    }];
#endif

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - DDClient Delegate Methods

- (NSDictionary *)encodeParameters:(NSDictionary *)params{
    // handler the encode parameters
    //// TODO 
    return params;
}

- (NSString *)decodeResponseString:(NSString *)responseString{
//    NSLog(@"responseString = %@",responseString);
    return responseString;
}


#pragma mark - Custom Methods

- (NSString *)ddEncode:(NSDictionary *)parameters{
    NSMutableArray *strings = [[NSMutableArray alloc] init];
    for (id key in [parameters.allKeys
                    sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
                    {
                        return [obj1 compare:obj2 options:NSNumericSearch];
                    }]
         ) {
        [strings addObject:[NSString stringWithFormat:@"%@=%@",key,parameters[key]]];
    }
    return [strings componentsJoinedByString:@"&"];
}

@end
