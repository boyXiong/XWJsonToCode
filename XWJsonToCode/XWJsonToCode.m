//
//  XWJsonToCode.m
//  XWJsonToCode
//
//  Created by key on 15/7/23.
//  Copyright (c) 2015年 熊  伟. All rights reserved.
//

#import "XWJsonToCode.h"
#import "XWInputJsonVC.h"
#import "XWMyConverTool.h"

#import "NSString+XW.h"
#import "NSDictionary+XW.h"
#import "NSTextView+XW.h"
#import "XWModel.h"
#import "XWModelGroup.h"

#import "XWUserTool.h"
#import "XWPrintCodeWC.h"



@interface XWJsonToCode ()

@property (nonatomic, strong) XWInputJsonVC * inputJsonVC;

@property (nonatomic, strong) XWPrintCodeWC * printCodeWC;

@property (nonatomic, strong)  NSTextView * currentView;

@property (nonatomic , copy) NSString * currentFilePath;

@property (nonatomic , copy) NSString * currentFilePathDocument;

@property (nonatomic, assign, getter=isNeedSelectedTextView) bool needSelectedTextView;

@property (nonatomic, strong) NSAlert * infoAlery;



@end

@implementation XWJsonToCode

#pragma mark - pluginDidLoad 估计每个插件运行的时候，都会调用这个方法，所以必须名字一样，应该是系统方法
+ (void) pluginDidLoad: (NSBundle*) plugin {
    [self shared];
}

#pragma mark - shared 单例对象
+(id) shared {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - init 初始化
- (id)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidFinishLaunching:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];
    }
    return self;
}

#pragma mark - applicationDidFinishLaunching 当Xcode,完全启动完毕后，调用的方法
- (void) applicationDidFinishLaunching: (NSNotification*) noti {

    //1 监听用户选择NSTextView的改变，来拿到当前的currentView
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationInfo:) name:NSTextViewDidChangeSelectionNotification object:nil];

    //2 监听用户编辑的，获取当前文件所在的位置
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationInfo:) name:@"IDEEditorDocumentDidChangeNotification" object:nil];

    //3 监听到用户确认点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createDocument:) name:kNotiSureJsonName object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputJsonVCDelalloc) name:kNotiInputJsonVCDelalloc object:self.inputJsonVC];

    //4 设置菜单
    [self addSettingMenu];

    //5 判断标志,表示用户当前如果是在输入json 也就是 input json 的文本框，就已之前的文本框为准
    self.needSelectedTextView = YES;

    /** 默认是加入 MJExtension 代码 */
    [XWUserTool toolSaveKey:kIsAddMJExtension value:@(YES)];


}

#pragma mark - 设置 菜单栏
-(void) addSettingMenu
{
    //1. 获取到Xcode 导航条的Windows 选项菜单
    NSMenuItem *editMenuItem = [[NSApp mainMenu] itemWithTitle:@"Window"];

    //2. 如果获取到
    if (editMenuItem) {

        //2.1 增加一条划线
        [[editMenuItem submenu] addItem:[NSMenuItem separatorItem]];

        //2.2 添加用户偏好测试选项，并增加快捷键
        NSMenuItem *newMenuItem = [[NSMenuItem alloc] initWithTitle:@"XWJsonToCode" action:@selector(showJsonToCodeSet:) keyEquivalent:@"V"];

        //2.3 添加点击事件
        [newMenuItem setTarget:self];
        [[editMenuItem submenu] addItem:newMenuItem];


    }
}

#pragma mark - lazy
- (XWInputJsonVC *)inputJsonVC{
    if (nil == _inputJsonVC) {
        _inputJsonVC = [[XWInputJsonVC alloc] initWithWindowNibName:@"XWInputJsonVC"];
    }
    return _inputJsonVC;
}


- (XWPrintCodeWC *)printCodeWC{
    if (nil == _printCodeWC) {
        _printCodeWC = [[XWPrintCodeWC alloc] initWithWindowNibName:@"XWPrintCodeWC"];
    }
    return _printCodeWC;
}

#pragma mark - 点击设置后, 显示的界面
-(void) showJsonToCodeSet:(NSNotification *)noti {
    
    if (self.inputJsonVC.showFlag){
        self.needSelectedTextView = YES;
        [self.inputJsonVC close];
//        [self.inputJsonVC beginTest];
        
    }else{
        NSLog(@"boyxiong:进来了  showJsonToCodeSet");
//        self.needSelectedTextView = NO;
        [self.inputJsonVC showWindow:self.inputJsonVC];
        self.inputJsonVC.showFlag = YES;
    }
}


#pragma mark - 根据用户键盘按键 来确认操作
- (void)notificationInfo:(NSNotification *)noti {
    
    NSLog(@"boyxiong:进来了");

    // 1 如果需要 重新选择 TextView 就进入
    if (self.isNeedSelectedTextView) {
        
        if ([noti.name isEqualToString:NSTextViewDidChangeSelectionNotification]) {
            if ([noti.object isKindOfClass:[NSTextView class]]) {
                NSTextView *text = (NSTextView *)noti.object;
                self.currentView = text;
            }

            //2.得到 当前选择的文件路径
        }else if ([noti.name isEqualToString:@"IDEEditorDocumentDidChangeNotification"]){

            //Track the current open paths
            NSObject *array = noti.userInfo[@"IDEEditorDocumentChangeLocationsKey"];

            NSURL *url = [[array valueForKey:@"documentURL"] firstObject];
            if (![url isKindOfClass:[NSNull class]]) {
                NSString *path = [url absoluteString];

                self.currentFilePath = path;
                
                NSLog(@"boyxiong: %@", path);
            }
        }
    }

}


- (NSAlert *)infoAlery{
    if (nil == _infoAlery) {
        _infoAlery = [[NSAlert alloc] init];
        _infoAlery.messageText = @"提示";
        
        [_infoAlery addButtonWithTitle:@"取消"];
        [_infoAlery addButtonWithTitle:@"我确认就是这个文件"];
    }
    return _infoAlery;
}


#pragma mark - 生成文档
- (void)createDocument:(NSNotification *)noti{
    
    self.currentFilePathDocument = [self.currentFilePath documentPath];
    
    __block NSString *currentClassName = [self.currentFilePath substringFromIndex:(self.currentFilePathDocument.length + 1)];

    //1.如果发现没有，那就需要提示用户选择
    if (![self.currentView isKindOfClass:[NSTextView class]] || !self.currentFilePath) {
        
        NSAlert *info = [[NSAlert alloc] init];
        info.messageText = @"信息";
        info.informativeText = @"请在右边栏, 选中对应的模型文件, 确认类名";
        [info runModal];
        return;
        
    //2.发现文件的代码过多，也就是不是新建的模型文件，有可能选错了文件，提示用户
    }else if (self.currentView.string.length > 20 ){
        
        
        NSString *infoStr = [NSString stringWithFormat:@"要生成代码的文件是:\n %@ \n 如果是这个文件,可以点\"我确认就是这个文件\"", [currentClassName substringFromIndex:2]];
        
        
        self.infoAlery.informativeText = infoStr;
        
        NSModalResponse returnCode = [self.infoAlery runModal];
    
    
        if (returnCode == NSAlertFirstButtonReturn) {
            return;
        }

        [self ensureCreadCode:noti];
        
        
    } else {
        
        
        [self ensureCreadCode:noti];

    }
}

//确认创建代码
- (void)ensureCreadCode:(NSNotification *)noti{
    
    NSString *currentClassName = [self.currentFilePath substringFromIndex:(self.currentFilePathDocument.length + 1)];
    
    //2.获得用户输入的json 字典
    NSDictionary *jsonDict = noti.userInfo;
    
    //3.产生所有类模型
    NSArray *jsonArray = [XWMyConverTool toolConvertLevel:jsonDict];
    
    NSLog(@"boyxiong 01 :jsonArray%@", jsonArray);
    
    
    //4.获取到当前的第一个类，然后给类名
    XWModelGroup *OneGroup = jsonArray[0];
    
    NSLog(@"boyxiong 02 : %@", OneGroup);
    
    currentClassName = [currentClassName substringFromIndex:2];
    
    OneGroup.className = [currentClassName substringToIndex:currentClassName.length - 2];
    
    
    NSLog(@"boyxiong 03 : %@", OneGroup);

    
    //5.得到所有类的 h 文件，和 m 文件的 内容
    
    BOOL flag = [[XWUserTool toolGetValueForKey:kIsCreatFile] boolValue];
    
    if (!flag) {
        
        NSArray *documentationArray = [XWMyConverTool toolGetcoderHM:jsonArray];
        
        NSLog(@"boyxiong:array: %@", documentationArray);
        
        NSString *hText = hTextHeader;
        
        NSString *mText = [NSString stringWithFormat:@"\n#import \"%@.h\"\n", OneGroup.className];
        
        BOOL isAddMjCode = [[XWUserTool toolGetValueForKey:kIsAddMJExtension] boolValue];
        
        if (isAddMjCode) {
            
            mText = [NSString stringWithFormat:@"%@#import \"MJExtension.h\"\n", mText];
            
        }
        
//        6.生成所有文件
        for (XWModelGroup * modelGroup in documentationArray){
            
            if (modelGroup.className && modelGroup.hText) {
                
                hText = [NSString stringWithFormat:@"%@%@", hText , modelGroup.hText];
                mText = [NSString stringWithFormat:@"%@%@", mText, modelGroup.mText];
            }
        }
        
        
        NSLog(@"boyxiong:OK: %@", documentationArray);

        NSString *hFilePath = [self.currentFilePathDocument stringByAppendingString:[NSString stringWithFormat:@"/%@.h", OneGroup.className]];
        
        NSURL *writeUrl = [NSURL URLWithString:hFilePath];
        
        
//        [hText writeToURL:writeUrl atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        
        NSString *mFilePath = [self.currentFilePathDocument stringByAppendingString:[NSString stringWithFormat:@"/%@.m", OneGroup.className]];
        
        NSURL *mWriteUrl = [NSURL URLWithString:mFilePath];
        
//        [mText writeToURL:mWriteUrl atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        
#pragma mark -  新版是用 复制 粘贴 不 直接写入
        NSDictionary *codeDict = @{codeHKey : hText,
                                   codeMKey : mText};
        
        [self.printCodeWC showWindow:self.printCodeWC];
        
        
//        发送通知
        [[NSNotificationCenter  defaultCenter] postNotificationName:kNotiPrintCode object:nil userInfo:codeDict];
        
        
        
        
        
        NSAlert *info = [[NSAlert alloc] init];
        info.messageText = @"Sucess";
        info.informativeText = @"已经生成对应的代码,复制粘贴，就可以了";
        [info runModal];
        
        
        
    }else{
        NSArray *documentationArray = [XWMyConverTool toolGetCoderDocument:jsonArray];
        
        //6.生成所有文件
        for (XWModelGroup * modelGroup in documentationArray){
            
            
            if (modelGroup.className && modelGroup.hText) {
                
                if (self.currentFilePathDocument) {
                    
                    NSString *hFilePath = [self.currentFilePathDocument stringByAppendingString:[NSString stringWithFormat:@"/%@.h", modelGroup.className]];
                    
                    NSURL *writeUrl = [NSURL URLWithString:hFilePath];
                    
                    
                    [modelGroup.hText writeToURL:writeUrl atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    
                    
                    NSString *mFilePath = [self.currentFilePathDocument stringByAppendingString:[NSString stringWithFormat:@"/%@.m", modelGroup.className]];
                    
                    NSURL *mWriteUrl = [NSURL URLWithString:mFilePath];
                    
                    [modelGroup.mText writeToURL:mWriteUrl atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    
                }
                
            }
        }
        
//        NSAlert *info = [[NSAlert alloc] init];
//        info.messageText = @"Sucess";
//        NSString *infoStr = [NSString stringWithFormat:@"已经生产模型文件,在当前文件的目录下:%@", [currentClassName substringFromIndex:2]];
//        info.informativeText = infoStr;
//        [info runModal];
        
        NSAlert *info = [[NSAlert alloc] init];
        info.messageText = @"Sucess";
        NSString *infoStr = [NSString stringWithFormat:@"已经生成对应的代码,复制粘贴，就可以了"];
        info.informativeText = infoStr;
        [info runModal];
        
    }
    self.needSelectedTextView = YES;
}




#pragma mark - 通知
- (void)inputJsonVCDelalloc{
    self.needSelectedTextView = YES;
}
#pragma mark - - (BOOL)alertShowHelp:(NSAlert *)alert;
//- (BOOL)alertShowHelp:(NSAlert *)alert{
//
//
//}

@end
