#import "FrameworkViewController.h"

#import "BundleCell.h"

#import "BrowserViewController.h"

#import "NSBundle+LoadedClasses.h"


@interface FrameworkViewController ()

@property (nonatomic, retain) NSArray* frameworks;
@property (nonatomic, retain) NSArray* privateFrameworks;

@end


@implementation FrameworkViewController

- (void)setup {
	self.title = @"Frameworks";
	
	{
		NSMutableArray* array = [NSMutableArray array];
		
		NSString* path = @"/System/Library/Frameworks/";
		NSArray* files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
		for(NSString* file in files) {
			NSBundle* bundle = [NSBundle bundleWithPath:[path stringByAppendingPathComponent:file]];
			[array addObject:bundle];
		}
		
		self.frameworks = array;
	}
	
	{
		NSMutableArray* array = [NSMutableArray array];
	
		NSString* path = @"/System/Library/PrivateFrameworks/";
		NSArray* files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
		for(NSString* file in files) {
			NSBundle* bundle = [NSBundle bundleWithPath:[path stringByAppendingPathComponent:file]];
			[array addObject:bundle];
		}
		
		self.privateFrameworks = array;
	}
}

- (id)initWithCoder:(NSCoder*)coder {
	self = [super initWithCoder:coder];
	if(self != nil) {
		[self setup];
	}
	return self;
}

- (void)dealloc {
	self.searchDisplayController.delegate = nil;

	self.frameworks = nil;
	self.privateFrameworks = nil;

	[super dealloc];
}

@synthesize frameworks;
@synthesize privateFrameworks;


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}

#pragma mark -
#pragma mark UITableViewDataSource / UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
	if(section == 0) {
		return self.frameworks.count;
	}
	if(section == 1) {
		return self.privateFrameworks.count;
	}
	return 0;
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
	if(section == 0) {
		return @"Public Frameworks";
	}
	if(section == 1) {
		return @"Private Frameworks";
	}
	return nil;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	BundleCell* cell = (BundleCell*)[tableView dequeueReusableCellWithIdentifier:[BundleCell reuseIdentifier]];
	if(cell == nil) {
		cell = [BundleCell cell];
	}
	
	if(indexPath.section == 0) {
		cell.bundle = [self.frameworks objectAtIndex:indexPath.row];
	} else if(indexPath.section == 1) {
		cell.bundle = [self.privateFrameworks objectAtIndex:indexPath.row];
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	NSBundle* bundle = nil;
	if(indexPath.section == 0) {
		bundle = [self.frameworks objectAtIndex:indexPath.row];
	} else if(indexPath.section == 1) {
		bundle = [self.privateFrameworks objectAtIndex:indexPath.row];
	}
	
	if(bundle == nil) {
		return;
	}
	
	if([[bundle bundleIdentifier] isEqualToString:@"com.apple.Foundation"] || [[bundle bundleIdentifier] isEqualToString:@"com.apple.UIKit"] || [[bundle bundleIdentifier] isEqualToString:@"com.apple.CoreGraphics"]) {
		[[[[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@ cannot be unloaded it is needed by the system.", [bundle bundleIdentifier]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
		return;
	}
	
	if(![bundle isLoaded]) {
		NSError* error = nil;
		if(![bundle loadAndReturnError:&error]) {
			[[[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
		}

		[[NSNotificationCenter defaultCenter] postNotificationName:@"ObjectListDidChangeNotification" object:nil];
		
		// a bundle can depend on anthoer one so the whole table might change
		[self.tableView reloadData];

		return;
	}
	
	NSArray* loadedClasses = [bundle loadedClasses];
	
	BrowserViewController* viewController = [[[BrowserViewController alloc] initWithPreset:loadedClasses] autorelease];
	viewController.title = bundle.bundlePath.lastPathComponent;
	[self.navigationController pushViewController:viewController animated:YES];
}

@end
