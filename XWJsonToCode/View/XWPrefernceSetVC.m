//
//  XWPrefernceSetVC.m
//  XWJsonToCode
//
//  Created by key on 15/7/23.
//  Copyright (c) 2015年 熊  伟. All rights reserved.
//

#import "XWPrefernceSetVC.h"
#import "XWUserTool.h"

@interface XWPrefernceSetVC ()<NSTextFieldDelegate>


@property (weak) IBOutlet NSTextField *classNamePreferText;


@property (weak) IBOutlet NSButton *addExtentionBtn;



@end

@implementation XWPrefernceSetVC

static bool addMJExtension = YES;
static bool createDocument = YES;

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

}



- (void)textDidChange:(NSNotification *)notification{

    if ([notification isKindOfClass:[NSTextField class]]) {

        NSString *perferClassName = self.classNamePreferText.currentEditor.string;
        ;

        [XWUserTool toolSaveKey:kUserSetPerClassName value:perferClassName];

        self.classNamePreferText.placeholderString = perferClassName;


    }

}



- (IBAction)addMJExtensionClicked:(NSButton *)sender {

    addMJExtension = !addMJExtension;

    [XWUserTool toolSaveKey:kIsAddMJExtension value:@(addMJExtension)];
    [XWUserTool toolGetValueForKey:kIsAddMJExtension];

    self.addExtentionBtn.state = addMJExtension;


}



#pragma mark - NSTextField delegate
-(void)controlTextDidChange:(NSNotification *)notification{
    
    
    [XWUserTool toolSaveKey:kUserSetPerClassName value:self.classNamePreferText.stringValue];
}



@end
