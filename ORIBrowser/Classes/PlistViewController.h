#import <UIKit/UIKit.h>


@interface PlistViewController : UIViewController

- (id)initWithFile:(NSString*)file;

@property (nonatomic, copy) NSString* file;

@property (nonatomic, assign) IBOutlet UITextView* textView;

@end
