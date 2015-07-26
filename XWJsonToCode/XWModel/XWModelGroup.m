//
//  XWModelGroup.m
//  XWJsonToCode
//
//  Created by key on 15/7/23.
//  Copyright (c) 2015年 熊  伟. All rights reserved.
//

#import "XWModelGroup.h"

@implementation XWModelGroup


- (NSString *)hText {

    return _hText ? _hText :  nil;
}

- (NSString *)mText {
    
    return  _mText ? _mText : nil;
}

- (NSString *)className{

    return _className ? _className : nil;
}

- (NSString *)description{
    
    return [NSString stringWithFormat:@"className:%@ , modelsM:%@", _className, _modelsM];
}



@end
