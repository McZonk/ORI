#import <UIKit/UIKit.h>

#import <ORI/ORI.h>


@interface MethodViewController : UITableViewController

- (id)initWithORIMethod:(ORIMethod*)method;

@property (nonatomic, retain) ORIMethod* method;

@end
