//
//  XWModelGroup.h
//  XWJsonToCode
//
//  Created by key on 15/7/23.
//  Copyright (c) 2015年 熊  伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XWModel.h"

@interface XWModelGroup : NSObject

@property (nonatomic, copy) NSString* className;

@property (nonatomic, strong) NSMutableArray * modelsM;

/** 文件类容 */
@property (nonatomic, copy) NSString* hText;

@property (nonatomic , copy) NSString * mText;


@end
