#import "MethodCell.h"

#import <QuartzCore/QuartzCore.h>

@implementation MethodCell

+ (NSString*)reuseIdentifier {
	return NSStringFromClass(self);
}

+ (MethodCell*)cell {
	return [self cellWithReuseIdentifier:[self reuseIdentifier]];
}

+ (MethodCell*)cellWithReuseIdentifier:(NSString*)reuseIdentifier {
	NSArray* views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil];
	if(views.count == 0) {
		return nil;
	}
	
	MethodCell* cell = (MethodCell*)[views objectAtIndex:0];
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
		[self addObserver:self forKeyPath:@"method" options:0 context:nil];
	}
	return self;
}

- (void)dealloc {
	[self removeObserver:self forKeyPath:@"method"];
	
	self.method = nil;
	
	[super dealloc];
}

- (void)awakeFromNib {
	[super awakeFromNib];
	
	self.typeView.layer.cornerRadius = 6.0f;
}

@synthesize method;

@synthesize typeView;
@synthesize methodView;
@synthesize typeEncodingView;

- (void)updateView {	
	self.methodView.text = self.method.declaration;
	self.typeEncodingView.text = [NSString stringWithFormat:@"%@", self.method.typeEncoding];
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
	if(object == self && [keyPath isEqualToString:@"method"]) {
		[self updateView];
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	UIColor* color = self.typeView.backgroundColor;
	
	[super setSelected:selected animated:animated];
	
	self.typeView.backgroundColor = color;
}

@end
