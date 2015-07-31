//
//  NSDictionary+XW.m
//  01-testOXAPP
//
//  Created by key on 15/7/20.
//  Copyright (c) 2015年 XiongWei. All rights reserved.
//

#import "NSDictionary+XW.h"
//#import "XWModel.h"

@implementation NSDictionary (XW)

/** 根据字符串返回一个json 字典 */
+ (NSDictionary *)dictionaryWithString:(NSString *)string{

    XWLog(@"requestTmp:%@", string);

    NSData *resData = [[NSData alloc] initWithData:[string dataUsingEncoding:NSUTF8StringEncoding]];

    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];

    return resultDic;
}

+ (id)dictionaryWithJsonString:(NSString *)String{

    String = [[String stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSData *jsonData = [String dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id dicOrArray = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingMutableContainers
                                                      error:&err];
    if (err) {
        return err;
    }else{
        return dicOrArray;
    }
    
}




@end
