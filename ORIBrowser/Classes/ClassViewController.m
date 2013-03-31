#import "ClassViewController.h"

#import "ProtocolViewController.h"
#import "MethodViewController.h"
#import "FlipViewController.h"
#import "HeaderViewController.h"

#import "NSString+ContainsCharacterSearch.h"
#import "UIViewController+ORIViewController.h"

#import "ClassCell.h"
#import "ProtocolCell.h"
#import "MethodCell.h"
#import "IvarCell.h"

#import "FavoritesStore.h"

NSString* FavoriteString = @"☆";
NSString* UnfavoriteString = @"★";


@interface ClassViewController ()

@property (nonatomic, retain) ORIClass* superclass;
@property (nonatomic, retain) NSArray* protocols;
@property (nonatomic, retain) NSArray* subclasses;
@property (nonatomic, retain) NSArray* classMethods;
@property (nonatomic, retain) NSArray* methods;
@property (nonatomic, retain) NSArray* ivars;

@property (nonatomic, retain) NSArray* filteredProtocols;
@property (nonatomic, retain) NSArray* filteredSubclasses;
@property (nonatomic, retain) NSArray* filteredClassMethods;
@property (nonatomic, retain) NSArray* filteredMethods;
@property (nonatomic, retain) NSArray* filteredIvars;

@property (nonatomic, retain) NSString* searchString;

- (void)collectionInformation;

@end


@implementation ClassViewController

- (id)initWithORIClass:(ORIClass*)cls {
	self = [super initWithNibName:@"ClassViewController" bundle:nil];
	if(self != nil) {
		self.cls = cls;
		
		self.title = self.cls.name;
		
		BOOL isFavorite = [[FavoritesStore sharedFavoritesStore] isFavoriteORIClass:self.cls];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:isFavorite ? UnfavoriteString : FavoriteString style:UIBarButtonItemStyleBordered target:self action:@selector(favorite:)] autorelease];
		
		[self collectionInformation];
	}
	return self;
}

- (void)dealloc {
	self.cls = nil;
	self.superclass = nil;
	self.protocols = nil;
	self.subclasses = nil;
	self.methods = nil;
	self.ivars = nil;
	
	self.filteredProtocols = nil;
	self.filteredSubclasses = nil;
	self.filteredClassMethods = nil;
	self.filteredMethods = nil;
	self.filteredIvars = nil;
	
	self.searchString = nil;
	
	[super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}

@synthesize cls = _cls;

@synthesize superclass;
@synthesize protocols;
@synthesize subclasses;
@synthesize classMethods;
@synthesize methods;
@synthesize ivars;

@synthesize filteredProtocols;
@synthesize filteredSubclasses;
@synthesize filteredClassMethods;
@synthesize filteredMethods;
@synthesize filteredIvars;

@synthesize searchString;

- (void)collectionInformation {
	self.superclass = self.cls.ORISuperclass;
	
	NSArray* sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
	
	self.subclasses = [self.cls.ORISubclasses sortedArrayUsingDescriptors:sortDescriptors];
	self.protocols = [self.cls.ORIProtocols sortedArrayUsingDescriptors:sortDescriptors];
	self.classMethods = [self.cls.ORIClassMethods sortedArrayUsingDescriptors:sortDescriptors];
	self.methods = [self.cls.ORIMethods sortedArrayUsingDescriptors:sortDescriptors];
	self.ivars = [self.cls.ORIIvars sortedArrayUsingDescriptors:sortDescriptors];
}

- (void)favorite:(id)sender {
	BOOL isFavorite = NO;
	
	FavoritesStore* favoriteStore = [FavoritesStore sharedFavoritesStore];
	if(![favoriteStore isFavoriteORIClass:self.cls]) {
		[favoriteStore addORIClass:self.cls];
		isFavorite = YES;
	} else {
		[favoriteStore removeORIClass:self.cls];
		isFavorite = NO;
	}
	
	self.navigationItem.rightBarButtonItem.title = isFavorite ? UnfavoriteString : FavoriteString;
}

#pragma mark -
#pragma mark UITableViewDataSource / UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(tableView == self.tableView) {
		if(section == 0) {
			return (self.superclass != nil) ? 1 : 0;
		}
		if(section == 1) {
			return self.subclasses.count;
		}
		if(section == 2) {
			return self.protocols.count;
		}
		if(section == 3) {
			return self.classMethods.count;
		}
		if(section == 4) {
			return self.methods.count;
		}
		if(section == 5) {
			return self.ivars.count;
		}
	}
	
	if(tableView == self.searchDisplayController.searchResultsTableView) {
		if(section == 0) {
			return (self.superclass != nil) ? 1 : 0;
		}
		if(section == 1) {
			return self.filteredSubclasses.count;
		}
		if(section == 2) {
			return self.filteredProtocols.count;
		}
		if(section == 3) {
			return self.filteredClassMethods.count;
		}
		if(section == 4) {
			return self.filteredMethods.count;
		}
		if(section == 5) {
			return self.filteredIvars.count;
		}
	}
	
	return 0;
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
	if(section == 0) {
		if(self.superclass) {
			return @"Superclass";
		}
		return nil;
	}
	
	if(section == 1) {
		if(self.subclasses.count) {
			return [NSString stringWithFormat:@"Subclasses (%d)", self.subclasses.count];
		}
		return nil;
	}
	
	if(section == 2) {
		if(self.protocols.count) {
			return [NSString stringWithFormat:@"Protocols (%d)", self.protocols.count];
		}
		return nil;
	}
	
	if(section == 3) {
		if(self.classMethods.count) {
			return [NSString stringWithFormat:@"Class Methods (%d)", self.classMethods.count];
		}
		return nil;
	}
	
	if(section == 4) {
		if(self.methods.count) {
			return [NSString stringWithFormat:@"Methods (%d)", self.methods.count];
		}
		return nil;
	}
	
	if(section == 5) {
		if(self.ivars.count) {
			return [NSString stringWithFormat:@"Ivar (%d)", self.ivars.count];
		}
		return nil;
	}
	
	return nil;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	if(indexPath.section == 0) {
		ClassCell* cell = (ClassCell*)[tableView dequeueReusableCellWithIdentifier:[ClassCell reuseIdentifier]];
		if(cell == nil) {
			cell = [ClassCell cell];
		}
		
		
		cell.cls = self.superclass;
		
		return cell;
	}
	
	if(indexPath.section == 1) {
		ClassCell* cell = (ClassCell*)[tableView dequeueReusableCellWithIdentifier:[ClassCell reuseIdentifier]];
		if(cell == nil) {
			cell = [ClassCell cell];
		}
		
		if(tableView == self.searchDisplayController.searchResultsTableView) {
			cell.cls = [self.filteredSubclasses objectAtIndex:indexPath.row];
		} else {
			cell.cls = [self.subclasses objectAtIndex:indexPath.row];
		}
		
		return cell;
	}
	
	if(indexPath.section == 2) {
		ProtocolCell* cell = (ProtocolCell*)[tableView dequeueReusableCellWithIdentifier:[ProtocolCell reuseIdentifier]];
		if(cell == nil) {
			cell = [ProtocolCell cell];
		}
		
		if(tableView == self.searchDisplayController.searchResultsTableView) {
			cell.protocol = [self.filteredProtocols objectAtIndex:indexPath.row];
		} else {
			cell.protocol = [self.protocols objectAtIndex:indexPath.row];
		}
		
		return cell;
	}
	
	if(indexPath.section == 3) {
		MethodCell* cell = (MethodCell*)[tableView dequeueReusableCellWithIdentifier:[MethodCell reuseIdentifier]];
		if(cell == nil) {
			cell = [MethodCell cell];
		}
		
		if(tableView == self.searchDisplayController.searchResultsTableView) {
			cell.method = [self.filteredClassMethods objectAtIndex:indexPath.row];
		} else {
			cell.method = [self.classMethods objectAtIndex:indexPath.row];
		}
		
		return cell;
	}
	
	if(indexPath.section == 4) {
		MethodCell* cell = (MethodCell*)[tableView dequeueReusableCellWithIdentifier:[MethodCell reuseIdentifier]];
		if(cell == nil) {
			cell = [MethodCell cell];
		}
		
		if(tableView == self.searchDisplayController.searchResultsTableView) {
			cell.method = [self.filteredMethods objectAtIndex:indexPath.row];
		} else {
			cell.method = [self.methods objectAtIndex:indexPath.row];
		}
		
		return cell;
	}
	
	if(indexPath.section == 5) {
		IvarCell* cell = (IvarCell*)[tableView dequeueReusableCellWithIdentifier:[IvarCell reuseIdentifier]];
		if(cell == nil) {
			cell = [IvarCell cell];
		}
		
		if(tableView == self.searchDisplayController.searchResultsTableView) {
			cell.ivar = [self.filteredIvars objectAtIndex:indexPath.row];
		} else {
			cell.ivar = [self.ivars objectAtIndex:indexPath.row];
		}
		
		return cell;
	}
	
	return nil;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	id object = nil;
	
	if(indexPath.section == 0) {
		object = self.superclass;
	} else if(indexPath.section == 1) {
		object = [self.subclasses objectAtIndex:indexPath.row];
	} else if(indexPath.section == 2) {
		object = [self.protocols objectAtIndex:indexPath.row];
	}
	UIViewController* viewController = [UIViewController viewControllerWithORIObject:object];
	if(viewController) {
		[self.navigationController pushViewController:viewController animated:YES];
	} else {
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
}

#pragma mark -
#pragma mark UISearchBarDelegate

- (void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)searchText {
	if(searchBar.text.length < 2) {
		self.searchString = nil;
	}
	
	if(!self.searchString || ![searchBar.text hasPrefix:self.searchString]) {
		self.filteredProtocols = self.protocols;
		self.filteredSubclasses = self.subclasses;
		self.filteredClassMethods = self.classMethods;
		self.filteredMethods = self.methods;
		self.filteredIvars = self.ivars;
	}
	self.searchString = searchBar.text;
	
	NSPredicate* predicate = [NSPredicate predicateWithBlock:^(id evaluatedObject, NSDictionary *bindings) {
		NSString* name = [evaluatedObject valueForKey:@"name"];
		
		return [name containsAllCharactersInString:searchString];
	}];
	
	self.filteredProtocols = [self.filteredProtocols filteredArrayUsingPredicate:predicate];
	self.filteredSubclasses = [self.filteredSubclasses filteredArrayUsingPredicate:predicate];
	self.filteredClassMethods = [self.filteredClassMethods filteredArrayUsingPredicate:predicate];
	self.filteredMethods = [self.filteredMethods filteredArrayUsingPredicate:predicate];
	self.filteredIvars = [self.filteredIvars filteredArrayUsingPredicate:predicate];
}

@end

