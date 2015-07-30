//
//  XWMyConverTool.h
//  XWJsonToCode
//
//  Created by key on 15/7/23.
//  Copyright (c) 2015年 熊  伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XWMyConverTool : NSObject

/** 转换层级关系 */
+ (NSArray *)toolConvertLevel:(NSDictionary *)json;

/** 归档的文件 */
+ (NSArray *)toolGetCoderDocument:(NSArray *)jsonArray;

+ (NSArray *)toolGetcoderHM:(NSArray *)jsonArray;

@end
