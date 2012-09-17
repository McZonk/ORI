#import <UIKit/UIKit.h>


@interface BinaryFileViewController : UIViewController

- (id)initWithFile:(NSString*)file;

@property (nonatomic, copy) NSString* file;

@property (nonatomic, assign) IBOutlet UITextView* textView;

@end

