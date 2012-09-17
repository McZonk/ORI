#import <UIKit/UIKit.h>

@interface FlipViewController : UIViewController

- (id)initWithViewFrontViewController:(UIViewController*)frontViewController backViewController:(UIViewController*)backViewController;

@property (nonatomic, retain) IBOutlet UIViewController* frontViewController;
@property (nonatomic, retain) IBOutlet UIViewController* backViewController;

@property (nonatomic, readonly) UIViewController* visibleViewController;

@property (nonatomic, assign) UIViewAnimationOptions frontAnimation;
@property (nonatomic, assign) UIViewAnimationOptions backAnimation;

@property (nonatomic, retain) NSString* frontButtonTitle;
@property (nonatomic, retain) NSString* backButtonTitle;

- (IBAction)flip:(id)sender;

- (void)flipAnimated:(BOOL)animated;

@end
