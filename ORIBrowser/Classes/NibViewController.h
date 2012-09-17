#import <UIKit/UIKit.h>


@interface NibViewController : UIViewController

- (id)initWithPath:(NSString*)path;

@property (nonatomic, copy) NSString* path;

@end
