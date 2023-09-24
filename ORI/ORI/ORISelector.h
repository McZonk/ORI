#import <Foundation/Foundation.h>

#import <objc/runtime.h>

#import <ORI/ORIType.h>

@interface ORISelector : NSObject

+ (ORISelector*)ORISelectorWithSelector:(SEL)selector;
+ (ORISelector*)ORISelectorWithSelector:(SEL)selector types:(const char*)types;

- (instancetype)initWithSelector:(SEL)selector;
- (instancetype)initWithSelector:(SEL)selector types:(const char*)types;

@property (nonatomic, assign, readonly) SEL selector;
@property (nonatomic, retain, readonly) NSString* types;

@property (nonatomic, readonly) NSString* name;

@property (nonatomic, readonly) NSString* declaration;

@property (nonatomic, readonly) ORIType* ORIReturnType;
@property (nonatomic, readonly) NSArray* ORIArgumentTypes;

@end
