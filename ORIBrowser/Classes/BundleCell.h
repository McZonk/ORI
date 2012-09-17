#import <UIKit/UIKit.h>

@interface BundleCell : UITableViewCell {
}

+ (NSString*)reuseIdentifier;

+ (BundleCell*)cell;
+ (BundleCell*)cellWithReuseIdentifier:(NSString*)reuseIdentifier;

@property (nonatomic, retain) NSBundle* bundle;

@property (nonatomic, assign) IBOutlet UILabel* nameView;
@property (nonatomic, assign) IBOutlet UILabel* identifierView;

@end
