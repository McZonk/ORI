//
//  NSString+InArray.m
//  ORIBrowser
//
//  Created by Alex Hoppen on 01.04.13.
//
//

#import "NSString+InArray.h"

@implementation NSString (InArray)

- (BOOL)equalToAnyStringInArray:(NSArray *)array {
	for (NSString *string in array) {
		if ([self isEqualToString:string]) {
			return YES;
		}
	}
	return NO;
}

@end
