#import <Foundation/Foundation.h>

@class ORIType;


@interface NSScanner (ORI)

- (unichar)nextUnichar;

- (BOOL)scanUnichar:(unichar*)value;

- (BOOL)scanORIType:(ORIType**)type;

@end
