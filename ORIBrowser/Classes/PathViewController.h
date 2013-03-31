#import <UIKit/UIKit.h>


@interface PathViewController : UITableViewController<UISearchDisplayDelegate>

- (id)initWithPath:(NSString*)path;

@property (nonatomic, copy) NSString* path;

@end
