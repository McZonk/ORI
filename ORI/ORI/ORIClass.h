#import <Foundation/Foundation.h>

#import <objc/runtime.h>

@class ORIProtocol;
@class ORIIvar;
@class ORIMethod;

@interface ORIClass : NSObject

+ (NSSet<ORIClass*>*)ORIClasses;

+ (ORIClass*)ORIClassWithClass:(Class)cls;
+ (ORIClass*)ORIClassWithName:(NSString*)name;

- (instancetype)initWithClass:(Class)cls;
- (instancetype)initWithName:(NSString*)name;

@property (nonatomic, assign, readonly) Class cls; // class could run in conflict with C++

@property (nonatomic, readonly) Class superclass;
@property (nonatomic, readonly) id metaclass;

@property (nonatomic, readonly) NSString* name;

@property (nonatomic, readonly) ORIClass* ORISuperclass;

@property (nonatomic, readonly) NSArray<ORIClass*>* ORIClasses;
@property (nonatomic, readonly) NSSet<ORIClass*>* ORISubclasses;
@property (nonatomic, readonly) NSSet<ORIProtocol*>* ORIProtocols;
@property (nonatomic, readonly) NSSet<ORIIvar*>* ORIIvars;
@property (nonatomic, readonly) NSSet<ORIMethod*>* ORIMethods;

@property (nonatomic, readonly) NSSet<ORIMethod*>* ORIClassMethods;

@property (nonatomic, readonly) NSString* declaration;

- (NSComparisonResult)compare:(ORIClass*)object;

@end
