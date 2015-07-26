//
//  XWInputJsonVC.m
//  XWJsonToCode
//
//  Created by key on 15/7/24.
//  Copyright (c) 2015年 熊  伟. All rights reserved.
//

#import "XWInputJsonVC.h"
#import "XWMyConverTool.h"
#import "NSString+XW.h"
#import "NSDictionary+XW.h"

@interface XWInputJsonVC ()


@property (weak) IBOutlet NSScrollView *jsonTextView;

@property (unsafe_unretained) IBOutlet NSTextView *inputJsonTextView;


@end

@implementation XWInputJsonVC

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)confirmClicked:(id)sender {


    NSString *string = self.inputJsonTextView.string;
    NSString *json = [string convert];

    NSDictionary *jsonDict = [NSDictionary dictionaryWithString:json];

    if (!jsonDict) {
        NSAlert *info = [[NSAlert alloc] init];
        info.informativeText = @"Json format Error";
        [info runModal];
        return;
    }

    //1.发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotiSureJsonName object:nil userInfo:jsonDict];

    [self close];


}

- (IBAction)cancel:(id)sender {

    [self close];

}

- (void)close{
    [super close];
}



@end
