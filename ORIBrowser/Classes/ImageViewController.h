#import <UIKit/UIKit.h>

#import "ImageScrollView.h"


@interface ImageViewController : UIViewController <UIScrollViewDelegate>

- (id)initWithPath:(NSString*)path;

@property (nonatomic, copy) NSString* path;

@property (nonatomic, retain) IBOutlet ImageScrollView* imageScrollView;

- (IBAction)saveImage:(id)sender;

@end
