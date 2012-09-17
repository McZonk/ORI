#import "ClassCell.h"

#import <QuartzCore/QuartzCore.h>

#import "FavoritesStore.h"


@implementation ClassCell

+ (NSString*)reuseIdentifier {
	return NSStringFromClass(self);
}

+ (ClassCell*)cell {
	return [self cellWithReuseIdentifier:[self reuseIdentifier]];
}

+ (ClassCell*)cellWithReuseIdentifier:(NSString*)reuseIdentifier {
	NSArray* views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil];
	if(views.count == 0) {
		return nil;
	}
	
	ClassCell* cell = (ClassCell*)[views objectAtIndex:0];
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
		[self addObserver:self forKeyPath:@"cls" options:0 context:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addFavoriteNotification:) name:FavoritesStoreDidAddORIClassNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeFavoriteNotification:) name:FavoritesStoreDidRemoveORIClassNotification object:nil];
	}
	return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:FavoritesStoreDidAddORIClassNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:FavoritesStoreDidRemoveORIClassNotification object:nil];
	
	[self removeObserver:self forKeyPath:@"cls"];
	
	self.cls = nil;
	
	[super dealloc];
}

- (void)awakeFromNib {
	[super awakeFromNib];
	
	self.typeView.layer.cornerRadius = 6.0f;
}

- (void)updateView {
	self.classView.text = self.cls.name;
	
	NSMutableString* superclasses = [NSMutableString string]; 
	for(ORIClass* superclass = self.cls.ORISuperclass; superclass != nil; superclass = superclass.ORISuperclass) {
		if(superclasses.length > 0) {
			[superclasses appendString:@" > "];
		}
		[superclasses appendString:superclass.name];
	}
	
	self.superclassView.text = superclasses;
	
	self.favoriteView.hidden = ![[FavoritesStore sharedFavoritesStore] isFavoriteORIClass:self.cls];
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
	if(object == self && [keyPath isEqualToString:@"cls"]) {
		[self updateView];
	}
}

- (void)addFavoriteNotification:(NSNotification*)notification {
	if([self.cls isEqual:[notification.userInfo objectForKey:@"ORIClass"]]) {
		self.favoriteView.hidden = NO;
	}
}

- (void)removeFavoriteNotification:(NSNotification*)notification {
	if([self.cls isEqual:[notification.userInfo objectForKey:@"ORIClass"]]) {
		self.favoriteView.hidden = YES;
	}
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
	UIColor* color = self.typeView.backgroundColor;
	
	[super setHighlighted:highlighted animated:animated];
	
	self.typeView.backgroundColor = color;
}

@synthesize cls;

@synthesize typeView;
@synthesize classView;
@synthesize superclassView;
@synthesize favoriteView;
@synthesize noWeakView;

@end
