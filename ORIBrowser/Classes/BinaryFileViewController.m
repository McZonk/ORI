#import "BinaryFileViewController.h"

@interface BinaryFileViewController ()

@end


@implementation BinaryFileViewController

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
	
	self.textView.text = [[[NSString alloc] initWithData:[NSData dataWithContentsOfFile:self.file] encoding:NSUTF8StringEncoding] autorelease];
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

