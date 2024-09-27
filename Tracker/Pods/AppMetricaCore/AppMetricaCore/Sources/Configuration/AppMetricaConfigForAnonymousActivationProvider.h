
#import <Foundation/Foundation.h>

@class AppMetricaDefaultAnonymousConfigProvider;
@class AMAMetricaPersistentConfiguration;
@class AMAAppMetricaConfiguration;

@interface AppMetricaConfigForAnonymousActivationProvider : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithStorage:(AMAMetricaPersistentConfiguration *)persistent;
- (instancetype)initWithStorage:(AMAMetricaPersistentConfiguration *)persistent
                defaultProvider:(AppMetricaDefaultAnonymousConfigProvider *)defaultProvider;

- (AMAAppMetricaConfiguration *)configuration;

@end
