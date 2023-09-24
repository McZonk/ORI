#import "ORIPointerType.h"


@implementation ORIPointerType

- (NSString*)declaration {
	return [NSString stringWithFormat:@"%@*", self.pointerType ? [self.pointerType declaration] : @"void"];
}

@synthesize pointerType;

@end
