//
//  XWCommon.m
//  XWJsonToCode
//
//  Created by key on 15/9/14.
//  Copyright © 2015年 熊  伟. All rights reserved.
//

#import "XWCommon.h"

NSString * const kNotiSureJsonName = @"kNotiSureJsonName";

NSString * const kUserSetPerClassName = @"kUserSetPerClassName";

NSString * const kIsCreatFile = @"kIsCreatFile";

NSString * const kIsAddMJExtension = @"kIsAddMJExtension";





/** ================== type ============== */

NSString * const stringType = @"NSString";

NSString * const numberType = @"NSNumber";

NSString * const arrayType = @"NSArray";

NSString * const dictionaryType = @"NSDictionary";

//NSString * const longlongType = @"long long";
NSString * const longlongType = @"NSInteger";

//NSString * const intType = @"int";
NSString * const intType = @"NSInteger";


NSString * const floatType = @"CGFloat";

NSString * const BOOLType = @"BOOL";


NSString * const prefix = @"x";


/******==================== ********/

NSString * const classDescription = @"/**======= <#description#> ========*/";

NSString * const classInterface = @"\n/**======= <#description#> ========*/\n@interface %@ : NSObject\n";

NSString * const classAttributeDescription = @"/** <#description#> */";

NSString * const classPropertyCopy = @"\n/** <#description#> */\n@property (nonatomic, copy) NSString* %@;\n";

NSString * const classPropertyStrong =@"\n/** <#description#> */\n@property (nonatomic, strong) NSArray* %@;\n";



NSString * const classPropertyAssign = @"\n/** <#description#> */\n@property (nonatomic, assign) %@ * %@;\n";

NSString * const classPropertyAssignNoStar = @"\n/** <#description#> */\n@property (nonatomic, assign) %@  %@;\n";

NSString * const classPropertyStrongNoArray  = @"\n/** <#description#> */\n@property (nonatomic, strong) %@ * %@;\n";



NSString * const classEnd = @"\n@end\n";

NSString * const classImplementation =  @"\n@implementation %@\n";

NSString * const newLine = @"\n";


NSString * const hTextHeader  =  @"\n#import <Foundation/Foundation.h>\n";

NSString * const hTextHeaderInfoClass  =  @"\n@class ";


/***=========  通知 ==============*/

NSString * const kNotiInputJsonVCDelalloc = @"kNotiInputJsonVCDelalloc";
NSString * const kNotiPrintCode = @"kNotiPrintCode";


/***========   key ==============*/
NSString * const codeHKey = @"codeHKey";
NSString * const codeMKey = @"codeMKey";


