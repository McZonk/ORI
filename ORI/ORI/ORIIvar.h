#import <Foundation/Foundation.h>

#import <objc/runtime.h>

#import "ORIType.h"


@interface ORIIvar : NSObject

+ (ORIIvar*)ORIIvarWithIvar:(Ivar)ivar;

- (id)initWithIvar:(Ivar)ivar;

@property (nonatomic, assign, readonly) Ivar ivar;

@property (nonatomic, readonly) NSString* name;

@property (nonatomic, readonly) NSString* typeEncoding;

@property (nonatomic, readonly) ORIType* ORIType;

- (NSComparisonResult)compare:(ORIIvar*)object;

- (NSString*)declaration;

@end
