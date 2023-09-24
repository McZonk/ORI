#import "ORIClass.h"

#import "ORIProtocol.h"
#import "ORIIvar.h"
#import "ORIMethod.h"

@interface ORIClass ()

@property (nonatomic, assign, readwrite) Class cls;

@end


@implementation ORIClass

+ (NSSet<ORIClass*>*)ORIClasses {
	unsigned int count = objc_getClassList(NULL, 0);
	NSMutableData* classData = [NSMutableData dataWithLength:sizeof(Class) * count];
	Class* classes = (Class*)[classData mutableBytes];
	objc_getClassList(classes, count);
	
	NSMutableSet<ORIClass*>* set = [NSMutableSet setWithCapacity:count];
	for(NSUInteger i = 0; i < count; i++) {
		[set addObject:[self ORIClassWithClass:classes[i]]];
	}
	return set;
}

+ (ORIClass*)ORIClassWithClass:(Class)cls {
	return [[ORIClass alloc] initWithClass:cls];
}

+ (ORIClass*)ORIClassWithName:(NSString*)name {
	return [[ORIClass alloc] initWithName:name];
}

- (instancetype)initWithClass:(Class)cls_ {
	self = [super init];
	if(self != nil) {
		self.cls = cls_;
	}
	return self;
}

- (instancetype)initWithName:(NSString*)name {
	return [self initWithClass:NSClassFromString(name)];
}

@synthesize cls;

- (NSString*)description {
	return [NSString stringWithFormat:@"%@:%@", [self class], self.name];
}

- (BOOL)isEqual:(id)object {
	ORIClass* c = (ORIClass*)object;
	if(![c isKindOfClass:[self class]]) {
		return NO;
	}
	
	return self.cls == c.cls;
}

- (NSComparisonResult)compare:(ORIClass*)object {
	return [self.name compare:object.name];
}

- (Class)superclass {
	return class_getSuperclass(self.cls);
}

- (id)metaclass {
	return objc_getMetaClass(class_getName(self.cls));
}

- (NSString*)name {
	return NSStringFromClass(self.cls);
}

- (ORIClass*)ORISuperclass {
	if(!self.superclass) {
		return nil;
	}
	return [[ORIClass alloc] initWithClass:self.superclass];
}

- (NSArray*)ORIClasses {
	NSMutableArray* result = [NSMutableArray arrayWithCapacity:8];
	
	for(Class c = self.cls; c; c = class_getSuperclass(c)) {
		[result addObject:[ORIClass ORIClassWithClass:c]];
	}
	
	return result;
}

- (NSSet*)ORISubclasses {
	unsigned int count = 0;
	Class* classes = objc_copyClassList(&count);
	if(count == 0) {
		return nil;
	}

	NSMutableSet* result = [NSMutableSet setWithCapacity:4];

	for(NSUInteger i = 0; i < count; i++) {
		Class c = classes[i];
		if(class_getSuperclass(c) == self.cls) {
			[result addObject:[ORIClass ORIClassWithClass:c]];
		}
	}
	
	free(classes);
	
	return result;
}

- (NSSet*)ORIProtocols {
	unsigned int count = 0;
	Protocol* __unsafe_unretained * protocols = class_copyProtocolList(cls, &count);
	if(count == 0) {
		return nil;
	}

	NSMutableSet* result = [NSMutableSet setWithCapacity:2];

	for(NSUInteger i = 0; i < count; i++) {
		[result addObject:[ORIProtocol ORIProtocolWithProtocol:protocols[i]]];
	}
	
	free(protocols);
	
	return result;
}

- (NSSet*)ORIIvars {
	unsigned int count = 0;
	Ivar* ivars = class_copyIvarList(cls, &count);
	if(count == 0) {
		return nil;
	}

	NSMutableSet* result = [NSMutableSet setWithCapacity:count];
	
	for(NSUInteger i = 0; i < count; i++) {
		[result addObject:[ORIIvar ORIIvarWithIvar:ivars[i]]];
	}
	
	free(ivars);
	
	return result;
}

- (NSSet*)ORIMethods {
	unsigned int count = 0;
	Method* methods = class_copyMethodList(cls, &count);
	if(count == 0) {
		return nil;
	}

	NSMutableSet* result = [NSMutableSet setWithCapacity:count];
	
	for(NSUInteger i = 0; i < count; i++) {
		[result addObject:[ORIMethod ORIMethodWithMethod:methods[i]]];
	}
	
	free(methods);
	
	return result;
}

- (NSSet*)ORIClassMethods {
	unsigned int count = 0;
	Method* methods = class_copyMethodList(self.metaclass, &count);
	
	NSMutableSet* result = [NSMutableSet setWithCapacity:count];
	
	for(NSUInteger i = 0; i < count; i++) {
		[result addObject:[ORIMethod ORIMethodWithMethod:methods[i]]];
	}
	
	free(methods);
	
	return result;
}

- (NSString*)declaration {
	NSMutableString* string = [NSMutableString stringWithCapacity:2048];
	
	NSArray* sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];

	[string appendFormat:@"@interface %@", self.name];
	if(self.superclass) {
		[string appendFormat:@" : %@", self.ORISuperclass.name];
	}
	
	NSSet* ivars = self.ORIIvars;
	if(ivars) {
		NSArray* sortedIvars = [ivars sortedArrayUsingDescriptors:sortDescriptors];

		[string appendFormat:@" {\n"];

		for(ORIIvar* ivar in sortedIvars) {
			[string appendFormat:@"%@;\n", ivar.declaration];
		}
	
		[string appendFormat:@"}"];
	}
	[string appendFormat:@"\n\n"];

	NSSet* classMethods = self.ORIClassMethods;
	if(classMethods) {
		NSArray* sortedClassMethods = [classMethods sortedArrayUsingDescriptors:sortDescriptors];
		
		for(ORIMethod* method in sortedClassMethods) {
			[string appendFormat:@"%@;\n", [method.declaration stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"+"]];
		}

		[string appendFormat:@"\n"];
	}

	NSSet* methods = self.ORIMethods;
	if(methods) {
		NSArray* sortedMethods = [methods sortedArrayUsingDescriptors:sortDescriptors];

		for(ORIMethod* method in sortedMethods) {
			[string appendFormat:@"%@;\n", method.declaration];
		}

		[string appendFormat:@"\n"];
	}
	
	[string appendFormat:@"@end"];
	
	return string;
}

@end
