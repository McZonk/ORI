#import "StatusBarAwareTabBarController.h"


@implementation StatusBarAwareTabBarController

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	
#if 0
	if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
		[[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
	} else {
		[[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO];
	}
#endif
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

@end
