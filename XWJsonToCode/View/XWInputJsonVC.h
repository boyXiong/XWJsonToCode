//
//  XWInputJsonVC.h
//  XWJsonToCode
//
//  Created by key on 15/7/24.
//  Copyright (c) 2015年 熊  伟. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface XWInputJsonVC : NSWindowController

/** 让退出作为快捷键检查 */
- (void)beginTest;

/** 是否 show */
@property (nonatomic, assign, getter=isShowFlag) BOOL  showFlag;


@end
