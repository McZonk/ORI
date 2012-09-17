#import "ProtocolViewController.h"

#import "ProtocolCell.h"
#import "SelectorCell.h"

#import "UIViewController+ORIViewController.h"

@interface ProtocolViewController ()

@property (nonatomic, retain) ORIProtocol* protocol;

@property (nonatomic, retain) NSArray* superprotocols;
@property (nonatomic, retain) NSArray* selectors;

@end


@implementation ProtocolViewController

- (id)initWithORIProtocol:(ORIProtocol*)protocol {
	self = [super initWithNibName:nil bundle:nil];
	if(self != nil) {
		self.protocol = protocol;
		
		NSArray* sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];

		self.superprotocols = [self.protocol.ORIProtocols sortedArrayUsingDescriptors:sortDescriptors];
		self.selectors = [self.protocol.ORISelectors sortedArrayUsingDescriptors:sortDescriptors];
		
		self.title = self.protocol.name;
	}
	return self;
}

- (void)dealloc {
	self.protocol = nil;
	
	self.superprotocols = nil;
	self.selectors = nil;
	
	[super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}

#pragma mark -
#pragma mark UITableViewDataSource / UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
	if(tableView == self.tableView) {
		if(section == 0) {
			return self.superprotocols.count;
		}
		if(section == 1) {
			return self.selectors.count;
		}
	}
	
	if(tableView == self.searchDisplayController.searchResultsTableView) {
		if(section == 0) {
			// TODO
		}
		if(section == 1) {
			// TODO
		}
	}
	
	return 0;
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
	if(section == 0) {
		if(self.superprotocols.count) {
			return [NSString stringWithFormat:@"Superprotocols (%d)", self.superprotocols.count];
		}
		return nil;
	}
	
	if(section == 1) {
		if(self.selectors.count) {
			return [NSString stringWithFormat:@"Selectors (%d)", self.selectors.count];
		}
		return nil;
	}
	
	return nil;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	if(indexPath.section == 0) {
		ProtocolCell* cell = (ProtocolCell*)[tableView dequeueReusableCellWithIdentifier:[ProtocolCell reuseIdentifier]];
		if(cell == nil) {
			cell = [ProtocolCell cell];
		}
		
		cell.protocol = [self.superprotocols objectAtIndex:indexPath.row];
		
		return cell;
	}
	
	if(indexPath.section == 1) {
		SelectorCell* cell = (SelectorCell*)[tableView dequeueReusableCellWithIdentifier:[SelectorCell reuseIdentifier]];
		if(cell == nil) {
			cell = [SelectorCell cell];
		}
		
		cell.selector = [self.selectors objectAtIndex:indexPath.row];
		
		return cell;
	}
	
	return nil;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	id object = nil;
	
	if(indexPath.section == 0) {
		object = [self.superprotocols objectAtIndex:indexPath.row];
	}
	
	UIViewController* viewController = [UIViewController viewControllerWithORIObject:object];
	if(viewController) {
		[self.navigationController pushViewController:viewController animated:YES];
	}
}

@synthesize protocol = _protocol;

@synthesize superprotocols = _superprotocols;
@synthesize selectors = _selectors;

@end
