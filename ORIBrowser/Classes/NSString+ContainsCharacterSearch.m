#import "NSString+ContainsCharacterSearch.h"

@implementation NSString (ContainsCharacterSearch)

- (BOOL)containsAllCharactersInString:(NSString*)search {
	const NSUInteger searchLength = [search length];
	const NSUInteger stringLength = [self length];
	
	NSUInteger stringIndex = 0;
	
	for(NSUInteger searchIndex = 0; searchIndex < searchLength; searchIndex++, stringIndex++) {
		const unichar searchCharacter = tolower([search characterAtIndex:searchIndex]);

		BOOL found = NO;
		
		for(; stringIndex < stringLength; stringIndex++) {
			const unichar stringCharacter = tolower([self characterAtIndex:stringIndex]);
			
			if(searchCharacter == stringCharacter) {
				found = YES;
				break;
			}
		}
		
		if(!found) {
			return NO;
		}
	}
	return YES;
}

@end
