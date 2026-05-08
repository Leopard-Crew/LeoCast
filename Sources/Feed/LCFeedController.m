#import "LCFeedController.h"
#import <PubSub/PubSub.h>

@implementation LCFeedController

+ (BOOL)isPubSubAvailable
{
    return NSClassFromString(@"PSClient") != Nil;
}

- (NSString *)nativeFeedBackendName
{
    if ([[self class] isPubSubAvailable]) {
        return @"PubSub.framework";
    }

    return @"Unavailable";
}

@end

