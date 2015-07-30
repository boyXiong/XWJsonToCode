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
#import "XWUserTool.h"


@interface XWInputJsonVC ()<NSTextFieldDelegate>


@property (weak) IBOutlet NSScrollView *jsonTextView;

@property (unsafe_unretained) IBOutlet NSTextView *inputJsonTextView;


/** perfernce Setting */
@property (weak) IBOutlet NSTextField *classNamePreferText;

@property (weak) IBOutlet NSButton *addExtentionBtn;

@property (weak) IBOutlet NSButton *singleClassCreateFileBtn;

@end



static bool addMJExtension = YES;
static bool createDocument = YES;

@implementation XWInputJsonVC

- (void)windowDidLoad {
    [super windowDidLoad];
    

    self.classNamePreferText.delegate = self;

    NSString *per = [XWUserTool toolGetValueForKey:kUserSetPerClassName];

    if (per) {

        self.classNamePreferText.stringValue = per;
    }

    [XWUserTool toolSaveKey:kIsAddMJExtension value:@(addMJExtension)];
    [XWUserTool toolSaveKey:kIsCreatFile value:@(createDocument)];

    self.addExtentionBtn.state = addMJExtension;
    self.singleClassCreateFileBtn.state = createDocument;
    
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


#pragma mark - NSTextView Delegate
- (void)textDidChange:(NSNotification *)notification{

    if ([notification isKindOfClass:[NSTextField class]]) {

        NSString *perferClassName = self.classNamePreferText.currentEditor.string;
        ;

        [XWUserTool toolSaveKey:kUserSetPerClassName value:perferClassName];

        self.classNamePreferText.placeholderString = perferClassName;
    }
}


- (IBAction)addMjextensionClicked:(NSButton *)sender {

    addMJExtension = !addMJExtension;

    [XWUserTool toolSaveKey:kIsAddMJExtension value:@(addMJExtension)];
    [XWUserTool toolGetValueForKey:kIsAddMJExtension];

    self.addExtentionBtn.state = addMJExtension;

}

- (IBAction)singleClassCreateFileClicked:(NSButton *)sender {

    createDocument = !createDocument;

    [XWUserTool toolSaveKey:kIsCreatFile value:@(createDocument)];
    [XWUserTool toolGetValueForKey:kIsCreatFile];

    self.singleClassCreateFileBtn.state = createDocument;
}




@end
