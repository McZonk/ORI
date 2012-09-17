#import "ORIBrowserAppDelegate.h"

#import "UINavigationController+SwipeToPop.h"

#import "NSBundle+LoadedClasses.h"

@implementation ORIBrowserAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[NSBundle setupLoadedClasses];
	
	UITabBarController* tabBarController = (UITabBarController*)self.rootViewController;
	for(UIViewController* viewController in tabBarController.viewControllers) {
		if([viewController isKindOfClass:[UIViewController class]]) {
			UINavigationController* navigationController = (UINavigationController*)viewController;
			[navigationController setupSwipeToPop];
		}
	}
	
	[self.window addSubview:self.rootViewController.view];
	[self.window makeKeyWindow];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
}


- (void)applicationWillTerminate:(UIApplication *)application {
}

- (void)dealloc {
	self.window = nil;
	self.rootViewController = nil;
	
	[super dealloc];
}

@synthesize window;
@synthesize rootViewController;


@end

