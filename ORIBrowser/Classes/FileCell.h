#import <UIKit/UIKit.h>

@interface FileCell : UITableViewCell {
}

+ (NSString*)reuseIdentifier;

+ (FileCell*)cell;
+ (FileCell*)cellWithReuseIdentifier:(NSString*)reuseIdentifier;

@property (nonatomic, assign) IBOutlet UILabel* nameView;
@property (nonatomic, assign) IBOutlet UILabel* sizeView;
@property (nonatomic, assign) IBOutlet UILabel* typeView;

@property (nonatomic, assign) IBOutlet UIImageView* thumbnailView;

@end
