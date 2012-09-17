#import <Foundation/Foundation.h>

#import <objc/runtime.h>

@interface ORIClass : NSObject

+ (NSSet*)ORIClasses;

+ (ORIClass*)ORIClassWithClass:(Class)cls;
+ (ORIClass*)ORIClassWithName:(NSString*)name;

- (id)initWithClass:(Class)cls;
- (id)initWithName:(NSString*)name;

@property (nonatomic, assign, readonly) Class cls; // class could run in conflict with C++

@property (nonatomic, readonly) Class superclass;
@property (nonatomic, readonly) id metaclass;

@property (nonatomic, readonly) NSString* name;

@property (nonatomic, readonly) ORIClass* ORISuperclass;

@property (nonatomic, readonly) NSArray* ORIClasses;
@property (nonatomic, readonly) NSSet* ORISubclasses;
@property (nonatomic, readonly) NSSet* ORIProtocols;
@property (nonatomic, readonly) NSSet* ORIIvars;
@property (nonatomic, readonly) NSSet* ORIMethods;

@property (nonatomic, readonly) NSSet* ORIClassMethods;

@property (nonatomic, readonly) NSString* declaration;

- (NSComparisonResult)compare:(ORIClass*)object;

@end
