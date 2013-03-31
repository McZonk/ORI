#import "PathCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation PathCell

+ (NSString*)reuseIdentifier {
	return NSStringFromClass(self);
}

+ (PathCell*)cell {
	return [self cellWithReuseIdentifier:[self reuseIdentifier]];
}

+ (PathCell*)cellWithReuseIdentifier:(NSString*)reuseIdentifier {
	NSArray* views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil];
	if(views.count == 0) {
		return nil;
	}
	
	PathCell* cell = (PathCell*)[views objectAtIndex:0];
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

- (void)setSelected:(BOOL)highlighted animated:(BOOL)animated {
	UIColor* color = self.typeView.backgroundColor;
	
	[super setSelected:highlighted animated:animated];
	
	self.typeView.backgroundColor = color;
}

@synthesize nameView;
@synthesize typeView;

@end
