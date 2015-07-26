//
//  NSString+XW.h
//  01-testOXAPP
//
//  Created by key on 15/7/20.
//  Copyright (c) 2015年 XiongWei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XW)


/** 去掉空格，和换行符 */
- (NSString *)convert;

/** 首字母大写 */
- (NSString *)perferCharCapitalizedString;

/** 去掉 / */
- (NSString *)documentPath;




/** 判断是不是整数 */
- (BOOL)isPureInt;
/*判断是否为浮点形*/
- (BOOL)isPureFloat;
/**判断是不是 long long 长整数 */
- (BOOL)isPureLongLong;
/**判断是不是 Bool */
- (BOOL)isPureBool;

/** 去掉相同的类 */
- (BOOL)isNewClassWithInterfaceClassName:(NSString *)interfaceClassName;



@end
