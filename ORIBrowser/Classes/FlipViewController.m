#import "FlipViewController.h"

@interface FlipViewController () {
	UIViewController* _frontViewController;
	UIViewController* _backViewController;
	
	UIViewController* _visibleViewController;
}

@property (nonatomic, readonly) UIViewController* invisibleViewController;

@property (nonatomic, assign) BOOL flipped;

@end


@implementation FlipViewController

@synthesize flipped;

@synthesize frontAnimation;
@synthesize backAnimation;

@synthesize frontButtonTitle;
@synthesize backButtonTitle;


- (id)init {
	self = [super init];
	if(self != nil) {
#if 1
		self.frontAnimation = UIViewAnimationOptionTransitionFlipFromLeft;
		self.backAnimation = UIViewAnimationOptionTransitionFlipFromRight;
#else
		self.frontAnimation = UIViewAnimationOptionTransitionCurlDown;
		self.backAnimation = UIViewAnimationOptionTransitionCurlUp;
#endif
		
		self.frontButtonTitle = @"Front";
		self.backButtonTitle = @"Back";
	}
	return self;
}

- (id)initWithViewFrontViewController:(UIViewController*)frontViewController backViewController:(UIViewController*)backViewController {
	self = [self init];
	if(self != nil) {
		self.frontViewController = frontViewController;
		self.backViewController = backViewController;
		
		self.title = self.frontViewController.title;
	}
	return self;
}

- (void)dealloc {
	self.frontViewController = nil;
	self.backViewController = nil;
	
	self.frontButtonTitle = nil;
	self.backButtonTitle = nil;
	
	[super dealloc];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	UIBarButtonItem* barButtonItem = [[[UIBarButtonItem alloc] initWithTitle:self.flipped ? self.frontButtonTitle : self.backButtonTitle style:UIBarButtonItemStyleBordered target:self action:@selector(flip:)] autorelease];
	
	NSArray* array = self.visibleViewController.navigationItem.rightBarButtonItems;
	array = [array arrayByAddingObject:barButtonItem];
	self.navigationItem.rightBarButtonItems = array;
	
	{
		NSMutableArray* items = [NSMutableArray array];
		[items addObject:barButtonItem];
		NSArray* oldItems = self.visibleViewController.navigationItem.rightBarButtonItems;
		if(oldItems) {
			[items addObjectsFromArray:oldItems];
		}
		self.navigationItem.rightBarButtonItems = items;
	}

	UIViewController* visibleViewController = self.visibleViewController;
	visibleViewController.view.frame = self.view.bounds;
	visibleViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:visibleViewController.view];
}

- (void)viewDidUnload {
	[super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	// CHECK: test both?
	return [self.frontViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation] && [self.backViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (IBAction)flip:(id)sender {
	[self flipAnimated:YES];
}

- (void)flipAnimated:(BOOL)animated {
	// View is loaded. viewDidLoad will perform actions
	if(![self isViewLoaded]) {
		self.flipped = !self.flipped;
		return;
	}

	
	UIViewController* visibleViewController = self.visibleViewController;
	UIViewController* invisibleViewController = self.invisibleViewController;

	invisibleViewController.view.frame = self.view.bounds;
	invisibleViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	self.title = invisibleViewController.title;
	self.navigationItem.titleView = invisibleViewController.navigationItem.titleView;
	UIBarButtonItem* barButtonItem = [[[UIBarButtonItem alloc] initWithTitle:self.flipped ? self.backButtonTitle : self.frontButtonTitle style:UIBarButtonItemStyleBordered target:self action:@selector(flip:)] autorelease];

	{
		NSMutableArray* items = [NSMutableArray array];
		[items addObject:barButtonItem];
		NSArray* oldItems = (self.flipped ? self.frontViewController : self.backViewController).navigationItem.rightBarButtonItems;
		if(oldItems) {
			[items addObjectsFromArray:oldItems];
		}
		[self.navigationItem setRightBarButtonItems:items animated:animated];
	}

	[self.view addSubview:invisibleViewController.view];

	
	if(animated) {		
		UIViewAnimationOptions animation = self.flipped ? self.frontAnimation : self.backAnimation;
		animation |= UIViewAnimationOptionBeginFromCurrentState;
		
		[UIView transitionFromView:visibleViewController.view toView:invisibleViewController.view duration:0.5f options:animation completion:^(BOOL finished) {
			if(finished) {
				[visibleViewController.view removeFromSuperview];
			}
		}];
		
	} else {
		[visibleViewController.view removeFromSuperview];
	}

	self.flipped = !self.flipped;
}

@synthesize frontViewController = _frontViewController;

- (void)setFrontViewController:(UIViewController*)value {
	if(_frontViewController != value) {
		[_frontViewController release];
		_frontViewController = value;
		[_frontViewController retain];
		
		if(_frontViewController) {
			[self addChildViewController:_frontViewController];
		}
	}
}

@synthesize backViewController = _backViewController;

- (void)setBackViewController:(UIViewController*)value {
	if(_backViewController != value) {
		[_backViewController release];
		_backViewController = value;
		[_backViewController retain];
		
		if(_backViewController) {
			[self addChildViewController:_backViewController];
		}
	}
}

- (UIViewController*)visibleViewController {
	if(self.flipped) {
		return self.backViewController;
	} else {
		return self.frontViewController;
	}
}

- (UIViewController*)invisibleViewController {
	if(self.flipped) {
		return self.frontViewController;
	} else {
		return self.backViewController;
	}
}

@end
