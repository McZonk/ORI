#import "NSBundle+LoadedClasses.h"

static NSMutableDictionary* NSBundleLoadedClasses = nil;




@implementation NSBundle (LoadedClasses)

+ (void)setupLoadedClasses {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSBundleLoadedClasses = [[NSMutableDictionary alloc] initWithCapacity:20];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bundleDidLoadNotification:) name:NSBundleDidLoadNotification object:nil];
	});
}

+ (void)bundleDidLoadNotification:(NSNotification*)notification {
	NSBundle* bundle = (NSBundle*)notification.object;
	NSArray* loadedClasses = [notification.userInfo objectForKey:NSLoadedClasses];
	
	if(loadedClasses.count > 0) {
		@synchronized(NSBundleLoadedClasses) {
			[NSBundleLoadedClasses setObject:loadedClasses forKey:bundle.bundlePath];
		}
	}
}

- (NSArray*)loadedClasses {
	@synchronized(NSBundleLoadedClasses) {
		return [NSBundleLoadedClasses objectForKey:self.bundlePath];
	}
}

@end
