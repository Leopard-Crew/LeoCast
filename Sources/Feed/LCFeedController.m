#import "LCFeedController.h"
#import <PubSub/PubSub.h>

@interface LCFeedController (Private)

- (NSArray *)subscriptionsForClient:(id)client;
- (NSDictionary *)dictionaryForFeed:(id)feed;

- (id)valueFromObject:(id)object selector:(SEL)selector;
- (NSString *)stringValueFromObject:(id)object selector:(SEL)selector fallback:(NSString *)fallback;
- (NSURL *)URLValueFromObject:(id)object selector:(SEL)selector;
- (NSArray *)arrayValueFromObject:(id)object selector:(SEL)selector;

- (void)clearLastError;
- (void)recordLastErrorWithContext:(NSString *)context exception:(NSException *)exception;

@end

@implementation LCFeedController

- (void)dealloc
{
    [_lastErrorMessage release];
    [super dealloc];
}

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

- (NSString *)lastErrorMessage
{
    return _lastErrorMessage;
}

- (NSArray *)applicationClientSubscriptions
{
    id client = nil;

    [self clearLastError];

    if (![[self class] isPubSubAvailable]) {
        return [NSArray array];
    }

    @try {
        client = [PSClient applicationClient];
    }
    @catch (NSException *exception) {
        [self recordLastErrorWithContext:@"Could not create PubSub application client"
                               exception:exception];
        return [NSArray array];
    }

    return [self subscriptionsForClient:client];
}

- (NSArray *)subscriptionsForBundleIdentifier:(NSString *)bundleIdentifier
{
    id client = nil;

    [self clearLastError];

    if (![[self class] isPubSubAvailable]) {
        return [NSArray array];
    }

    if (bundleIdentifier == nil || [bundleIdentifier length] == 0) {
        return [NSArray array];
    }

    @try {
        client = [PSClient clientForBundleIdentifier:bundleIdentifier];
    }
    @catch (NSException *exception) {
        [self recordLastErrorWithContext:@"Could not create PubSub client for bundle identifier"
                               exception:exception];
        return [NSArray array];
    }

    return [self subscriptionsForClient:client];
}

- (NSArray *)subscriptionsForClient:(id)client
{
    NSMutableArray *result = [NSMutableArray array];

    if (client == nil || ![client respondsToSelector:@selector(feeds)]) {
        return result;
    }

    @try {
        id feeds = [client performSelector:@selector(feeds)];

        if (![feeds respondsToSelector:@selector(objectEnumerator)]) {
            return result;
        }

        NSEnumerator *enumerator = [feeds objectEnumerator];
        id feed = nil;

        while ((feed = [enumerator nextObject]) != nil) {
            NSDictionary *dictionary = [self dictionaryForFeed:feed];

            if (dictionary != nil) {
                [result addObject:dictionary];
            }
        }
    }
    @catch (NSException *exception) {
        [self recordLastErrorWithContext:@"Could not read PubSub feeds"
                               exception:exception];
        return [NSArray array];
    }

    return result;
}

- (NSDictionary *)dictionaryForFeed:(id)feed
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    NSString *title = [self stringValueFromObject:feed selector:@selector(title) fallback:@""];
    NSURL *url = [self URLValueFromObject:feed selector:@selector(URL)];
    NSArray *entries = [self arrayValueFromObject:feed selector:@selector(entries)];

    [dictionary setObject:title forKey:@"title"];
    [dictionary setObject:[NSNumber numberWithUnsignedLong:[entries count]] forKey:@"entryCount"];

    if (url != nil) {
        [dictionary setObject:[url absoluteString] forKey:@"url"];
    } else {
        [dictionary setObject:@"" forKey:@"url"];
    }

    return dictionary;
}

- (id)valueFromObject:(id)object selector:(SEL)selector
{
    if (object == nil || ![object respondsToSelector:selector]) {
        return nil;
    }

    return [object performSelector:selector];
}

- (NSString *)stringValueFromObject:(id)object selector:(SEL)selector fallback:(NSString *)fallback
{
    id value = [self valueFromObject:object selector:selector];

    if ([value isKindOfClass:[NSString class]]) {
        return value;
    }

    if ([value respondsToSelector:@selector(stringValue)]) {
        return [value stringValue];
    }

    if ([value respondsToSelector:@selector(description)]) {
        return [value description];
    }

    return fallback;
}

- (NSURL *)URLValueFromObject:(id)object selector:(SEL)selector
{
    id value = [self valueFromObject:object selector:selector];

    if ([value isKindOfClass:[NSURL class]]) {
        return value;
    }

    if ([value isKindOfClass:[NSString class]]) {
        return [NSURL URLWithString:value];
    }

    return nil;
}

- (NSArray *)arrayValueFromObject:(id)object selector:(SEL)selector
{
    id value = [self valueFromObject:object selector:selector];

    if ([value isKindOfClass:[NSArray class]]) {
        return value;
    }

    if ([value isKindOfClass:[NSSet class]]) {
        return [value allObjects];
    }

    return [NSArray array];
}

- (void)clearLastError
{
    [_lastErrorMessage release];
    _lastErrorMessage = nil;
}

- (void)recordLastErrorWithContext:(NSString *)context exception:(NSException *)exception
{
    NSString *message = [NSString stringWithFormat:@"%@: %@",
        context,
        [exception reason] ? [exception reason] : [exception name]];

    [_lastErrorMessage release];
    _lastErrorMessage = [message copy];

    NSLog(@"LeoCast PubSub warning: %@", _lastErrorMessage);
}

@end
