#import "ORISelector.h"

#import "NSScanner+ORI.h"


@interface ORISelector ()

@property (nonatomic, assign, readwrite) SEL selector;
@property (nonatomic, retain, readwrite) NSString* types;

@property (nonatomic, retain) NSArray* ORITypes;

@end


@implementation ORISelector

+ (ORISelector*)ORISelectorWithSelector:(SEL)selector {
	return [[self alloc] initWithSelector:selector];
}

+ (ORISelector*)ORISelectorWithSelector:(SEL)selector types:(const char*)types {
	return [[self alloc] initWithSelector:selector types:types];
}

- (instancetype)initWithSelector:(SEL)selector {
	return [self initWithSelector:selector types:0];
}

- (instancetype)initWithSelector:(SEL)selector_ types:(const char*)types_ {
	self = [super init];
	if(self != nil) {
		self.selector = selector_;
		self.types = [NSString stringWithCString:types_ encoding:NSUTF8StringEncoding];
		
		NSMutableArray* array = [NSMutableArray array];
		
		NSScanner* scanner = [NSScanner scannerWithString:self.types];
		do {
			ORIType* type = nil;
			if(![scanner scanORIType:&type]) {
				break;
			}
			
			[array addObject:type];
		} while(YES);
		
		self.ORITypes = [NSArray arrayWithArray:array];
	}
	return self;
}

- (void)dealloc {
}

@synthesize selector = _selector;
@synthesize types = _types;

- (NSString*)description {
	return [NSString stringWithFormat:@"%@:%@ %@", [self class], self.name, self.types];
}

- (NSString*)name {
	return [NSString stringWithCString:sel_getName(self.selector) encoding:NSUTF8StringEncoding];
}

- (NSString*)declaration {
	NSArray* components = [self.name componentsSeparatedByString:@":"];	
	if(components == nil) {
		components = [NSArray arrayWithObject:self.name];
	}
	
	ORIType* returnType = self.ORIReturnType;
	NSArray* argumentTypes = self.ORIArgumentTypes;
	
	NSMutableString* string = [NSMutableString stringWithCapacity:80];
	
	[string appendFormat:@"- (%@)", returnType.declaration];
	if(components.count == 1) {
		[string appendFormat:@"%@", [components objectAtIndex:0]];
		return string;
	}
	
	for(NSUInteger i = 0; i < components.count - 1; i++) {
		if(i > 0) {
			[string appendString:@" "];
		}
		
		[string appendFormat:@"%@:", [components objectAtIndex:i]];
		
		if(i < argumentTypes.count) {
			ORIType* argumentType = [argumentTypes objectAtIndex:i];
			[string appendFormat:@"(%@)", argumentType.declaration];
		} else {
			[string appendString:@"(UNKNOWN)"];
		}
		
		[string appendFormat:@"arg%u", (unsigned int)i];
	}
	
	return string;

#if 0
	NSMutableString* string = [NSMutableString stringWithCapacity:256];
	
	[string appendFormat:@"%@", self.name];
	
	return string;
#endif
}

@synthesize ORITypes;

- (ORIType*)ORIReturnType {
	if(self.ORITypes.count < 1) {
		return nil;
	}
	
	return [self.ORITypes objectAtIndex:0];
}

- (NSArray*)ORIArgumentTypes {
	if(self.ORITypes.count <= 3) {
		return nil;
	}
	
	return [self.ORITypes subarrayWithRange:NSMakeRange(3, self.ORITypes.count - 3)];
}

@end
