#import <Foundation/Foundation.h>

#import <objc/runtime.h>

@class ORIType;

@interface ORIMethod : NSObject

+ (NSSet<ORIMethod*>*)ORIMethods;

+ (ORIMethod*)ORIMethodWithMethod:(Method)method;

- (instancetype)initWithMethod:(Method)method;

@property (nonatomic, assign, readonly) Method method;

@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) NSString* typeEncoding;
@property (nonatomic, readonly) NSString* declaration;

@property (nonatomic, readonly) ORIType* ORIReturnType;
@property (nonatomic, readonly) NSArray<ORIType*>* ORIArgumentTypes;

@end
