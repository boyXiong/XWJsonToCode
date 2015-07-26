//
//  XWUserTool.m
//  XWJsonToCode
//
//  Created by key on 15/7/24.
//  Copyright (c) 2015年 熊  伟. All rights reserved.
//

#import "XWUserTool.h"

@implementation XWUserTool

+ (void)toolSaveKey:(NSString *)key value:(id)value{

    NSDictionary *dict = @{key : value};

    [[NSUserDefaults standardUserDefaults] registerDefaults:dict];

    sync();

}

+ (id)toolGetValueForKey:(NSString *)key{

    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}


@end
