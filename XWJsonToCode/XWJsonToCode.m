//
//  XWJsonToCode.m
//  XWJsonToCode
//
//  Created by key on 15/7/23.
//  Copyright (c) 2015年 熊  伟. All rights reserved.
//

#import "XWJsonToCode.h"
#import "XWPrefernceSetVC.h"
#import "XWInputJsonVC.h"
#import "XWMyConverTool.h"

#import "NSString+XW.h"
#import "NSDictionary+XW.h"
#import "NSTextView+XW.h"
#import "XWModel.h"
#import "XWModelGroup.h"

#import "XWUserTool.h"



@interface XWJsonToCode ()

@property (nonatomic, strong) XWPrefernceSetVC * prefernceSet;

@property (nonatomic, strong) XWInputJsonVC * inputJsonVC;

@property (nonatomic, strong)  NSTextView * currentView;

@property (nonatomic , copy) NSString * currentFilePath;

@property (nonatomic , copy) NSString * currentFilePathDocument;

@property (nonatomic, assign, getter=isNeedSelectedTextView) bool needSelectedTextView;


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
        NSMenuItem *newMenuItem = [[NSMenuItem alloc] initWithTitle:@"XWJsonToCodeSetting" action:@selector(showPrefreSet:) keyEquivalent:@"X"];

        //2.3 添加点击事件
        [newMenuItem setTarget:self];
        [[editMenuItem submenu] addItem:newMenuItem];


        //2.4 添加输入Json
        NSMenuItem *clickItem = [[NSMenuItem alloc] initWithTitle:@"XWJson Input Your Json" action:@selector(showInputSet:) keyEquivalent:@"V"];

        //2.5 添加 点击事件
        [clickItem setTarget:self];

        //2.6 添加到菜单
        [[editMenuItem submenu] addItem:clickItem];

    }
}

#pragma mark - 点击设置后, 显示的界面
-(void) showPrefreSet:(NSNotification *)noti {
    self.prefernceSet = [[XWPrefernceSetVC alloc] initWithWindowNibName:@"XWPrefernceSetVC"];
    [self.prefernceSet showWindow:self.prefernceSet];
}

-(void) showInputSet:(NSNotification *)noti {

    self.needSelectedTextView = NO;

    self.inputJsonVC = [[XWInputJsonVC alloc] initWithWindowNibName:@"XWInputJsonVC"];
    [self.inputJsonVC showWindow:self.inputJsonVC];
}


#pragma mark - 根据用户键盘按键 来确认操作
- (void)notificationInfo:(NSNotification *)noti {

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
            }
        }
    }

}



#pragma mark - 生成文档
- (void)createDocument:(NSNotification *)noti{

    //1.如果发现没有，那就需要提示用户选择
    if (![self.currentView isKindOfClass:[NSTextView class]] || !self.currentFilePath) {
        NSAlert *info = [[NSAlert alloc] init];
        info.informativeText = @"Please selected current mode .h file";
        [info runModal];
        return;
    }

    //2.获得用户输入的json 字典
    NSDictionary *jsonDict = noti.userInfo;

    //3.产生所有类模型
    NSArray *jsonArray = [XWMyConverTool toolConvertLevel:jsonDict];


    //4.获取到当前的第一个类，然后给类名
    XWModelGroup *OneGroup = jsonArray[0];
    self.currentFilePathDocument = [self.currentFilePath documentPath];
    NSString *currentClassName = [self.currentFilePath substringFromIndex:(self.currentFilePathDocument.length + 1)];
    currentClassName = [currentClassName substringFromIndex:2];

    OneGroup.className = [currentClassName substringToIndex:currentClassName.length - 2];

    //5.得到所有类的 h 文件，和 m 文件的 内容
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

    NSAlert *info = [[NSAlert alloc] init];
    info.informativeText = @"已经生产模型文件,在当前文件的目录下";
    [info runModal];

    self.needSelectedTextView = YES;

}
@end
