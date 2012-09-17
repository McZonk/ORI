#import <UIKit/UIKit.h>

#import <ORI/ORIIvar.h>

@interface IvarCell : UITableViewCell {
}

+ (NSString*)reuseIdentifier;

+ (IvarCell*)cell;
+ (IvarCell*)cellWithReuseIdentifier:(NSString*)reuseIdentifier;

@property (nonatomic, retain) ORIIvar* ivar;

@property (nonatomic, assign) IBOutlet UILabel* typeView;
@property (nonatomic, assign) IBOutlet UILabel* nameView;

@end
