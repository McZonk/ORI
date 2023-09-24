#import <Foundation/Foundation.h>

#import <objc/runtime.h>

@class ORIMethod;
@class ORISelector;

@interface ORIProtocol : NSObject

+ (NSSet<ORIProtocol*>*)ORIProtocols;

+ (ORIProtocol*)ORIProtocolWithProtocol:(Protocol*)protocol;							 

- (instancetype)initWithProtocol:(Protocol*)protocol;

@property (nonatomic, assign, readonly) Protocol* protocol;

@property (nonatomic, readonly) NSString* name;

@property (nonatomic, readonly) NSSet<ORIMethod*>* ORIProtocols;
@property (nonatomic, readonly) NSSet<ORISelector*>* ORISelectors;

@property (nonatomic, readonly) NSString* declaration;

- (NSComparisonResult)compare:(ORIProtocol*)object;

@end
