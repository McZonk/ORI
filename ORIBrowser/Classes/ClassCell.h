#import <UIKit/UIKit.h>

#import <ORI/ORI.h>

@interface ClassCell : UITableViewCell {
}

+ (NSString*)reuseIdentifier;

+ (ClassCell*)cell;
+ (ClassCell*)cellWithReuseIdentifier:(NSString*)reuseIdentifier;

@property (nonatomic, retain) ORIClass* cls;

@property (nonatomic, assign) IBOutlet UILabel* typeView;
@property (nonatomic, assign) IBOutlet UILabel* classView;
@property (nonatomic, assign) IBOutlet UILabel* superclassView;

@property (nonatomic, assign) IBOutlet UIView* favoriteView;
@property (nonatomic, assign) IBOutlet UILabel* noWeakView;

@end
