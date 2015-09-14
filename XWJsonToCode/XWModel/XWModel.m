//
//  XWModel.m
//  XWJsonToCode
//
//  Created by key on 15/7/23.
//  Copyright (c) 2015年 熊  伟. All rights reserved.
//

#import "XWModel.h"

@implementation XWModel

+ (instancetype)modelWithName:(NSString *)name type:(NSString *)type className:(NSString *)className{

    XWModel *model = [[XWModel alloc] init];
    model.name = name;
    model.type = type;
    model.className = className;

    return model;
}

- (NSString *)className {

    return _className ? _className : _type;
}

- (NSString *)description{

    return [NSString stringWithFormat:@"name : %@, type : %@, className : %@ ", _name, _type, _className];
}

- (NSString *)name{
    
    if ([_name isEqualToString:@"id"]) {
        _name = @"Id";
    }
    return _name;
}


@end

