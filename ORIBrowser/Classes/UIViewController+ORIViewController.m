#import "UIViewController+ORIViewController.h"

#import <ORI/ORI.h>

#import "FlipViewController.h"

#import "ClassViewController.h"
#import "ProtocolViewController.h"
#import "MethodViewController.h"
#import "HeaderViewController.h"

@implementation UIViewController (ORIViewController)

+ (UIViewController*)viewControllerWithORIObject:(id)object {
	if([object isKindOfClass:[ORIClass class]]) {
		ORIClass* cls = (ORIClass*)object;
		
		ClassViewController* classViewController = [[[ClassViewController alloc] initWithORIClass:cls] autorelease];
		HeaderViewController* headerViewController = [[[HeaderViewController alloc] initWithORIClass:cls] autorelease];
		
		FlipViewController* flipViewController = [[[FlipViewController alloc] initWithViewFrontViewController:classViewController backViewController:headerViewController] autorelease];
		flipViewController.frontButtonTitle = @"≣";
		flipViewController.backButtonTitle = @".h";

		return flipViewController;
	}
	
	if([object isKindOfClass:[ORIProtocol class]]) {
		ORIProtocol* protocol = (ORIProtocol*)object;
		
		ProtocolViewController* procotolViewController = [[[ProtocolViewController alloc] initWithORIProtocol:protocol] autorelease];
		HeaderViewController* headerViewController = [[[HeaderViewController alloc] initWithORIProtocol:protocol] autorelease];
		
		FlipViewController* flipViewController = [[[FlipViewController alloc] initWithViewFrontViewController:procotolViewController backViewController:headerViewController] autorelease];
		flipViewController.frontButtonTitle = @"≣";
		flipViewController.backButtonTitle = @".h";
		
		return flipViewController;
	}
	
	return nil;
}

@end
