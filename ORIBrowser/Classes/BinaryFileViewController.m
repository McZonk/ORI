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
	NSError *errorUTF8 = nil;
	self.textView.font = [UIFont systemFontOfSize:self.textView.font.pointSize];
	self.textView.text = [[NSString alloc]initWithContentsOfFile:self.file encoding:NSUTF8StringEncoding error:&errorUTF8];
	if (errorUTF8) {
		NSError *errorASCII = nil;
		self.textView.text = [[NSString alloc]initWithContentsOfFile:self.file encoding:NSASCIIStringEncoding error:&errorASCII];
		if (errorASCII) {
			self.textView.text = @"Could not parse file using UTF8 or ASCII";
			self.textView.font = [UIFont italicSystemFontOfSize:self.textView.font.pointSize];
		}
	}
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

