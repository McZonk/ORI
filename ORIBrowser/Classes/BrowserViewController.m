#import "BrowserViewController.h"

#import <ORI/ORI.h>

#import "ClassCell.h"
#import "ProtocolCell.h"

#import "FlipViewController.h"
#import "ClassViewController.h"
#import "ProtocolViewController.h"
#import "HeaderViewController.h"

#import "NSString+ContainsCharacterSearch.h"

#import "UIViewController+ORIViewController.h"

@interface BrowserViewController () <UISearchDisplayDelegate>

@property (nonatomic, retain) NSArray* presetObjects;

@property (nonatomic, retain) NSArray* allObjects;

@property (nonatomic, retain) NSArray* sectionTitles;
@property (nonatomic, retain) NSArray* sectionObjects;

@property (nonatomic, retain) NSString* searchString;
@property (nonatomic, retain) NSArray* searchObjects;

//@property (nonatomic, retain) NSDictionary* oriObjects;

- (void)reloadData;

@end


@implementation BrowserViewController

- (void)setup {
	self.title = @"Object List";
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"ObjectListDidChangeNotification" object:nil];
	
	[self reloadData];
}

- (id)initWithNibName:(NSString*)nibName bundle:(NSBundle*)nibBundle {
	if(nibName == nil) {
		nibName = @"BrowserViewController";
	}
	
	self = [super initWithNibName:nibName bundle:nibBundle];
	if(self != nil) {

	}
	return self;
}

- (id)initWithCoder:(NSCoder*)coder {
	self = [super initWithCoder:coder];
	if(self != nil) {
		[self setup];
	}
	return self;
}

- (id)initWithPreset:(NSArray*)preset {
	self = [super init];
	if(self != nil) {
		NSMutableArray* presetObjects = [NSMutableArray arrayWithCapacity:preset.count];
		
		for(id object in preset) {
			if([object isKindOfClass:[ORIClass class]]) {
				[presetObjects addObject:object];
				continue;
			}
			
			if([object isKindOfClass:[NSString class]]) {
				ORIClass* cls = [ORIClass ORIClassWithName:(NSString*)object];
				if(cls) {
					[presetObjects addObject:cls];
				}
				continue;
			}
		}
		
		self.presetObjects = presetObjects;
		
		[self setup];
	}
	return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"ObjectListDidChangeNotification" object:nil];

	self.classCountView = nil;
	
	self.sectionObjects = nil;
	self.sectionTitles = nil;
	
	self.searchString = nil;
	self.searchObjects = nil;

	self.allObjects = nil;
	
	self.presetObjects = nil;

	[super dealloc];
}

- (void)viewDidLoad {
	[super viewDidLoad];

	self.classCountView.text = [NSString stringWithFormat:@"%d Classes and Protocols", self.allObjects.count];
}

- (void)viewDidUnload {
	[super viewDidUnload];
	
	self.classCountView = nil;
}

@synthesize presetObjects = _presetObjects;

@synthesize allObjects = _allObjects;

@synthesize sectionObjects = _sectionObjects;
@synthesize sectionTitles = _sectionTitles;

@synthesize searchString = _searchString;
@synthesize searchObjects = _searchObjects;


@synthesize classCountView;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}

- (void)reloadData {
	NSArray* sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
	
	if(self.presetObjects == nil) {
		NSSet* oriClasses = [ORIClass ORIClasses];
		NSSet* oriProtocols = [ORIProtocol ORIProtocols];
	
		NSMutableArray* array = [NSMutableArray array];
		[array addObjectsFromArray:[oriClasses allObjects]];
		[array addObjectsFromArray:[oriProtocols allObjects]];

		self.allObjects = [array sortedArrayUsingDescriptors:sortDescriptors];
	} else {
		self.allObjects = [self.presetObjects sortedArrayUsingDescriptors:sortDescriptors];
	}
	
	NSMutableArray* array = [self.allObjects mutableCopy];

	self.sectionTitles = [NSArray arrayWithObjects:
		@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I",
		@"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R",
		@"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"#",
		nil
	];
	
	NSMutableArray* sections = [NSMutableArray array];
	
	for(NSUInteger sectionIndex = 0; sectionIndex < 26; sectionIndex++) {
		NSString* prefix = [self.sectionTitles objectAtIndex:sectionIndex];
		
		NSMutableArray* subarray = [NSMutableArray array];
		for(NSUInteger index = 0; index < array.count;) {
			id object = [array objectAtIndex:index];
			
			if([object isKindOfClass:[ORIClass class]]) {
				ORIClass* c = object;
				if([c.name hasPrefix:prefix]) {
					[subarray addObject:c];
					[array removeObjectAtIndex:index];
					continue;
				}
			}
			
			if([object isKindOfClass:[ORIProtocol class]]) {
				ORIProtocol* p = object;
				if([p.name hasPrefix:prefix]) {
					[subarray addObject:p];
					[array removeObjectAtIndex:index];
					continue;
				}
			}
			
			index++;
		}
		
		[subarray sortUsingDescriptors:[NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease]]];
		[sections addObject:subarray];
	}
	
	// Add rest to #
	[array sortUsingDescriptors:[NSArray arrayWithObject:[[[NSSortDescriptor alloc]	initWithKey:@"name" ascending:YES] autorelease]]];
	[sections addObject:array];
	
	self.sectionObjects = sections;
	
	[self.tableView reloadData];
	self.classCountView.text = [NSString stringWithFormat:@"%d Classes and Protocols", self.allObjects.count];
}

#pragma mark -
#pragma mark UITableViewDataSource / UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
	if(tableView == self.tableView) {
		return self.sectionObjects.count;		
	}
	if(tableView == self.searchDisplayController.searchResultsTableView) {
		return 1;
	}
	
	return 0;
}

- (NSArray*)sectionIndexTitlesForTableView:(UITableView*)tableView {
	if(tableView == self.tableView) {
		NSMutableArray *sectionTitlesWithSearchIcon = [NSMutableArray arrayWithObject:UITableViewIndexSearch];
		[sectionTitlesWithSearchIcon addObjectsFromArray:self.sectionTitles];
		return sectionTitlesWithSearchIcon;
	}

	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	if ([title isEqualToString:UITableViewIndexSearch]) {
		CGRect searchBarFrame = self.searchDisplayController.searchBar.frame;
		[tableView scrollRectToVisible:searchBarFrame animated:NO];
		return NSNotFound;
	}
	return [self.sectionTitles indexOfObject:title];
}


- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
	if(tableView == self.tableView) {
		NSArray* objects = [self.sectionObjects objectAtIndex:section];
		return objects.count;
	}
	if(tableView == self.searchDisplayController.searchResultsTableView) {
		return self.searchObjects.count;
	}
	
	return 0;
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
	if(tableView == self.tableView) {
		return [self.sectionTitles objectAtIndex:section];
	}
	return nil;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	id object = nil;
	
	if(tableView == self.tableView) {
		NSArray* objects = [self.sectionObjects objectAtIndex:indexPath.section];
		object = [objects objectAtIndex:indexPath.row];
	} else if(tableView == self.searchDisplayController.searchResultsTableView) {
		object = [self.searchObjects objectAtIndex:indexPath.row];
	} else {
		[NSException raise:NSInternalInconsistencyException format:@"%s:%d:%s:Unknown Table: %@", __FILE__, __LINE__, __FUNCTION__, tableView];
	}
	
	if([object isKindOfClass:[ORIClass class]]) {
		ClassCell* cell = (ClassCell*)[tableView dequeueReusableCellWithIdentifier:[ClassCell reuseIdentifier]];
		if(cell == nil) {
			cell = [ClassCell cell];
		}
		
		cell.cls = (ORIClass*)object;
		
		return cell;
	}
	
	if([object isKindOfClass:[ORIProtocol class]]) {
		ProtocolCell* cell = (ProtocolCell*)[tableView dequeueReusableCellWithIdentifier:[ProtocolCell reuseIdentifier]];
		if(cell == nil) {
			cell = [ProtocolCell cell];
		}
		
		cell.protocol = (ORIProtocol*)object;
		
		return cell;
	}

	return nil;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	id object = nil;
	
	if(tableView == self.tableView) {
		NSArray* objects = [self.sectionObjects objectAtIndex:indexPath.section];
		object = [objects objectAtIndex:indexPath.row];
	} else if(tableView == self.searchDisplayController.searchResultsTableView) {
		object = [self.searchObjects objectAtIndex:indexPath.row];
	} else {
		[NSException raise:NSInternalInconsistencyException format:@"%s:%d:%s:Unknown Table: %@", __FILE__, __LINE__, __FUNCTION__, tableView];
	}
	
	UIViewController* viewController = [UIViewController viewControllerWithORIObject:object];
	if(viewController) {
		[self.navigationController pushViewController:viewController animated:YES];
	}
}

#pragma mark -
#pragma mark UISearchBarDelegate

- (void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)searchText {
	if(searchBar.text.length < 2) {
		self.searchString = nil;
		self.searchObjects = nil;
	}
	
	if(!self.searchObjects || !self.searchString || ![searchBar.text hasPrefix:self.searchString]) {
		self.searchObjects = self.allObjects;
	}
	self.searchString = searchBar.text;
	
	NSPredicate* predicate = [NSPredicate predicateWithBlock:^(id evaluatedObject, NSDictionary *bindings) {
		NSString* name = [evaluatedObject valueForKey:@"name"];
		
		return [name containsAllCharactersInString:self.searchString];
	}];

	self.searchObjects = [self.searchObjects filteredArrayUsingPredicate:predicate];
}

@end

