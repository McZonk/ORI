#import <Foundation/Foundation.h>

#import <objc/runtime.h>

#import "ORIType.h"

@interface ORIMethod : NSObject

+ (NSSet*)ORIMethods;

+ (ORIMethod*)ORIMethodWithMethod:(Method)method;
+ (ORIMethod*)ORIClassMethodWithMethod:(Method)method;

- (id)initWithMethod:(Method)method;

@property (nonatomic, assign, readonly) Method method;

@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) NSString* typeEncoding;
@property (nonatomic, readonly) NSString* declaration;

@property (nonatomic, readonly) ORIType* ORIReturnType;
@property (nonatomic, readonly) NSArray* ORIArgumentTypes;

@property (nonatomic, readonly, getter = isClassMethod) BOOL classMethod;

@end
