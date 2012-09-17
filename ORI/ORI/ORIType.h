#import <Foundation/Foundation.h>

#include <objc/runtime.h>

typedef enum ORITypeFlag {
	ORITypeFlagConst = 0x01,
	ORITypeFlagIn = 0x02,
	ORITypeFlagOut = 0x04,
	ORITypeFlagInout = 0x08,
	ORITypeFlagByCopy = 0x10,
	ORITypeFlagOneWay = 0x20
} ORITypeFlag;

typedef enum ORITypeType {
	ORITypeTypeID = _C_ID,
	ORITypeTypeClass = _C_CLASS,
	ORITypeTypeSelector = _C_SEL,
	ORITypeTypeChar = _C_CHR,
	ORITypeTypeUnsignedChar = _C_UCHR,
	ORITypeTypeShort = _C_SHT,
	ORITypeTypeUnsignedShort = _C_USHT,
	ORITypeTypeInt = _C_INT,
	ORITypeTypeUnsignedInt = _C_UINT,
	ORITypeTypeLong = _C_LNG,
	ORITypeTypeUnsignedLong = _C_ULNG,
	ORITypeTypeLongLong = _C_LNG_LNG,
	ORITypeTypeUnsignedLongLong = _C_ULNG_LNG,
	ORITypeTypeFloat = _C_FLT,
	ORITypeTypeDouble = _C_DBL,
	ORITypeTypeBitfield = _C_BFLD,
	ORITypeTypeBool = _C_BOOL,
	ORITypeTypeVoid = _C_VOID,
	ORITypeTypeUndefined = _C_UNDEF,
	ORITypeTypePointer = _C_PTR,
	ORITypeTypeCharPointer = _C_CHARPTR,
	ORITypeTypeAtom = _C_ATOM,
	
	ORITypeTypeUnion = _C_UNION_B,
	ORITypeTypeStruct = _C_STRUCT_B,
} ORITypeType;

@interface ORIType : NSObject

+ (NSString*)declarationForFlags:(ORITypeFlag)flags;
+ (NSString*)declarationForType:(ORITypeType)name;

+ (ORIType*)typeWithType:(ORITypeType)type flags:(ORITypeFlag)flags;

@property (nonatomic, assign) ORITypeFlag flags;
@property (nonatomic, assign) ORITypeType type;

@property (nonatomic, readonly) NSString* declaration;

@end
