#import <Foundation/Foundation.h>

#import <objc/runtime.h>

@interface ORIProtocol : NSObject

+ (NSSet*)ORIProtocols;

+ (ORIProtocol*)ORIProtocolWithProtocol:(Protocol*)protocol;							 

- (id)initWithProtocol:(Protocol*)protocol;

@property (nonatomic, assign, readonly) Protocol* protocol;

@property (nonatomic, readonly) NSString* name;

@property (nonatomic, readonly) NSSet* ORIProtocols;
@property (nonatomic, readonly) NSSet* ORISelectors;

@property (nonatomic, readonly) NSString* declaration;

- (NSComparisonResult)compare:(ORIProtocol*)object;

@end
