//
//  XWPrintCodeWC.m
//  XWJsonToCode
//
//  Created by key on 16/2/19.
//  Copyright © 2016年 熊  伟. All rights reserved.
//

#import "XWPrintCodeWC.h"

@interface XWPrintCodeWC ()

@property (unsafe_unretained) IBOutlet NSTextView *PrintCodeTextViewH;


@property (unsafe_unretained) IBOutlet NSTextView *PrintCodeTextViewM;

@end

@implementation XWPrintCodeWC

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PrintCode:) name:kNotiPrintCode object:nil];
}

- (void)PrintCode:(NSNotification *)noti{
    
    NSDictionary *codeDict = noti.userInfo;
    
    self.PrintCodeTextViewH.string = codeDict[codeHKey];
    self.PrintCodeTextViewM.string = codeDict[codeMKey];

}

@end
