#import <UIKit/UIKit.h>

#import <ORI/ORI.h>

@interface ClassViewController : UITableViewController

- (id)initWithORIClass:(ORIClass*)cls;

@property (nonatomic, retain) ORIClass* cls;

@end
