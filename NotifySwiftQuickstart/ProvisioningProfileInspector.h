//
//  ProvisioningProfileInspector.h
//  NotifySwiftQuickstart
//
//  Created by Viktor Muller on 11/29/16.
//  Copyright © 2016 Twilio, Inc. All rights reserved.
//

#ifndef ProvisioningProfileInspector_h
#define ProvisioningProfileInspector_h

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSUInteger, APNSEnvironment)
{
    APNSEnvironmentUnknown,
    APNSEnvironmentDevelopment,
    APNSEnvironmentProduction
};

@interface ProvisioningProfileInspector : NSObject

- (NSDictionary *)dictionary;

- (APNSEnvironment)APNSEnvironment;

@end

#endif /* ProvisioningProfileInspector_h */
