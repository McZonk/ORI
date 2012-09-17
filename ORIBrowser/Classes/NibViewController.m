#import "NibViewController.h"


@implementation NibViewController

- (id)initWithPath:(NSString*)path {
	self = [super init];
	if(self != nil) {
		self.path = path;
		
		self.title = [self.path lastPathComponent];
		
		@try {
//			UINib* nib = [[[UINib alloc] initWithContentsOfFile:self.path] autorelease];
			
//			NSLog(@"Nib: %@", nib);

//			NSArray* nibContents = [nib instantiateWithOwner:nil options:nil];
			
//			NSLog(@"Contents: %@", nibContents);
			
		} @catch(NSException* e) {
			[[[[UIAlertView alloc] initWithTitle:NSStringFromClass([e class]) message:[e description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
		}
	}
	return self;
}

- (void)dealloc {
	self.path = nil;
	
	[super dealloc];
}

@synthesize path = _path;

@end
