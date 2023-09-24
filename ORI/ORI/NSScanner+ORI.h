#import <Foundation/Foundation.h>

@class ORIType;


@interface NSScanner (ORI)

- (BOOL)scanORIType:(ORIType**)type;

@end
