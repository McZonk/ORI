#import "BundleCell.h"

#import "NSBundle+LoadedClasses.h"

@implementation BundleCell

+ (NSString*)reuseIdentifier {
	return NSStringFromClass(self);
}

+ (BundleCell*)cell {
	return [self cellWithReuseIdentifier:[self reuseIdentifier]];
}

+ (BundleCell*)cellWithReuseIdentifier:(NSString*)reuseIdentifier {
	NSArray* views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil];
	if(views.count == 0) {
		return nil;
	}
	
	BundleCell* cell = (BundleCell*)[views objectAtIndex:0];
	if(![cell isKindOfClass:self]) {
		return nil;
	}
	
	SEL action = @selector(setReuseIdentifer:);
	if([cell respondsToSelector:action]) {
		[cell performSelector:action withObject:reuseIdentifier];
	}
	
	return cell;
}

- (id)init {
	[NSException raise:NSInternalInconsistencyException format:@"%@ cannot be created with %s", NSStringFromClass([self class]), __FUNCTION__];
	return nil;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
	[NSException raise:NSInternalInconsistencyException format:@"%@ cannot be created with %s", NSStringFromClass([self class]), __FUNCTION__];
	return nil;
}

- (id)initWithCoder:(NSCoder*)coder {
	self = [super initWithCoder:coder];
	if(self != nil) {
		[self addObserver:self forKeyPath:@"bundle" options:0 context:nil];
	}
	return self;
}

- (void)dealloc {
	[self removeObserver:self forKeyPath:@"bundle"];
	
	self.bundle = nil;
	
	[super dealloc];
}

@synthesize bundle;

@synthesize nameView;
@synthesize identifierView;

- (void)updateView {
	self.nameView.text = [self.bundle bundleIdentifier];
	if(self.nameView.text.length == 0) {
		self.nameView.text = [[self.bundle bundlePath] lastPathComponent];
	}
	
	self.identifierView.text = [self.bundle bundlePath];
	
	if([self.bundle isLoaded]) {
		if(self.bundle.loadedClasses) {
			self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		} else {
			self.accessoryType = UITableViewCellAccessoryCheckmark;
		}
	} else {
		self.accessoryType = UITableViewCellAccessoryNone;
	}
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
	if(object == self && [keyPath isEqualToString:@"bundle"]) {
		[self updateView];
	}
}

@end
