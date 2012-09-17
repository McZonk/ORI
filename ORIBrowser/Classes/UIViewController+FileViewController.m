#import "UIViewController+FileViewController.h"

#import "PathViewController.h"

#import "PlistViewController.h"
#import "ImageViewController.h"
#import "NibViewController.h"
#import "BinaryFileViewController.h"


@implementation UIViewController (FileViewController)

+ (UIViewController*)viewControllerForPath:(NSString*)path {
	NSDictionary* attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
	
	NSString* extension = [path pathExtension];
	
	if([[attributes fileType] isEqual:NSFileTypeDirectory]) {
		return [[[PathViewController alloc] initWithPath:path] autorelease];
	}
	
	if([extension isEqualToString:@"plist"]) {
		return [[[PlistViewController alloc] initWithFile:path] autorelease];
	}
	
	if([extension isEqualToString:@"strings"]) {
		return [[[PlistViewController alloc] initWithFile:path] autorelease];
	}
	
	if([extension isEqualToString:@"png"] || [extension isEqualToString:@"jpg"] || [extension isEqualToString:@"bmp"]) {
		return [[[ImageViewController alloc] initWithPath:path] autorelease];
	}
	
	if([extension isEqualToString:@"nib"] || [extension isEqualToString:@"xib"]) {
		return [[[NibViewController alloc] initWithPath:path] autorelease];
	}
		
	return [[[BinaryFileViewController alloc] initWithFile:path] autorelease];
}

@end
