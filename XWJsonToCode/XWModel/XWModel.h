//
//  XWModel.h
//  XWJsonToCode
//
//  Created by key on 15/7/23.
//  Copyright (c) 2015年 熊  伟. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XWModel : NSObject

/** 存放属性名 */
@property (nonatomic , copy) NSString * name;

/** 属性的类型 */
//@property (nonatomic , copy) NSString * type;

@property (nonatomic, copy)  NSString * type;

/** 如果是字典，那么就应该是 类的类型 */
@property (nonatomic, copy) NSString * className;

+ (instancetype)modelWithName:(NSString *)name type:(NSString *)type className:(NSString *)className;

@end


