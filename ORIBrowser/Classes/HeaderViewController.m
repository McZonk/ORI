#import "HeaderViewController.h"

@interface HeaderViewController () {
	ORIClass* _cls;
	ORIProtocol* _protocol;
	
	UITextView* _textView;
}

@end

@implementation HeaderViewController

- (id)initWithORIClass:(ORIClass*)cls {
	self = [super initWithNibName:nil bundle:nil];
	if(self != nil) {
		self.cls = cls;
		
		self.title = self.cls.name;
		
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(saveToDocuments:)] autorelease];
	}
	return self;
}

- (id)initWithORIProtocol:(ORIProtocol*)protocol {
	self = [super initWithNibName:nil bundle:nil];
	if(self != nil) {
		self.protocol = protocol;
		
		self.title = self.protocol.name;

		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(saveToDocuments:)] autorelease];
	}
	return self;
}

- (void)dealloc {
	self.cls = nil;
	self.protocol= nil;
	
	self.textView = nil;
	
	[super dealloc];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	if(self.cls) {
		self.textView.text = self.cls.declaration;
	} else if(self.protocol) {
		self.textView.text = self.protocol.declaration;
	} else {
		self.textView.text = nil;
	}
}

- (void)viewDidUnload {
	[super viewDidUnload];
	
	self.textView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}

- (void)saveToDocuments:(id)sender {
	if(self.textView.text) {
		NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
		path = [path stringByAppendingPathComponent:self.title];
		path = [path stringByAppendingPathExtension:@"h"];
		
		[self.textView.text writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
	}
}

@synthesize cls = _cls;
@synthesize protocol = _protocol;

@synthesize textView = _textView;

@end
