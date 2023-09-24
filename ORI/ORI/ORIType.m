#import "ORIType.h"

@interface ORIType ()

@end


@implementation ORIType

+ (NSString*)declarationForFlags:(ORITypeFlag)flags {
	NSMutableString* string = [NSMutableString string];
	
	if(flags & ORITypeFlagConst) {
		[string appendString:@"const "];
	}
	if(flags & ORITypeFlagIn) {
		[string appendString:@"in "];
	}
	if(flags & ORITypeFlagOut) {
		[string appendString:@"out "];
	}
	if(flags & ORITypeFlagInout) {
		[string appendString:@"inout "];
	}
	if(flags & ORITypeFlagByCopy) {
		[string appendString:@"bycopy "];
	}
	if(flags & ORITypeFlagOneWay) {
		[string appendString:@"oneway "];
	}
	
	return @"";
}


+ (NSString*)declarationForType:(ORITypeType)name {
	switch(name) {
		case ORITypeTypeID :
			return @"id";
		case ORITypeTypeClass :
			return @"Class";
		case ORITypeTypeSelector :
			return @"SEL";
		case ORITypeTypeChar :
			return @"char";
		case ORITypeTypeUnsignedChar :
			return @"unsigned char";
		case ORITypeTypeShort :
			return @"short";
		case ORITypeTypeUnsignedShort :
			return @"unsigned short";
		case ORITypeTypeInt :
			return @"int";
		case ORITypeTypeUnsignedInt :
			return @"unsigned int";
		case ORITypeTypeLong :
			return @"long";
		case ORITypeTypeUnsignedLong :
			return @"unsigned long";
		case ORITypeTypeLongLong :
			return @"long long";
		case ORITypeTypeUnsignedLongLong :
			return @"unsigned long long";
		case ORITypeTypeFloat :
			return @"float";
		case ORITypeTypeDouble :
			return @"double";
		case ORITypeTypeBitfield :
			return @"BITFIELD";
		case ORITypeTypeBool :
			return @"BOOL";
		case ORITypeTypeVoid :
			return @"void";
		case ORITypeTypeUndefined :
			return @"undefined";
		case ORITypeTypePointer :
			return @"void*";
		case ORITypeTypeCharPointer :
			return @"char*";
		case ORITypeTypeAtom :
			return @"ATOM";
		case ORITypeTypeUnion :
			return @"union";
		case ORITypeTypeStruct :
			return @"struct";
		default:
			return @"unknown";
	}
}

+ (ORIType*)typeWithType:(ORITypeType)type flags:(ORITypeFlag)flags {
	ORIType* oritype = [[self alloc] init];
	oritype.type = type;
	oritype.flags = flags;
	return oritype;
}

@synthesize flags;
@synthesize type;

- (NSString*)declaration {
	return [NSString stringWithFormat:@"%@%@", [[self class] declarationForFlags:self.flags], [[self class] declarationForType:self.type]];
}

@end
