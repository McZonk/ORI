#import <UIKit/UIKit.h>

#import <ORI/ORI.h>

@interface HeaderViewController : UIViewController

- (id)initWithORIClass:(ORIClass*)cls;
- (id)initWithORIProtocol:(ORIProtocol*)protocol;

@property (nonatomic, retain) ORIClass* cls;
@property (nonatomic, retain) ORIProtocol* protocol;

@property (nonatomic, retain) IBOutlet UITextView* textView;

@end
