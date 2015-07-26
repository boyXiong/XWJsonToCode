//
//  common.h
//  XWJsonToCode
//
//  Created by key on 15/7/24.
//  Copyright (c) 2015年 熊  伟. All rights reserved.
//

#ifndef XWJsonToCode_common_h
#define XWJsonToCode_common_h



#define kNotiSureJsonName   @"kNotiSureJsonName"

/** perfrence Set **/

#define kUserSetPerClassName    @"kUserSetPerClassName"

#define kIsCreatFile            @"kIsCreatFile"

#define kIsAddMJExtension            @"kIsAddMJExtension"




/** ================== type ============== */

#define stringType @"NSString"

#define numberType @"NSNumber"

#define arrayType @"NSArray"

#define dictionaryType @"NSDictionary"

#define longlongType @"long long"

#define intType @"int"

#define floatType @"CGFloat"

#define BOOLType @"BOOL"

#define prefix  @"x"


/******==================== ********/

#define classDescription @"/**======= <#description#> ========*/"
#define classInterface @"\n/**======= <#description#> ========*/\n@interface %@ : NSObject\n"

#define classAttributeDescription =  @"/** <#description#> */"


#define classPropertyCopy @"\n/** <#description#> */\n@property (nonatomic, copy) NSString* %@;\n"

#define classPropertyStrong @"\n/** <#description#> */\n@property (nonatomic, strong) NSArray* %@;\n"

#define classPropertyAssign @"\n/** <#description#> */\n@property (nonatomic, assign) %@ * %@;\n"

#define classPropertyAssignNoStar @"\n/** <#description#> */\n@property (nonatomic, assign) %@  %@;\n"

#define classPropertyStrongNoArray @"\n/** <#description#> */\n@property (nonatomic, strong) %@ * %@;\n"



#define classEnd @"\n@end\n"

#define classImplementation @"\n@implementation %@\n"

#define newLine @"\n"


#define hTextHeader     @"\n#import <Foundation/Foundation.h>\n"

#define hTextHeaderInfoClass    @"\n@class "




#endif
