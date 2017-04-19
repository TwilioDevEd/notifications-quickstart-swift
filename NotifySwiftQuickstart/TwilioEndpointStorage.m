//
//  TwilioEndpointStorage.mm
//  NotifySwiftQuickstart
//
//  Created by Viktor Muller on 4/19/17.
//  Copyright © 2017 Twilio, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "TwilioEndpointStorage.h"
#include <iostream>

#define KEYCHAIN_SERVICE_NAME "Twilio-Notify"
#define LOG_NAME "Notify-iOS"

/*
TwilioEndpointStorage::TwilioEndpointStorage()
{
    
}
*/
interface TwilioEndpointStorage ()
@end

@implementation TwilioEndpointStorage


CFMutableDictionaryRef queryForAccount(NSString *account) {
    CFMutableDictionaryRef query = CFDictionaryCreateMutable(NULL,
                                                             0,
                                                             &kCFTypeDictionaryKeyCallBacks,
                                                             &kCFTypeDictionaryValueCallBacks);
    CFDictionaryAddValue(query, kSecClass, kSecClassGenericPassword);
    CFDictionaryAddValue(query, kSecAttrService, (__bridge CFStringRef)@KEYCHAIN_SERVICE_NAME);
    CFDictionaryAddValue(query, kSecAttrAccount, (__bridge CFStringRef)account);
    
    return query;
}

NSString *endpointForKey(NSString *key) {
    NSString *endpoint = nil;
    
    CFMutableDictionaryRef query = queryForAccount(key);
    
    CFDictionaryAddValue(query, kSecReturnData, kCFBooleanTrue);
    CFStringRef cfresult = NULL;
    OSStatus status = SecItemCopyMatching(query, (CFTypeRef *)&cfresult);
    CFRelease(query);
    
    if (status != errSecItemNotFound) {
        endpoint = [[NSString alloc] initWithData:(__bridge_transfer NSData *)cfresult
                                      encoding:NSUTF8StringEncoding];
    }
    
    return endpoint;
}


NSString* fetchEndpoint() {
    NSString *key = @"default";
    NSString *ret = @"";// _endpoints[key];
    
    //   if (ret.empty()) {
    NSString *localKey = key;
    NSString *localEndpoint = endpointForKey(localKey);
    if (localEndpoint) {
        ret = localEndpoint;
        //     }
    }
    
    return ret;
}

void saveEndpoint(NSString *key, NSString *endpoint) {
    CFMutableDictionaryRef query = queryForAccount(key);
    
    NSData *data = [endpoint dataUsingEncoding:NSUTF8StringEncoding];
    CFDictionaryAddValue(query, kSecValueData, (__bridge CFDataRef)data);
    CFDictionaryAddValue(query, kSecAttrAccessible, kSecAttrAccessibleWhenUnlocked);
    OSStatus status = 0;
    if (endpointForKey(key) != nil) {
        status = SecItemDelete(query);
        if (status != noErr) {
            CFRelease(query);
            return;
        }
    }
    
    status = SecItemAdd(query, NULL);
    CFRelease(query);
    if (status != noErr) {
    }
}

void storeEndpoint(NSString *endpoint) {
    std::string key = "default";
    
    //_endpoints[key] = endpoint;
    
    NSString *localKey = [NSString stringWithUTF8String:key.c_str()];
    NSString *localEndpoint = endpoint;
    
    saveEndpoint(localKey, localEndpoint);
}
