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


@property (weak) IBOutlet NSScrollView *plistUrlView;


@property (unsafe_unretained) IBOutlet NSTextView *inputJsonTextView;

@property (unsafe_unretained) IBOutlet NSTextView *inputPlistUrl;

/** perfernce Setting */

@property (weak) IBOutlet NSButton *addExtentionBtn;

@property (weak) IBOutlet NSButton *singleClassCreateFileBtn;


@property (weak) IBOutlet NSTextField *setPrefixClassNameText;

@end



static bool addMJExtension = NO;
static bool createDocument = NO;

@implementation XWInputJsonVC


- (void)awakeFromNib{
    [self.inputPlistUrl setTextColor:[NSColor blackColor]];
    [self.inputJsonTextView setTextColor:[NSColor blackColor]];
    
}

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
    
    
    //1.判断有没有 plist 的路径
    NSString *plistUrlStr = self.inputPlistUrl.string;
    
    id jsonDict = nil;
    
    
    if (plistUrlStr.length > 2 ) {
        
        plistUrlStr = plistUrlStr.convert;
        
        plistUrlStr = [NSString stringWithFormat:@"file:%@", plistUrlStr];
        
       NSString *uft8Str = [NSString stringWithCString:[plistUrlStr UTF8String] encoding:NSUTF8StringEncoding];
        
        
        NSURL *plistUrl = [NSURL URLWithString:uft8Str];
        

        jsonDict = [NSDictionary dictionaryWithContentsOfURL:plistUrl];
        
//        NSLog(@"%@", jsonDict);
        
        
    }else {
    
        //2.如果没有url 那么就判断json有没有输入
        NSString *string = self.inputJsonTextView.string;
        NSString *json = [string convert];

        jsonDict = [NSDictionary dictionaryWithJsonString:json];
        
        

    }
    
    if ([jsonDict isKindOfClass:[NSError class]]) {
        
        NSAlert *info = [[NSAlert alloc] init];
        info.messageText = @"info";
        info.informativeText = plistUrlStr.length < 2 ? @"JSON 格式 错误(Json format Error" : @"plist 路径 不对 " ;
        [info runModal];
        return;
    }else if ([jsonDict isKindOfClass:[NSArray class]]){
        
        NSAlert *info = [[NSAlert alloc] init];
        info.messageText = @"info";
        info.informativeText = @"目前不支持以数组开头";
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
    self.showFlag = NO;
    self.inputJsonTextView.string = @"";
    self.inputPlistUrl.string = @"";
     [[NSNotificationCenter defaultCenter] postNotificationName:kNotiInputJsonVCDelalloc object:nil];
    
    [super close];
    
}

- (void)dismissController:(id)sender{
     [[NSNotificationCenter defaultCenter] postNotificationName:kNotiInputJsonVCDelalloc object:nil];
    
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

    [[NSNotificationCenter defaultCenter] postNotificationName:kNotiInputJsonVCDelalloc object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)controlTextDidChange:(NSNotification *)obj{



        NSString *perferClassName = self.setPrefixClassNameText.currentEditor.string;;

        [XWUserTool toolSaveKey:kUserSetPerClassName value:perferClassName];
        [XWUserTool toolGetValueForKey:kUserSetPerClassName];


        self.setPrefixClassNameText.placeholderString = perferClassName;

}

- (void)beginTest{
    
    if (self.inputJsonTextView.string.length > 0 || self.inputPlistUrl.string.length  > 0) {
        [self confirmClicked:nil];
    }else{
        [self close];
    }
    
}





@end
