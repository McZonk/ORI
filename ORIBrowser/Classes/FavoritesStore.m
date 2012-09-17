#import "FavoritesStore.h"


NSString* const FavoritesStoreDidAddORIClassNotification = @"FavoritesStoreDidAddORIClassNotification";
NSString* const FavoritesStoreDidAddORIProtocolNotification = @"FavoritesStoreDidAddORIProtocolNotification";

NSString* const FavoritesStoreDidRemoveORIClassNotification = @"FavoritesStoreDidRemoveORIClassNotification";
NSString* const FavoritesStoreDidRemoveORIProtocolNotification = @"FavoritesStoreDidRemoveORIProtocolNotification";


@interface FavoritesStore ()

@property (nonatomic, retain) NSMutableArray* favorites;

- (void)addFavoriteString:(NSString*)string;
- (void)removeFavoriteString:(NSString*)string;
- (BOOL)isFavoriteString:(NSString*)string;

@end


@implementation FavoritesStore

+ (FavoritesStore*)sharedFavoritesStore {
	static FavoritesStore* favoritesStore = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		favoritesStore = [[FavoritesStore alloc] init];
	});
	return favoritesStore;
}

- (id)init {
	self = [super init];
	if(self != nil) {
		self.favorites = [NSMutableArray array];
		
		NSArray* array = [[NSUserDefaults standardUserDefaults] arrayForKey:@"Favorites"];
		[self.favorites addObjectsFromArray:array];
	}
	return self;
}

- (void)dealloc {
	self.favorites = nil;
	
	[super dealloc];
}

- (void)addORIClass:(ORIClass*)cls {
	[self addFavoriteString:[cls description]];
	
	NSDictionary* userInfo = [NSDictionary dictionaryWithObject:cls forKey:@"ORIClass"];
	[[NSNotificationCenter defaultCenter] postNotificationName:FavoritesStoreDidAddORIClassNotification object:self userInfo:userInfo];
}

- (void)addORIProtocol:(ORIProtocol*)protocol {
	[self addFavoriteString:[protocol description]];

	NSDictionary* userInfo = [NSDictionary dictionaryWithObject:protocol forKey:@"ORIProtocol"];
	[[NSNotificationCenter defaultCenter] postNotificationName:FavoritesStoreDidAddORIProtocolNotification object:self userInfo:userInfo];
}

- (void)removeORIClass:(ORIClass*)cls {
	[self removeFavoriteString:[cls description]];

	NSDictionary* userInfo = [NSDictionary dictionaryWithObject:cls forKey:@"ORIClass"];
	[[NSNotificationCenter defaultCenter] postNotificationName:FavoritesStoreDidRemoveORIClassNotification object:self userInfo:userInfo];
}

- (void)removeORIProtocol:(ORIProtocol*)protocol {
	[self removeFavoriteString:[protocol description]];

	NSDictionary* userInfo = [NSDictionary dictionaryWithObject:protocol forKey:@"ORIProtocol"];
	[[NSNotificationCenter defaultCenter] postNotificationName:FavoritesStoreDidRemoveORIProtocolNotification object:self userInfo:userInfo];
}

- (BOOL)isFavoriteORIClass:(ORIClass*)cls {
	return [self isFavoriteString:[cls description]];
}

- (BOOL)isFavoriteORIProtocol:(ORIProtocol*)protocol {
	return [self isFavoriteString:[protocol description]];
}

- (void)addFavoriteString:(NSString*)string {
	if(![self.favorites containsObject:string]) {
		[self.favorites addObject:string];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

- (void)removeFavoriteString:(NSString*)string {
	[self.favorites removeObject:string];
}

- (BOOL)isFavoriteString:(NSString*)string {
	return [self.favorites containsObject:string];
}

@synthesize favorites;

@end
