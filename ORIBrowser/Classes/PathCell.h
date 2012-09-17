#import <UIKit/UIKit.h>

@interface PathCell : UITableViewCell {
}

+ (NSString*)reuseIdentifier;

+ (PathCell*)cell;
+ (PathCell*)cellWithReuseIdentifier:(NSString*)reuseIdentifier;

@property (nonatomic, assign) IBOutlet UILabel* nameView;
@property (nonatomic, assign) IBOutlet UILabel* typeView;

@end
