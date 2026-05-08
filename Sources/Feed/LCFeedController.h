#import <Cocoa/Cocoa.h>

@interface LCFeedController : NSObject
{
@private
    NSString *_lastErrorMessage;
}

+ (BOOL)isPubSubAvailable;

- (NSString *)nativeFeedBackendName;
- (NSString *)lastErrorMessage;

- (NSArray *)applicationClientSubscriptions;
- (NSArray *)subscriptionsForBundleIdentifier:(NSString *)bundleIdentifier;

@end
