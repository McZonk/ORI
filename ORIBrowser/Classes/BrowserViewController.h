#import <UIKit/UIKit.h>

@interface BrowserViewController : UITableViewController

- (id)initWithPreset:(NSArray*)preset;

@property (nonatomic, retain) IBOutlet UILabel* classCountView;

@end
