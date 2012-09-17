#import <Foundation/Foundation.h>

#import <ORI/ORI.h>


extern NSString* const FavoritesStoreDidAddORIClassNotification;
extern NSString* const FavoritesStoreDidAddORIProtocolNotification;

extern NSString* const FavoritesStoreDidRemoveORIClassNotification;
extern NSString* const FavoritesStoreDidRemoveORIProtocolNotification;


@interface FavoritesStore : NSObject

+ (FavoritesStore*)sharedFavoritesStore;

- (void)addORIClass:(ORIClass*)cls;
- (void)addORIProtocol:(ORIProtocol*)protocol;

- (void)removeORIClass:(ORIClass*)cls;
- (void)removeORIProtocol:(ORIProtocol*)protocol;

- (BOOL)isFavoriteORIClass:(ORIClass*)cls;
- (BOOL)isFavoriteORIProtocol:(ORIProtocol*)protocol;

@end
