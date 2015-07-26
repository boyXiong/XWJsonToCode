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

   //[NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    return resultDic;
}

/** 转换等级 也就是遍历出来后，生成代码 */
//- (NSDictionary *)convertLevel{
//
//    NSDictionary *json = self;
//
//    NSMutableArray *modesM = [NSMutableArray array];
//
//    //得到词典中所有KEY值
//    NSEnumerator * enumeratorKey = [json keyEnumerator];
//
//    //得到字典中的Value值
//    NSEnumerator * enumeratorValue = [json objectEnumerator];
//
//    //快速枚举遍历所有Value的值
//
//    for (id obj in enumeratorValue) {
//
//        id keyObj = enumeratorKey.nextObject;
//
//        XWModel *model = [[XWModel alloc] init];
//
//        if ([obj isKindOfClass:[NSString class]]) {
//
//            XWLog(@"key:%@, value:%@", keyObj, obj);
//
//            model.name = keyObj;
//            model.type = stringType;
//
//        }else if([obj isKindOfClass:[NSNumber class]]){
//
//            XWLog(@"key:%@, value:%@", keyObj, obj);
//
//            model.name = keyObj;
//            model.type = numberType;
//
//        }else if ([obj isKindOfClass:[NSArray class]]) {
//
//            XWLog(@"key:%@, value:%@", keyObj, obj);
//
//            model.name = keyObj;
//            model.type = arrayType;
//        }else if ([obj isKindOfClass:[NSDictionary class]]){
//
//            XWLog(@"key:%@, value:%@", keyObj, obj);
//
//            model.name = keyObj;
//            model.type = dictionaryType;
//            
//        }
//
//        [modesM addObject:model];
//    }
//
//    XWLog(@"%@", modesM);
//
//    return self;
//}




@end
