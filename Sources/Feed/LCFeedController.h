#import <Cocoa/Cocoa.h>

@interface LCFeedController : NSObject

+ (BOOL)isPubSubAvailable;
- (NSString *)nativeFeedBackendName;

@end

