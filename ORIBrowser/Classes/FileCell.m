#import "FileCell.h"

@implementation FileCell

+ (NSString*)reuseIdentifier {
	return NSStringFromClass(self);
}

+ (FileCell*)cell {
	return [self cellWithReuseIdentifier:[self reuseIdentifier]];
}

+ (FileCell*)cellWithReuseIdentifier:(NSString*)reuseIdentifier {
	NSArray* views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil];
	if(views.count == 0) {
		return nil;
	}
	
	FileCell* cell = (FileCell*)[views objectAtIndex:0];
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
		
	}
	return self;
}

- (void)dealloc {
	[super dealloc];
}

- (void)awakeFromNib {
	[super awakeFromNib];
	
	self.typeView.layer.cornerRadius = 6.0f;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
	UIColor* color = self.typeView.backgroundColor;
	
	[super setHighlighted:highlighted animated:animated];
	
	self.typeView.backgroundColor = color;
}

@synthesize nameView;
@synthesize sizeView;
@synthesize typeView;

@end
