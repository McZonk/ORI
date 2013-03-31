#import "FrameworkViewController.h"

#import "BundleCell.h"

#import "BrowserViewController.h"

#import "NSBundle+LoadedClasses.h"

#import "NSString+InArray.h"


@interface FrameworkViewController ()

@property (nonatomic, retain) NSArray* frameworks;
@property (nonatomic, retain) NSArray* privateFrameworks;
@property (nonatomic, retain) NSMutableArray* frameworksFiltered;
@property (nonatomic, retain) NSMutableArray* privateFrameworksFiltered;

@property (nonatomic) BOOL automatedFrameworkLoadingInProgress;

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
	self.frameworks = nil;
	self.privateFrameworks = nil;
	self.frameworksFiltered = nil;
	self.privateFrameworksFiltered = nil;
	
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
	return 3;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
	if (tableView == self.tableView) {
		if (section == 0) {
			return 3;
		}
		else if (section == 1) {
			return self.frameworks.count;
		}
		else if (section == 2) {
			return self.privateFrameworks.count;
		}
	} else if (tableView == self.searchDisplayController.searchResultsTableView) {
		if (section == 0) {
			return 0;
		}
		else if (section == 1) {
			return self.frameworksFiltered.count;
		}
		else if (section == 2) {
			return self.privateFrameworksFiltered.count;
		}
	}
	return 0;
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
	if(section == 1) {
		return @"Public Frameworks";
	}
	if(section == 2) {
		return @"Private Frameworks";
	}
	return nil;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	BundleCell* cell = (BundleCell*)[tableView dequeueReusableCellWithIdentifier:[BundleCell reuseIdentifier]];
	if(cell == nil) {
		cell = [BundleCell cell];
	}
	
	if (tableView == self.tableView) {
		if(indexPath.section == 0) {
			UITableViewCell *basicCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
			if (basicCell == nil) {
				basicCell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"]autorelease];
			}
			if (indexPath.row == 0) {
				basicCell.textLabel.text = @"Load all frameworks";
			} else if (indexPath.row == 1) {
				basicCell.textLabel.text = @"Load all public frameworks";
				basicCell.detailTextLabel.text = @"Needs about half a minute";
			} else if (indexPath.row == 2) {
				basicCell.textLabel.text = @"Load all private frameworks";
			}
			return basicCell;
		} else if(indexPath.section == 1) {
			cell.bundle = [self.frameworks objectAtIndex:indexPath.row];
		} else if(indexPath.section == 2) {
			cell.bundle = [self.privateFrameworks objectAtIndex:indexPath.row];
		}
	} else if (tableView == self.searchDisplayController.searchResultsTableView) {
		if(indexPath.section == 1) {
			cell.bundle = [self.frameworksFiltered objectAtIndex:indexPath.row];
		} else if(indexPath.section == 2) {
			cell.bundle = [self.privateFrameworksFiltered objectAtIndex:indexPath.row];
		}
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSBundle* bundle = nil;
	if (tableView == self.tableView) {
		if(indexPath.section == 0) {
			if (indexPath.row == 0) {
				[self loadAllBundles];
			} else if (indexPath.row == 1) {
				[self loadAllPublicBundles];
			} else if (indexPath.row == 2) {
				[self loadAllPrivateBundles];
			}
		} else if(indexPath.section == 1) {
			bundle = [self.frameworks objectAtIndex:indexPath.row];
		} else if(indexPath.section == 2) {
			bundle = [self.privateFrameworks objectAtIndex:indexPath.row];
		}
	} else if (tableView == self.searchDisplayController.searchResultsTableView) {
		if(indexPath.section == 1) {
			bundle = [self.frameworksFiltered objectAtIndex:indexPath.row];
		} else if(indexPath.section == 2) {
			bundle = [self.privateFrameworksFiltered objectAtIndex:indexPath.row];
		}
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
		[self.searchDisplayController.searchResultsTableView reloadData];
		
		return;
	}
	
	NSArray* loadedClasses = [bundle loadedClasses];
	
	BrowserViewController* viewController = [[[BrowserViewController alloc] initWithPreset:loadedClasses] autorelease];
	viewController.title = bundle.bundlePath.lastPathComponent;
	[self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UISearchDisplayDelegate

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller {
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
	NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"bundleIdentifier CONTAINS[c] %@", searchString];
	
	self.frameworksFiltered = [[self.frameworks mutableCopy]autorelease];
	[self.frameworksFiltered filterUsingPredicate:filterPredicate];
	
	self.privateFrameworksFiltered = [[self.privateFrameworks mutableCopy]autorelease];
	[self.privateFrameworksFiltered filterUsingPredicate:filterPredicate];
	
	return YES;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
}

#pragma mark - load all bundles

- (void)loadAllBundles {
	NSMutableArray *allFrameworks = [[self.frameworks mutableCopy]autorelease];
	[allFrameworks addObjectsFromArray:self.privateFrameworks];
	[self loadBundlesInArray:allFrameworks];
}

- (void)loadAllPublicBundles {
	[self loadBundlesInArray:self.frameworks];
}

- (void)loadAllPrivateBundles {
	[self loadBundlesInArray:self.privateFrameworks];
}

- (void)loadBundlesInArray:(NSArray *)array {
	if (!self.automatedFrameworkLoadingInProgress) {
		self.automatedFrameworkLoadingInProgress = YES;
		UIView *loadingPopup = [UIView new];
		loadingPopup.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7];
		loadingPopup.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin);
		loadingPopup.frame = CGRectMake(60, 50, 200, 130);
		loadingPopup.layer.cornerRadius = 10;
		
		UIActivityIndicatorView *spinner = [[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]autorelease];
		CGRect frame = spinner.frame;
		frame.origin.x = 81.5;
		frame.origin.y = 30;
		spinner.frame = frame;
		[spinner startAnimating];
		[loadingPopup addSubview:spinner];
		
		UILabel *label = [[[UILabel alloc]initWithFrame:CGRectMake(0, 80, 200, 30)]autorelease];
		label.text = @"Loading";
		label.textAlignment = NSTextAlignmentCenter;
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor whiteColor];
		label.font = [UIFont systemFontOfSize:12];
		[loadingPopup addSubview:label];
		
		[[self.view superview] addSubview:loadingPopup];
		
		NSMutableArray *loadFrameworksError = [NSMutableArray array];
		
		dispatch_queue_t queue = dispatch_queue_create("de.mczonk.ORIBrowser.automatedFrameworkLoading", DISPATCH_QUEUE_SERIAL);
		for (NSBundle *bundle in array) {
			if (![[bundle bundleIdentifier]equalToAnyStringInArray:@[@"com.apple.Foundation", @"com.apple.UIKit", @"com.apple.CoreGraphics"]]) {
				if(![bundle isLoaded]) {
					dispatch_async(queue, ^{
						dispatch_sync(dispatch_get_main_queue(), ^{
							label.text = [bundle bundleIdentifier];
						});
						NSError* error = nil;
						if(![bundle loadAndReturnError:&error]) {
							dispatch_sync(dispatch_get_main_queue(), ^{
								[loadFrameworksError addObject:error];
							});
						}
					});
				}
				[bundle release];
			}
		}
		dispatch_async(queue, ^{
			dispatch_sync(dispatch_get_main_queue(), ^{
				label.text = @"Processing classes...";
				if ([loadFrameworksError count] > 0) {
					NSMutableString *errors = [NSMutableString stringWithString:@"The following errors occured:"];
					for (NSError *error in loadFrameworksError) {
						[errors appendFormat:@"\n\n%@", [error localizedDescription]];
					}
					[[[[UIAlertView alloc] initWithTitle:@"Error" message:errors delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
				}
			});
			dispatch_sync(dispatch_get_main_queue(), ^{
				[self.tableView reloadData];
				[self.searchDisplayController.searchResultsTableView reloadData];
				[[NSNotificationCenter defaultCenter] postNotificationName:@"ObjectListDidChangeNotification" object:nil];
				[loadingPopup removeFromSuperview];
			});
			self.automatedFrameworkLoadingInProgress = NO;
		});
	}
}

@end
