#import "ORIIvar.h"

#import "NSScanner+ORI.h"


@interface ORIIvar ()

@property (nonatomic, assign, readwrite) Ivar ivar;

@end


@implementation ORIIvar

+ (ORIIvar*)ORIIvarWithIvar:(Ivar)ivar {
	return [[[ORIIvar alloc] initWithIvar:ivar] autorelease];
}

- (id)initWithIvar:(Ivar)ivar_ {
	self = [super init];
	if(self != nil) {
		self.ivar = ivar_;
	}
	return self;
}

- (void)dealloc {
	self.ivar = 0;
	
	[super dealloc];
}

@synthesize ivar;

- (NSString*)description {
	return [NSString stringWithFormat:@"%@:%@", [self class], self.name];
}

- (BOOL)isEqual:(id)object {
	ORIIvar* i = (ORIIvar*)object;
	if(![i isKindOfClass:[self class]]) {
		return NO;
	}
	
	return self.ivar == i.ivar;
}

- (NSComparisonResult)compare:(ORIIvar*)object {
	return [self.name compare:object.name]; 
}

- (NSString*)name {
	return [NSString stringWithCString:ivar_getName(self.ivar) encoding:NSUTF8StringEncoding];
}

- (NSString*)typeEncoding {
	return [NSString stringWithCString:ivar_getTypeEncoding(self.ivar) encoding:NSUTF8StringEncoding];
}

- (ORIType*)ORIType {
	ORIType* type = nil;

	NSScanner* scanner = [NSScanner scannerWithString:self.typeEncoding];
	[scanner scanORIType:&type];

	return type;
}

- (NSString*)declaration {
	return [NSString stringWithFormat:@"%@%@ %@", @"\t", [self.ORIType declaration], self.name];
}

@end
