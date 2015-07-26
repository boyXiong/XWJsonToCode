//
//  XWUserTool.h
//  XWJsonToCode
//
//  Created by key on 15/7/24.
//  Copyright (c) 2015年 熊  伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XWUserTool : NSObject

+ (void)toolSaveKey:(NSString *)key value:(id)value;

+ (id)toolGetValueForKey:(NSString *)key;


@end
