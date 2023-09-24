#import "NSScanner+ORI.h"

#import "ORIType.h"
#import "ORIPointerType.h"
#import "ORICompoundType.h"

#import <objc/runtime.h>

@implementation NSScanner (ORI)

- (unichar)nextUnichar {
	if([self isAtEnd]) {
		return 0;
	}
	
	return [[self string] characterAtIndex:[self scanLocation]];
}

- (BOOL)scanUnichar:(unichar*)value {
	if([self isAtEnd]) {
		return NO;
	}
	
	NSUInteger scanLocation = [self scanLocation];
	unichar c = [[self string] characterAtIndex:scanLocation];
	if(value) {
		*value = c;
	}
	
	[self setScanLocation:scanLocation + 1];
	
	return YES;
}

#define _ORI_C_IN 'n'
#define _ORI_C_INOUT 'N'
#define _ORI_C_OUT 'o'
#define _ORI_C_BYCOPY 'O'
#define _ORI_C_ONEWAY 'V'

- (BOOL)scanORIType:(ORIType**)type {
	return [self scanORIType:type withOffset:YES];
}
	
- (BOOL)scanORIType:(ORIType**)type withOffset:(BOOL)withOffset {
	ORITypeFlag flags = 0;
	
	BOOL success = NO;
	
	do {
		unichar c;
		if(![self scanUnichar:&c]) {
			return NO;
		}

		switch(c) {
			case _C_CONST :
				flags |= ORITypeFlagConst;
				break;
				
			case _ORI_C_IN :
				flags |= ORITypeFlagIn;
				break;
				
			case _ORI_C_INOUT :
				flags |= ORITypeFlagInout;
				break;
				
			case _ORI_C_OUT :
				flags |= ORITypeFlagOut;
				break;
				
			case _ORI_C_BYCOPY :
				flags |= ORITypeFlagByCopy;
				break;
				
			case _ORI_C_ONEWAY :
				flags |= ORITypeFlagOneWay;
				break;
				
			case _C_PTR :
			{
				ORIType* subtype = nil;
				[self scanORIType:&subtype withOffset:NO];

				ORIPointerType* pointerType = [[ORIPointerType alloc] init];
				pointerType.pointerType = subtype;
				pointerType.flags = flags;
				pointerType.type = ORITypeTypePointer;
					
				if(type) {
					*type = pointerType;
				}
				success = YES;
				
				break;
			}

			case _C_UNION_B :
			case _C_STRUCT_B :
			{
				unichar end = c == _C_UNION_B ? _C_UNION_E : _C_STRUCT_E;
				
				NSString* name = nil;
				[self scanUpToString:@"=" intoString:&name];
				[self scanUnichar:nil];
				
				if([name isEqualToString:@"?"]) {
					name = nil;
				}
				
				NSMutableArray* types = [NSMutableArray arrayWithCapacity:4];
				
				while([self nextUnichar] != end) {
					ORIType* type = nil;
					if(![self scanORIType:&type withOffset:NO]) {
						break;
					}
					
					[types addObject:type];
				}
				[self scanUnichar:nil];
				
				ORICompoundType* structType = [[ORICompoundType alloc] init];
				structType.flags = flags;
				structType.type = c == _C_UNION_B ? ORITypeTypeUnion : ORITypeTypeStruct;
				if(name.length > 0) {
					structType.name = name;
				}
				if(types.count > 0) {
					structType.structTypes = types;
				}
				
				if(type) {
					*type = structType;
				}
				success = YES;

				break;
			}

			case _C_ID :
			case _C_CLASS :
			case _C_SEL :
			case _C_VOID :
			case _C_BOOL :
			case _C_CHR :
			case _C_UCHR :
			case _C_SHT :
			case _C_USHT :
			case _C_INT :
			case _C_UINT :
			case _C_LNG :
			case _C_ULNG :
			case _C_LNG_LNG :
			case _C_ULNG_LNG :
			case _C_FLT :
			case _C_DBL :
			case _C_CHARPTR :
				if(type) {
					*type = [ORIType typeWithType:(ORITypeType)c flags:flags];
				}
				success = YES;
				break;
		}
		
	} while(NO);
	
	if(withOffset) {
		NSInteger offset;
		[self scanInteger:&offset];
	}

	return success;
}

@end
