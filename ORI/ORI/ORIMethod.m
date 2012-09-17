#import "ORIMethod.h"

#import "NSScanner+ORI.h"

@interface ORIMethod ()

@property (nonatomic, assign, readwrite) Method method;

@property (nonatomic, retain) NSArray* ORITypes;

@end


@implementation ORIMethod

+ (NSSet*)ORIMethods {
	return nil;
#if 0
	NSUInteger count objc_get
	
	NSInteger count = objc_getClassList(NULL, 0);
	NSMutableData* classData = [NSMutableData dataWithLength:sizeof(Class) * count];
	Class* classes = (Class*)[classData mutableBytes];
	objc_getClassList(classes, count);
	
	NSMutableSet* set = [NSMutableSet setWithCapacity:count];
	for(NSUInteger i = 0; i < count; i++) {
		[set addObject:[self ORIClassWithClass:classes[i]]];
	}
	return set;
#endif
}

+ (ORIMethod*)ORIMethodWithMethod:(Method)method {
	return [[[ORIMethod alloc] initWithMethod:method] autorelease];
}

- (id)initWithMethod:(Method)method_ {
	self = [super init];
	if(self != nil) {
		self.method = method_;
		
		
		NSMutableArray* array = [NSMutableArray array];

		NSScanner* scanner = [NSScanner scannerWithString:self.typeEncoding];
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
	self.method = 0;
	self.ORITypes = nil;
	
	[super dealloc];
}

@synthesize method;
@synthesize ORITypes;

- (NSString*)description {
	return [NSString stringWithFormat:@"%@:%@", [self class], self.name];
}

- (BOOL)isEqual:(id)object {
	ORIMethod* m = (ORIMethod*)object;
	if(![m isKindOfClass:[self class]]) {
		return NO;
	}
	
	return self.method == m.method;
}

- (NSComparisonResult)compare:(ORIMethod*)object {
	return [self.name compare:object.name]; 
}

- (NSString*)name {
	return [NSString stringWithCString:sel_getName(method_getName(self.method)) encoding:NSUTF8StringEncoding];
}

- (NSString*)typeEncoding {
	return [NSString stringWithCString:method_getTypeEncoding(self.method) encoding:NSUTF8StringEncoding];
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
		
		[string appendFormat:@"arg%d", i];
	}
	
	return string;
}

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
