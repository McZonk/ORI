#import <UIKit/UIKit.h>


@interface PathViewController : UITableViewController

- (id)initWithPath:(NSString*)path;

@property (nonatomic, copy) NSString* path;

@end
