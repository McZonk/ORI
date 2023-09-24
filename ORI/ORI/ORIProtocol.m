#import "ORIProtocol.h"

#import "ORISelector.h"

@interface ORIProtocol ()

@property (nonatomic, assign, readwrite) Protocol* protocol;

@end


@implementation ORIProtocol

+ (NSSet*)ORIProtocols {
	unsigned int count = 0;
	Protocol* __unsafe_unretained * protocols = objc_copyProtocolList(&count);
	
	NSMutableSet* set = [NSMutableSet setWithCapacity:count];
	for(NSUInteger i = 0; i < count; i++) {
		Protocol* protocol = protocols[i];
		[set addObject:[ORIProtocol ORIProtocolWithProtocol:protocol]];
	}

	free(protocols);
	
	return set;
}

+ (ORIProtocol*)ORIProtocolWithProtocol:(Protocol*)protocol {
	return [[self alloc] initWithProtocol:protocol];
}

- (instancetype)initWithProtocol:(Protocol*)protocol_ {
	self = [super init];
	if(self != nil) {
		self.protocol = protocol_;
	}
	return self;
}

@synthesize protocol;

- (NSString*)description {
	return [NSString stringWithFormat:@"%@:%@", [self class], self.name];
}

- (NSComparisonResult)compare:(ORIProtocol*)object {
	return [self.name compare:object.name];
}

- (NSString*)name {
	return [NSString stringWithCString:protocol_getName(self.protocol) encoding:NSUTF8StringEncoding];
}

/*
 OBJC_EXPORT struct objc_method_description *protocol_copyMethodDescriptionList(Protocol *p, BOOL isRequiredMethod, BOOL isInstanceMethod, unsigned int *outCount)
 __OSX_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_2_0);
 OBJC_EXPORT objc_property_t protocol_getProperty(Protocol *proto, const char *name, BOOL isRequiredProperty, BOOL isInstanceProperty)
 __OSX_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_2_0);
 OBJC_EXPORT objc_property_t *protocol_copyPropertyList(Protocol *proto, unsigned int *outCount)
 __OSX_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_2_0);
 OBJC_EXPORT Protocol * __unsafe_unretained *protocol_copyProtocolList(Protocol *proto, unsigned int *outCount)

 */

- (NSSet*)ORIProtocols {
	unsigned int count = 0;
	Protocol* __unsafe_unretained * protocols = protocol_copyProtocolList(self.protocol, &count);
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

- (NSSet*)ORISelectors {
	unsigned int countRequired = 0;
	unsigned int countOptional = 0;
	
	struct objc_method_description* selsRequired = protocol_copyMethodDescriptionList(self.protocol, YES, YES, &countRequired);
	struct objc_method_description* selsOptional = protocol_copyMethodDescriptionList(self.protocol, NO, YES, &countOptional);
	
	NSMutableSet* set = [NSMutableSet setWithCapacity:countRequired + countOptional];
	
	for(NSUInteger i = 0; i < countRequired; i++) {
		struct objc_method_description* md = &selsRequired[i];
		
		[set addObject:[ORISelector ORISelectorWithSelector:md->name types:md->types]];
	}

	for(NSUInteger i = 0; i < countOptional; i++) {
		struct objc_method_description* md = &selsOptional[i];
		
		[set addObject:[ORISelector ORISelectorWithSelector:md->name types:md->types]];
	}

	free(selsRequired);
	free(selsOptional);
	
	return set;
}

- (NSString*)declaration {
	NSMutableString* string = [NSMutableString stringWithCapacity:1024];
	
	
	
	return string;
}


#if 0

OBJC_EXPORT BOOL protocol_conformsToProtocol(Protocol *proto, Protocol *other)
AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER;
OBJC_EXPORT BOOL protocol_isEqual(Protocol *proto, Protocol *other)
AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER;
OBJC_EXPORT const char *protocol_getName(Protocol *p)
AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER;
OBJC_EXPORT struct objc_method_description protocol_getMethodDescription(Protocol *p, SEL aSel, BOOL isRequiredMethod, BOOL isInstanceMethod)
AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER;
OBJC_EXPORT struct objc_method_description *protocol_copyMethodDescriptionList(Protocol *p, BOOL isRequiredMethod, BOOL isInstanceMethod, unsigned int *outCount)
AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER;
OBJC_EXPORT objc_property_t protocol_getProperty(Protocol *proto, const char *name, BOOL isRequiredProperty, BOOL isInstanceProperty)
AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER;
OBJC_EXPORT objc_property_t *protocol_copyPropertyList(Protocol *proto, unsigned int *outCount)
AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER;
OBJC_EXPORT Protocol **protocol_copyProtocolList(Protocol *proto, unsigned int *outCount)
AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER;

#endif

@end
