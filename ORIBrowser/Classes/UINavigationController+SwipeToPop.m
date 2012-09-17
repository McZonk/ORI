#import "UINavigationController+SwipeToPop.h"

@implementation UINavigationController (SwipeToPop)

- (void)setupSwipeToPop {
	UISwipeGestureRecognizer* recognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(_swipeToPopGestureRecognizer:)] autorelease];
	recognizer.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
	[self.navigationBar addGestureRecognizer:recognizer];
}

- (void)_swipeToPopGestureRecognizer:(UISwipeGestureRecognizer*)reconizer {
	[self popToRootViewControllerAnimated:YES];
}

@end
