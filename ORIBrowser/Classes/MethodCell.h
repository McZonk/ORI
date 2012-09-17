#import <UIKit/UIKit.h>

#import <ORI/ORIMethod.h>

@interface MethodCell : UITableViewCell

+ (NSString*)reuseIdentifier;

+ (MethodCell*)cell;
+ (MethodCell*)cellWithReuseIdentifier:(NSString*)reuseIdentifier;

@property (nonatomic, retain) ORIMethod* method;

@property (nonatomic, assign) IBOutlet UILabel* typeView;
@property (nonatomic, assign) IBOutlet UILabel* methodView;
@property (nonatomic, assign) IBOutlet UILabel* typeEncodingView;

@end
