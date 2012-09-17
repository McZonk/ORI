#import <UIKit/UIKit.h>

#import <ORI/ORIProtocol.h>

@interface ProtocolCell : UITableViewCell

+ (NSString*)reuseIdentifier;

+ (ProtocolCell*)cell;
+ (ProtocolCell*)cellWithReuseIdentifier:(NSString*)reuseIdentifier;

@property (nonatomic, retain) ORIProtocol* protocol;

@property (nonatomic, assign) IBOutlet UILabel* typeView;
@property (nonatomic, assign) IBOutlet UILabel* protocolView;

@end
