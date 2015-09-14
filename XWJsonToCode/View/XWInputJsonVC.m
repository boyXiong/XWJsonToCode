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


@interface XWInputJsonVC () <NSTextFieldDelegate>


@property (weak) IBOutlet NSScrollView *jsonTextView;

@property (unsafe_unretained) IBOutlet NSTextView *inputJsonTextView;


/** perfernce Setting */

@property (weak) IBOutlet NSButton *addExtentionBtn;

@property (weak) IBOutlet NSButton *singleClassCreateFileBtn;


@property (weak) IBOutlet NSTextField *setPrefixClassNameText;

@end



static bool addMJExtension = NO;
static bool createDocument = NO;

@implementation XWInputJsonVC

- (void)windowDidLoad {
    [super windowDidLoad];

    self.setPrefixClassNameText.delegate =self;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:NSTextDidChangeNotification object:self.setPrefixClassNameText];

    NSString *per = [XWUserTool toolGetValueForKey:kUserSetPerClassName];

    if (per) {

        self.setPrefixClassNameText.stringValue = per;
    }

    [XWUserTool toolSaveKey:kIsAddMJExtension value:@(addMJExtension)];
    [XWUserTool toolSaveKey:kIsCreatFile value:@(createDocument)];

    self.addExtentionBtn.state = addMJExtension;
    self.singleClassCreateFileBtn.state = createDocument;

}

- (IBAction)confirmClicked:(id)sender {


    NSString *string = self.inputJsonTextView.string;
    NSString *json = [string convert];

    id  jsonDict = [NSDictionary dictionaryWithJsonString:json];

    if ([jsonDict isKindOfClass:[NSError class]]) {
        NSAlert *info = [[NSAlert alloc] init];
        info.messageText = @"格式错误";
        info.informativeText = @"Json format Error";
        [info runModal];
        return;
    }


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

        NSString *perferClassName = self.setPrefixClassNameText.currentEditor.string;;

        [XWUserTool toolSaveKey:kUserSetPerClassName value:perferClassName];
        [XWUserTool toolGetValueForKey:kUserSetPerClassName];


        self.setPrefixClassNameText.placeholderString = perferClassName;
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

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)controlTextDidChange:(NSNotification *)obj{



        NSString *perferClassName = self.setPrefixClassNameText.currentEditor.string;;

        [XWUserTool toolSaveKey:kUserSetPerClassName value:perferClassName];
        [XWUserTool toolGetValueForKey:kUserSetPerClassName];


        self.setPrefixClassNameText.placeholderString = perferClassName;

}




@end
