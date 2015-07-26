//
//  NSTextView+XW.m
//  XWJsonToCode
//
//  Created by key on 15/7/24.
//  Copyright (c) 2015年 熊  伟. All rights reserved.
//

#import "NSTextView+XW.h"

@implementation NSTextView (XW)

- (NSInteger)getCurrentCurseLocation{
    
    return [[[self selectedRanges] objectAtIndex:0] rangeValue].location;
}



@end
