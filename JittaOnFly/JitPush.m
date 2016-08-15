//
//  JittaOnFly.m
//  JittaOnFly
//
//  Created by Yuttana Kungwon on 8/9/2559 BE.
//  Copyright © 2559 Jitta.com. All rights reserved.
//

#import "JitPush.h"
#import "RCTBridge.h"

NSString *const kBundlePayload = @"CurrentJSBundle";


@interface JitPush() <NSURLSessionDownloadDelegate, RCTBridgeModule>

@property NSURL *defaultBundleURL;
@property NSURL *defaultPayloadURL;
@property NSURL *_latestBundleURL;
@property NSURL *payloadURL;
@property BOOL showProgress;
@property BOOL allowCellularDataUse;
@property NSString *hostName;
@property JitPushUpdateType updateType;
@property NSDictionary *updatedPayloadData;
@property BOOL isInitialize;

@end

@implementation JitPush

RCT_EXPORT_MODULE()

static bool isFirstTime = YES;

+ (id)sharedManager
{
    static JitPush *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isFirstTime = NO;
        _sharedManager = [[self alloc] init];
        [_sharedManager defaults];
    });

    
    return _sharedManager;
}

- (void)defaults
{
    self.showProgress = YES;
    self.allowCellularDataUse = NO;
    self.updateType = JitPushMinorUpdate;
}

#pragma mark - JS methods

- (NSDictionary *)constantsToExport {
    NSDictionary *payload = [[NSUserDefaults standardUserDefaults] objectForKey:kBundlePayload];
    NSString *version = @"";
    if (payload) {
        version = [payload objectForKey:@"version"];
    }
    return @{ @"jsCodeVersion": version };
}

#pragma mark - initialize Singleton

- (void)initWithUpdatePayloadURL:(NSURL *)url defaultBundle:(NSURL *)bundleURL defaultPayload:(NSURL *)payloadURL
{
    self.payloadURL = url;
    self.defaultBundleURL = bundleURL;
    self.defaultPayloadURL = payloadURL;
    
    // compare payload data
    NSData *defaultPayloadData = [NSData dataWithContentsOfURL:self.defaultPayloadURL];
    [self compareStoredPayloadData:defaultPayloadData];
}

- (void)compareStoredPayloadData:(NSData *)defaultPayloadData
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    
    if (!defaultPayloadData) {
        NSLog(@"Don't have your default payload. plz check initialize default payload url");
        self.isInitialize = NO;
        return;
    }

    NSError *error;
    NSDictionary *localPayload = [NSJSONSerialization JSONObjectWithData:defaultPayloadData
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:&error];
    if (error) {
        NSLog(@"Wrong JSON file.");
        self.isInitialize = NO;
        return;
    }
    
    NSDictionary *storedPayload = [defaults objectForKey:kBundlePayload];
    if (!storedPayload) {
        // store it to UserDefault.
        [defaults setObject:localPayload forKey:kBundlePayload];
    } else {
        // check compare version between old version (stored in USERDEFAULT) and new version (local default payload file)
        id storedPayloadVersion = [storedPayload objectForKey:@"version"];
        id localPayloadVersion = [localPayload objectForKey:@"version"];
        
        // compare if stored version < local payload version
        if ([storedPayloadVersion compare:localPayloadVersion options:NSNumericSearch] == NSOrderedAscending) {
            //
        }
    }
}
@end
