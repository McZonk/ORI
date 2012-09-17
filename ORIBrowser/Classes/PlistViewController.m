#import "PlistViewController.h"

@interface PlistViewController ()

@end


@implementation PlistViewController

- (id)initWithFile:(NSString*)file {
	self = [super init];
	if(self != nil) {
		self.file = file;

		self.title = [self.file lastPathComponent];
	}
	return self;
}

- (void)dealloc {
	self.textView.text = nil;

	self.file = nil;
	
    [super dealloc];
}

- (void)viewDidLoad {
	[super viewDidLoad];

	id object = [NSPropertyListSerialization propertyListWithData:[NSData dataWithContentsOfFile:self.file] options:NSPropertyListImmutable format:nil error:nil]; 
	
	self.textView.text = [object description];
}
						  
- (void)viewDidUnload {
	[super viewDidUnload];
	
	self.textView.text = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}

@synthesize file = _file;

@synthesize textView;

@end
