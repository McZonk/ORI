#import "MethodViewController.h"


@interface MethodViewController ()

@property (nonatomic, retain) NSArray* classes;

- (void)updateData;

@end


@implementation MethodViewController

- (id)initWithORIMethod:(ORIMethod*)method {
	self = [super init];
	if(self != nil) {
		self.method = method;
		
		self.title = self.method.name;
		
		[self updateData];
	}
	return self;
}

- (void)dealloc {
	self.method = nil;
	self.classes = nil;
	
	[super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}

- (void)updateData {
	
	
#if 0
	NSSet* classes = [ORIClass ORIClasses];
	
	NSMutableArray* result = [NSMutableArray array];
	for(ORIClass* class in classes) {
		if([class.ORIMethods containsObject:self.method]) {
			[result addObject:class];
		}
	}
	
	self.classes = [result sortedArrayUsingDescriptors:[NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease]]];
	
	NSLog(@"%@", self.classes);
	
	if([self isViewLoaded]) {
		[self.tableView reloadData];
	}
#endif
}

#pragma mark -
#pragma mark UITableViewDataSource / UITableViewDelegate

@synthesize method = _method;
@synthesize classes = _classes;

@end
