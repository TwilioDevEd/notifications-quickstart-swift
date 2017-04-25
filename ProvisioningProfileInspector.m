//
//  ProvisioningProfileInspector.m
//  NotifySwiftQuickstart
//
//  Created by Viktor Muller on 11/29/16.
//  Copyright © 2016 Twilio, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ProvisioningProfileInspector.h"

@interface ProvisioningProfileInspector ()
@property (nonatomic, strong) NSDictionary *provisioningProfileInfo;
@end

@implementation ProvisioningProfileInspector

- (instancetype)init {
    self = [super init];
    
    if (self != nil) {
        self.provisioningProfileInfo = [self loadProvisioningProfileInfo];
    }
    
    return self;
}

- (NSDictionary *)dictionary {
    NSDictionary *newDictionary = nil;
    
    if (self.provisioningProfileInfo != nil) {
        newDictionary = [NSDictionary dictionaryWithDictionary:self.provisioningProfileInfo];
    }
    
    return newDictionary;
}

- (APNSEnvironment)APNSEnvironment
{
    APNSEnvironment env = APNSEnvironmentUnknown;
    
    if (self.provisioningProfileInfo[@"Entitlements"] != nil) {
        NSString *environmentString = nil;
        
        if (self.provisioningProfileInfo[@"Entitlements"][@"com.apple.developer.aps-environment"] != nil) {
            environmentString = self.provisioningProfileInfo[@"Entitlements"][@"com.apple.developer.aps-environment"];
        } else if (self.provisioningProfileInfo[@"Entitlements"][@"aps-environment"] != nil) {
            environmentString = self.provisioningProfileInfo[@"Entitlements"][@"aps-environment"];
        }
        
        if ([[environmentString lowercaseString] isEqualToString:@"production"]) {
            env = APNSEnvironmentProduction;
        } else if ([[environmentString lowercaseString] isEqualToString:@"development"]) {
            env = APNSEnvironmentDevelopment;
        }
    }
    
    return env;
}

- (NSDictionary *)loadProvisioningProfileInfo {
    NSDictionary *provisioningProfileInfo = nil;
    
    NSString *provisioningProfilePath = [[NSBundle mainBundle] pathForResource:@"embedded" ofType:@"mobileprovision"];
    
    if (provisioningProfilePath != nil) {
        NSError *error = nil;
        NSString *signedDataString = [NSString stringWithContentsOfFile:provisioningProfilePath encoding:NSISOLatin1StringEncoding error:&error];
        
        if (error == nil) {
            NSRange startRange = [signedDataString rangeOfString:@"<?xml"];
            NSRange endRange = [signedDataString rangeOfString:@"</plist>"];
            
            if ((startRange.location != NSNotFound) && (endRange.location != NSNotFound)) {
                NSRange  plistRange = NSMakeRange(startRange.location, endRange.location + 8 - startRange.location);
                NSString *trimmedString = [signedDataString substringWithRange:plistRange];
                NSData   *trimmedData = [trimmedString dataUsingEncoding:NSUTF8StringEncoding];
                
                provisioningProfileInfo = [NSPropertyListSerialization propertyListWithData:trimmedData
                                                                                    options:NSPropertyListImmutable
                                                                                     format:NULL
                                                                                      error:&error];
            }
        }
        
        if ((provisioningProfileInfo == nil) && (error != nil)) {
            NSLog(@"Error: %@", error);
        }
    }
    
    return provisioningProfileInfo;
}

@end
