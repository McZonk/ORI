#import "ImageViewController.h"


@implementation ImageViewController

- (id)initWithPath:(NSString*)path {
	self = [super init];
	if(self != nil) {
		self.path = path;
		
		self.title = [self.path lastPathComponent];
		
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveImage:)] autorelease];
	}
	return self;
}

- (void)dealloc {
	self.imageScrollView = nil;
	
	self.path = nil;
	
	[super dealloc];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.imageScrollView.decelerationRate = UIScrollViewDecelerationRateFast;
	
	UIImage* image = [UIImage imageWithContentsOfFile:self.path];

	self.imageScrollView.image = image;
}

- (void)viewDidUnload {
	[super viewDidUnload];
	
	self.imageScrollView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}

- (IBAction)saveImage:(id)sender {
	UIImage* image = self.imageScrollView.image;
	if(image) {
		UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
	}
}

@synthesize path = _path;

@synthesize imageScrollView = _imageScrollView;

@end
