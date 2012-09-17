#import "ActiveNavigationController.h"

static const NSUInteger MenuMaxItems = 20;


@implementation ActiveNavigationController

- (id)initWithCoder:(NSCoder*)coder {
	self = [super initWithCoder:coder];
	if(self != nil) {

		[self.navigationBar addGestureRecognizer:[[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)] autorelease]];
		
	}
	return self;
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}

- (BOOL)canResignFirstResponder {
	return YES;
}

- (void)longPressGesture:(UIGestureRecognizer*)gestureRecognizer {
	if(gestureRecognizer.state == UIGestureRecognizerStateBegan) {
		[self becomeFirstResponder];
	
		NSMutableArray* items = [NSMutableArray arrayWithCapacity:MenuMaxItems];
		
		NSUInteger count = self.viewControllers.count - 1;

		NSUInteger index = 0;
		if(count > MenuMaxItems) {
			index = count - MenuMaxItems;
		}

		for(; index < count; index++) {
			UIViewController* viewController = [self.viewControllers objectAtIndex:index];

			SEL action = NSSelectorFromString([NSString stringWithFormat:@"pop%d:", count - index]);
			
//			NSLog(@"%@ %@", viewController.title, NSStringFromSelector(action));
			
			UIMenuItem* item = [[[UIMenuItem alloc] initWithTitle:viewController.title action:action] autorelease];
			
			[items addObject:item];
		}
		
		
		UIMenuController* controller = [UIMenuController sharedMenuController];
		controller.menuItems = items;
	
		[controller setTargetRect:self.navigationBar.frame inView:self.view];
		[controller setMenuVisible:YES animated:YES];
		
		return;
	}
	
	if(gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
//		[self resignFirstResponder];
		
		return;
	}
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
	return [self respondsToSelector:action];
}

- (void)pop:(int)count {
	
	NSInteger index = self.viewControllers.count - (1 + count);
	if(index < 0) {
		[self popToRootViewControllerAnimated:YES];
	} else {
		UIViewController* viewControler = [self.viewControllers objectAtIndex:index];
		[self popToViewController:viewControler animated:YES];
	}
	
}

- (void)pop1:(id)sender {
	[self pop:1];
}

- (void)pop2:(id)sender {
	[self pop:2];
}

- (void)pop3:(id)sender {
	[self pop:3];
}

- (void)pop4:(id)sender {
	[self pop:4];
}

- (void)pop5:(id)sender {
	[self pop:5];
}

- (void)pop6:(id)sender {
	[self pop:6];
}

- (void)pop7:(id)sender {
	[self pop:7];
}

- (void)pop8:(id)sender {
	[self pop:8];
}

- (void)pop9:(id)sender {
	[self pop:9];
}

- (void)pop10:(id)sender {
	[self pop:10];
}

- (void)pop11:(id)sender {
	[self pop:11];
}

- (void)pop12:(id)sender {
	[self pop:12];
}

- (void)pop13:(id)sender {
	[self pop:13];
}

- (void)pop14:(id)sender {
	[self pop:14];
}

- (void)pop15:(id)sender {
	[self pop:15];
}

- (void)pop16:(id)sender {
	[self pop:16];
}

- (void)pop17:(id)sender {
	[self pop:17];
}

- (void)pop18:(id)sender {
	[self pop:18];
}

- (void)pop19:(id)sender {
	[self pop:19];
}

- (void)pop20:(id)sender {
	[self pop:20];
}

@end
