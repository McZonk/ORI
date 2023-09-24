#import "ORICompoundType.h"

@implementation ORICompoundType

- (NSString*)declaration {
	NSMutableString* string = [NSMutableString stringWithCapacity:256];
	[string appendString:[[self class] declarationForFlags:self.flags]];
	
#if 1
	if(self.name) {
		[string appendString:self.name];
		return [NSString stringWithString:string];
	}
	
	BOOL first = YES;
	
	if(self.type == ORITypeTypeUnion) {
		[string appendString:@"union "];
	} else {
		[string appendString:@"struct "];
	}
	
	[string appendString:@"{"];
	for(ORIType* structType in self.structTypes) {
		if(!first) {
			[string appendString:@", "];
		}
		[string appendString:structType.declaration];
		
		first = NO;
	}
	[string appendString:@"}"];
#endif
	
	return [NSString stringWithString:string];
}

@synthesize name;
@synthesize structTypes;

@end
