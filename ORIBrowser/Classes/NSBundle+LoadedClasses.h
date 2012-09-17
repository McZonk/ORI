#import <Foundation/Foundation.h>

@interface NSBundle (LoadedClasses)

+ (void)setupLoadedClasses;

- (NSArray*)loadedClasses;

@end
