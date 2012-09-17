#import <UIKit/UIKit.h>

#import <ORI/ORISelector.h>

@interface SelectorCell : UITableViewCell

+ (NSString*)reuseIdentifier;

+ (SelectorCell*)cell;
+ (SelectorCell*)cellWithReuseIdentifier:(NSString*)reuseIdentifier;

@property (nonatomic, retain) ORISelector* selector;

@property (nonatomic, assign) IBOutlet UILabel* typeView;
@property (nonatomic, assign) IBOutlet UILabel* methodView;
@property (nonatomic, assign) IBOutlet UILabel* typeEncodingView;

@end
