#import "ORIPointerType.h"


@implementation ORIPointerType

- (void)dealloc {
	self.pointerType = nil;
	
	[super dealloc];
}

- (NSString*)declaration {
	return [NSString stringWithFormat:@"%@*", self.pointerType ? [self.pointerType declaration] : @"void"];
}

@synthesize pointerType;

@end
