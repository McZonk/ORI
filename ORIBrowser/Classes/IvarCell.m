#import "IvarCell.h"

#import <QuartzCore/QuartzCore.h>

@implementation IvarCell

+ (NSString*)reuseIdentifier {
	return NSStringFromClass(self);
}

+ (IvarCell*)cell {
	return [self cellWithReuseIdentifier:[self reuseIdentifier]];
}

+ (IvarCell*)cellWithReuseIdentifier:(NSString*)reuseIdentifier {
	NSArray* views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil];
	if(views.count == 0) {
		return nil;
	}
	
	IvarCell* cell = (IvarCell*)[views objectAtIndex:0];
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
		[self addObserver:self forKeyPath:@"ivar" options:0 context:nil];
	}
	return self;
}

- (void)dealloc {
	[self removeObserver:self forKeyPath:@"ivar"];
	
	self.ivar = nil;

	[super dealloc];
}

- (void)awakeFromNib {
	[super awakeFromNib];
	
	self.typeView.layer.cornerRadius = 6.0f;
}

@synthesize ivar;

@synthesize typeView;
@synthesize nameView;

- (void)updateView {
	self.nameView.text = [NSString stringWithFormat:@"%@ %@", self.ivar.ORIType.declaration, self.ivar.name];
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
	if(object == self && [keyPath isEqualToString:@"ivar"]) {
		[self updateView];
	}
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
	UIColor* color = self.typeView.backgroundColor;
	
	[super setHighlighted:highlighted animated:animated];
	
	self.typeView.backgroundColor = color;
}

@end
