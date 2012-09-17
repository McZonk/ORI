#import "NSObject+ORI.h"

#import "ORIClass.h"
#import "ORIIvar.h"
#import "ORIMethod.h"


@implementation NSObject (ORI)

- (ORIClass*)ORIClass {
	return [ORIClass ORIClassWithClass:[self class]];
}

- (NSString*)ORIDescription {
	NSMutableString* text = [NSMutableString stringWithCapacity:4096];
	
	for(ORIClass* class in self.ORIClass.ORIClasses) {
		if(text.length > 0 && ![text hasSuffix:@"\n"]) {
			[text appendString:@"\n"];
		}
		[text appendFormat:@"%@", class];
		
		NSArray* ivars = [[class.ORIIvars allObjects] sortedArrayUsingSelector:@selector(compare:)];
		for(ORIIvar* ivar in ivars) {
			if(text.length > 0 && ![text hasSuffix:@"\n"]) {
				[text appendString:@"\n"];
			}
			[text appendFormat:@"  %@", ivar];
		}
		
		NSArray* methods = [[class.ORIMethods allObjects] sortedArrayUsingSelector:@selector(compare:)];
		for(ORIMethod* method in methods) {
			if(text.length > 0 && ![text hasSuffix:@"\n"]) {
				[text appendString:@"\n"];
			}
			[text appendFormat:@"  %@", method];
		}
	}
	
	return text;
}

@end
