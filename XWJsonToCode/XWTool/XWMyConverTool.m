//
//  XWMyConverTool.m
//  XWJsonToCode
//
//  Created by key on 15/7/23.
//  Copyright (c) 2015年 熊  伟. All rights reserved.
//

#import "XWMyConverTool.h"
#import "XWModelGroup.h"
#import "NSString+XW.h"
#import "XWUserTool.h"

static NSMutableArray *resultM;

@implementation XWMyConverTool


+ (NSArray *)toolConvertLevel:(NSDictionary *)json{


    resultM = [NSMutableArray array];
    
    converLevel(json, nil);

    return resultM.count > 0 ? resultM : nil;

}



#pragma mark - 直接 coder
+ (NSString *)toolGetCoder:(NSArray *)jsonArray{

    NSMutableString *coder = [NSMutableString string];

    //#warning 接下来，是重点了
    for (XWModelGroup *group in jsonArray) {

        NSMutableString *tmpCoder = [NSMutableString string];

        //如果这组有类名，就添加 interface
        if (nil != group.className) {

            //            NSString *format = [NSString stringWithFormat:@"%@%@%@", newLine, classInterface, newLine];
            NSString *format = [NSString stringWithFormat:@"%@", classInterface];

            NSString *tmp = [NSString stringWithFormat:format, group.className];

            if ([coder isNewClassWithInterfaceClassName:tmp]) {

                [tmpCoder appendString:[NSString stringWithFormat:format, group.className]];


            }else{
                continue;
            }

        }

        for (XWModel * model in group.modelsM) {

            //           这里可以优化 ，可以用 变量代替

            NSString *format = @"";


            if ([model.type isEqualToString:[stringType copy]]) {

                format = [NSString stringWithFormat:@"%@",classPropertyCopy];

                [tmpCoder appendString:[NSString stringWithFormat:format, model.name]];
            }else if ([model.type isEqualToString:[arrayType copy]]) {

                format = [NSString stringWithFormat:@"%@",classPropertyStrong];

                [tmpCoder appendString:[NSString stringWithFormat:format, model.name]];
            }else if([model.type isEqualToString:[numberType copy]]) {

                format = [NSString stringWithFormat:@"%@",classPropertyAssign];


                [tmpCoder appendString:[NSString stringWithFormat:format, model.name]];
            }else if([model.type isEqualToString:[intType copy]]) {

                format = [NSString stringWithFormat:@"%@",classPropertyAssignNoStar];

                [tmpCoder appendString:[NSString stringWithFormat:format, intType,  model.name]];

            }else if([model.type isEqualToString:[longlongType copy]]) {

                format = [NSString stringWithFormat:@"%@",classPropertyAssignNoStar];

                [tmpCoder appendString:[NSString stringWithFormat:
                                        format, intType,  model.name]];


            }else if([model.type isEqualToString:[floatType copy]]) {

                format = [NSString stringWithFormat:@"%@",classPropertyAssignNoStar];


                [tmpCoder appendString:[NSString stringWithFormat:format, floatType,  model.name]];

            }else if([model.type isEqualToString:[BOOLType copy]]) {

                format = [NSString stringWithFormat:@"%@",classPropertyAssignNoStar];

                [tmpCoder appendString:[NSString stringWithFormat:format, BOOLType,  model.name]];
            }else {

                format = [NSString stringWithFormat:@"%@",classPropertyStrongNoArray];


                [tmpCoder appendString:[NSString stringWithFormat:format, model.className,  model.name]];
            }
        }
        
        // 追加一个 @end
        
        NSString * formatEnd = [NSString stringWithFormat:@"%@",classEnd];
        
        [tmpCoder appendString:formatEnd];
        
        //如果这是新建立的一个类，那么加 实现
        if (nil != group.className) {
            
            NSString * format = [NSString stringWithFormat:@"%@",classImplementation];
            
            [tmpCoder appendString:[NSString stringWithFormat:format, group.className]];
            
            
            [tmpCoder appendString:formatEnd];
        }
        [coder appendString:tmpCoder];
    }
    return coder;
    
}

+ (NSArray *)toolGetcoderHM:(NSArray *)jsonArray{

    NSMutableString *coder = [NSMutableString string];

    for (XWModelGroup *group in jsonArray) {

        NSMutableString *tmpCoder = [NSMutableString string];

        NSMutableString *hTextCode = [NSMutableString string];

        NSMutableString *classNameString = [NSMutableString string];

        [classNameString appendString:hTextHeaderInfoClass];

        NSMutableArray *classNameM = [NSMutableArray array];

        NSMutableString *mTextCode = [NSMutableString string];

        NSString *addMjCode = @"";

        if (nil != group.className) {

            NSString *format = [NSString stringWithFormat:@"%@", classInterface];

            NSString *tmp = [NSString stringWithFormat:format, group.className];

            if ([coder isNewClassWithInterfaceClassName:tmp]) {

                [tmpCoder appendString:[NSString stringWithFormat:format, group.className]];


                [hTextCode appendString:[NSString stringWithFormat:format, group.className]];

            }else{
                continue;
            }

        }

        for (XWModel * model in group.modelsM) {

            // 这里可以优化 ，可以用 变量代替

            NSString *format = @"";


            if ([model.type isEqualToString:[stringType copy]]) {

                format = [NSString stringWithFormat:@"%@",classPropertyCopy];

                [tmpCoder appendString:[NSString stringWithFormat:format, model.name]];

                [hTextCode appendString:[NSString stringWithFormat:format, model.name]];


            }else if ([model.type isEqualToString:[arrayType copy]]) {

                format = [NSString stringWithFormat:@"%@",classPropertyStrong];

                [tmpCoder appendString:[NSString stringWithFormat:format, model.name]];

                [hTextCode appendString:[NSString stringWithFormat:format, model.name]];

                NSString *tmp = [NSString stringWithFormat:@"@\"%@\" : [%@ class],", model.name, model.className];

                addMjCode = [NSString stringWithFormat:@"%@%@",addMjCode, tmp];
                
                // 防止 null
                if (![model.className isEqualToString:stringType] && model.className.length > 0) {
                    
                    [classNameM addObject:model.className];
                }



            }else if([model.type isEqualToString:[numberType copy]]) {

                format = [NSString stringWithFormat:@"%@",classPropertyAssign];


                [tmpCoder appendString:[NSString stringWithFormat:format, model.name]];

                [hTextCode appendString:[NSString stringWithFormat:format, model.name]];

            }else if([model.type isEqualToString:[intType copy]]) {

                format = [NSString stringWithFormat:@"%@",classPropertyAssignNoStar];

                [tmpCoder appendString:[NSString stringWithFormat:format, intType,  model.name]];

                [hTextCode appendString:[NSString stringWithFormat:format, intType,  model.name]];


            }else if([model.type isEqualToString:[longlongType copy]]) {

                format = [NSString stringWithFormat:@"%@",classPropertyAssignNoStar];

                [tmpCoder appendString:[NSString stringWithFormat:format, longlongType,  model.name]];

                [hTextCode appendString:[NSString stringWithFormat:format, longlongType,  model.name]];



            }else if([model.type isEqualToString:[floatType copy]]) {

                format = [NSString stringWithFormat:@"%@",classPropertyAssignNoStar];


                [tmpCoder appendString:[NSString stringWithFormat:format, floatType,  model.name]];

                [hTextCode appendString:[NSString stringWithFormat:format, floatType,  model.name]];


            }else if([model.type isEqualToString:[BOOLType copy]]) {

                format = [NSString stringWithFormat:@"%@",classPropertyAssignNoStar];

                [tmpCoder appendString:[NSString stringWithFormat:format, BOOLType,  model.name]];

                [hTextCode appendString:[NSString stringWithFormat:format, BOOLType,  model.name]];

            }else {

                format = [NSString stringWithFormat:@"%@",classPropertyStrongNoArray];


                [tmpCoder appendString:[NSString stringWithFormat:format, model.className,  model.name]];

                [hTextCode appendString:[NSString stringWithFormat:format, model.className,  model.name]];


                [classNameString appendString:[NSString stringWithFormat:@"%@,",model.className]];
                
                //防止空
                if (model.className.length > 0) {
                    
                    [classNameM addObject:model.className];

                }

            }
        }

        NSString * formatEnd = [NSString stringWithFormat:@"%@",classEnd];
        if (group.className) {

            [tmpCoder appendString:formatEnd];

            [hTextCode appendString:formatEnd];

        }




        if (classNameM.count > 0) {

            NSString *statementClassName = hTextHeaderInfoClass;


            for (NSString *className in classNameM) {

                statementClassName = [NSString stringWithFormat:@"%@ %@,",statementClassName, className];


            }

            statementClassName = [statementClassName substringToIndex:statementClassName.length - 1];

            statementClassName = [NSString stringWithFormat:@"%@;\n",statementClassName];


            if (group.className) {

                NSInteger atIndex = 0;

                NSString *headerText = [hTextCode substringToIndex:atIndex];

                NSString *endText = [hTextCode substringFromIndex:atIndex];

                hTextCode = (NSMutableString *)[NSString stringWithFormat:@"%@\n%@%@", headerText, statementClassName, endText];

            }else {

                hTextCode = (NSMutableString *)[NSString stringWithFormat:@"%@%@", statementClassName,hTextCode];
            }

        }


        group.hText = hTextCode;


        if (addMjCode.length > 2) {

            addMjCode = [addMjCode substringToIndex:addMjCode.length - 1];

            NSString *addMjString = [NSString stringWithFormat:@"\n+ (NSDictionary *)objectClassInArray{ \n return @{%@};\n}\n",addMjCode ];

            addMjCode = addMjString;
        }


        if (nil != group.className) {

            if (addMjCode.length > 2) {

                BOOL flag = [[XWUserTool toolGetValueForKey:kIsAddMJExtension] boolValue];

                if (flag) {


                }
            }
            
            
            
            NSString * format = [NSString stringWithFormat:@"%@",classImplementation];
            
            [tmpCoder appendString:[NSString stringWithFormat:format, group.className]];
            
            
            [tmpCoder appendString:formatEnd];
            
            
            [mTextCode appendString:[NSString stringWithFormat:format, group.className]];
            
            if (addMjCode.length > 2) {
                
                BOOL flag = [[XWUserTool toolGetValueForKey:kIsAddMJExtension] boolValue];
                
                if (flag) {
                    [mTextCode appendString:addMjCode];
                }
            }
            
            
            [mTextCode appendString:formatEnd];
            
            group.mText = mTextCode;
            
        }
        [coder appendString:tmpCoder];
    }
    return jsonArray;


}




#pragma mark - 文档

+ (NSArray *)toolGetCoderDocument:(NSArray *)jsonArray{

    NSMutableString *coder = [NSMutableString string];

    for (XWModelGroup *group in jsonArray) {

        NSMutableString *tmpCoder = [NSMutableString string];

        NSMutableString *hTextCode = [NSMutableString string];

        NSMutableString *classNameString = [NSMutableString string];

        [classNameString appendString:hTextHeaderInfoClass];

        NSMutableArray *classNameM = [NSMutableArray array];

        NSMutableString *mTextCode = [NSMutableString string];

        NSString *addMjCode = @"";

        if (nil != group.className) {

            NSString *format = [NSString stringWithFormat:@"%@", classInterface];

            NSString *tmp = [NSString stringWithFormat:format, group.className];

            if ([coder isNewClassWithInterfaceClassName:tmp]) {

                [tmpCoder appendString:[NSString stringWithFormat:format, group.className]];

                [hTextCode appendString:@"\n#import <Foundation/Foundation.h>\n"];

                [hTextCode appendString:[NSString stringWithFormat:format, group.className]];

            }else{
                continue;
            }

        }

        for (XWModel * model in group.modelsM) {

            // 这里可以优化 ，可以用 变量代替

            NSString *format = @"";


            if ([model.type isEqualToString:[stringType copy]]) {

                format = [NSString stringWithFormat:@"%@",classPropertyCopy];

                [tmpCoder appendString:[NSString stringWithFormat:format, model.name]];

               [hTextCode appendString:[NSString stringWithFormat:format, model.name]];


            }else if ([model.type isEqualToString:[arrayType copy]]) {

                format = [NSString stringWithFormat:@"%@",classPropertyStrong];

                [tmpCoder appendString:[NSString stringWithFormat:format, model.name]];

                [hTextCode appendString:[NSString stringWithFormat:format, model.name]];

                NSString *tmp = [NSString stringWithFormat:@"@\"%@\" : [%@ class],", model.name, model.className];

                addMjCode = [NSString stringWithFormat:@"%@%@",addMjCode, tmp];

                if (![model.className isEqualToString:stringType]) {
                    [classNameM addObject:model.className];
                }



            }else if([model.type isEqualToString:[numberType copy]]) {

                format = [NSString stringWithFormat:@"%@",classPropertyAssign];


                [tmpCoder appendString:[NSString stringWithFormat:format, model.name]];

                [hTextCode appendString:[NSString stringWithFormat:format, model.name]];

            }else if([model.type isEqualToString:[intType copy]]) {

                format = [NSString stringWithFormat:@"%@",classPropertyAssignNoStar];

                [tmpCoder appendString:[NSString stringWithFormat:format, intType,  model.name]];

                [hTextCode appendString:[NSString stringWithFormat:format, intType,  model.name]];


            }else if([model.type isEqualToString:[longlongType copy]]) {

                format = [NSString stringWithFormat:@"%@",classPropertyAssignNoStar];

                [tmpCoder appendString:[NSString stringWithFormat:format, longlongType,  model.name]];

                [hTextCode appendString:[NSString stringWithFormat:format, longlongType,  model.name]];



            }else if([model.type isEqualToString:[floatType copy]]) {

                format = [NSString stringWithFormat:@"%@",classPropertyAssignNoStar];


                [tmpCoder appendString:[NSString stringWithFormat:format, floatType,  model.name]];

                [hTextCode appendString:[NSString stringWithFormat:format, floatType,  model.name]];


            }else if([model.type isEqualToString:[BOOLType copy]]) {

                format = [NSString stringWithFormat:@"%@",classPropertyAssignNoStar];

                [tmpCoder appendString:[NSString stringWithFormat:format, BOOLType,  model.name]];

                [hTextCode appendString:[NSString stringWithFormat:format, BOOLType,  model.name]];

            }else {

                format = [NSString stringWithFormat:@"%@",classPropertyStrongNoArray];


                [tmpCoder appendString:[NSString stringWithFormat:format, model.className,  model.name]];

                [hTextCode appendString:[NSString stringWithFormat:format, model.className,  model.name]];


                [classNameString appendString:[NSString stringWithFormat:@"%@,",model.className]];

                [classNameM addObject:model.className];

            }
        }

        NSString * formatEnd = [NSString stringWithFormat:@"%@",classEnd];
        if (group.className) {

            [tmpCoder appendString:formatEnd];

            [hTextCode appendString:formatEnd];

        }




        if (classNameM.count > 0) {

            NSString *statementClassName = hTextHeaderInfoClass;


            for (NSString *className in classNameM) {

                statementClassName = [NSString stringWithFormat:@"%@ %@,",statementClassName, className];


            }

            statementClassName = [statementClassName substringToIndex:statementClassName.length - 1];

            statementClassName = [NSString stringWithFormat:@"%@;\n",statementClassName];


            if (group.className) {

                NSInteger atIndex = 34;

                NSString *headerText = [hTextCode substringToIndex:atIndex];

                NSString *endText = [hTextCode substringFromIndex:atIndex];

                hTextCode = (NSMutableString *)[NSString stringWithFormat:@"%@\n%@%@", headerText, statementClassName, endText];

            }else {

                hTextCode = (NSMutableString *)[NSString stringWithFormat:@"%@%@", statementClassName,hTextCode];
            }

        }


        group.hText = hTextCode;


        if (addMjCode.length > 2) {

            addMjCode = [addMjCode substringToIndex:addMjCode.length - 1];

            NSString *addMjString = [NSString stringWithFormat:@"\n+ (NSDictionary *)objectClassInArray{ \n return @{%@};\n}\n",addMjCode ];

            addMjCode = addMjString;
        }


        if (nil != group.className) {

            NSString *headerformat = @"#import \"%@.h\"\n";

            [mTextCode appendString:[NSString stringWithFormat:headerformat, group.className]];

            if (classNameM.count > 0) {

                for (NSString *className in classNameM) {

                    [mTextCode appendString:[NSString stringWithFormat:headerformat, className]];
                }
            }

            if (addMjCode.length > 2) {

                BOOL flag = [[XWUserTool toolGetValueForKey:kIsAddMJExtension] boolValue];

                if (flag) {
                    [mTextCode appendString:[NSString stringWithFormat:headerformat, @"MJExtension"]];

                }
            }


            
            NSString * format = [NSString stringWithFormat:@"%@",classImplementation];
            
            [tmpCoder appendString:[NSString stringWithFormat:format, group.className]];


            [tmpCoder appendString:formatEnd];


            [mTextCode appendString:[NSString stringWithFormat:format, group.className]];

            if (addMjCode.length > 2) {

                BOOL flag = [[XWUserTool toolGetValueForKey:kIsAddMJExtension] boolValue];

                if (flag) {
                    [mTextCode appendString:addMjCode];
                }
            }


            [mTextCode appendString:formatEnd];

            group.mText = mTextCode;

        }
        [coder appendString:tmpCoder];
    }
    return jsonArray;
    
}


void converLevel(NSDictionary * json , XWModel * superModel){

    XWModelGroup *group = [[XWModelGroup alloc] init];


    if (nil != superModel) {
        group.className = superModel.className;
    }

    NSMutableArray *modesM = [NSMutableArray array];

    NSEnumerator * enumeratorKey = [json keyEnumerator];

    NSEnumerator * enumeratorValue = [json objectEnumerator];


    for (id obj in enumeratorValue) {

        id keyObj = enumeratorKey.nextObject;

        XWModel *model = [[XWModel alloc] init];
        
        
        // 增加 空 类型
        if ([obj isKindOfClass:[NSNull class]]) {
            
            model.name = keyObj;
            model.type = stringType;
            
            
        }else if ([obj isKindOfClass:[NSString class]]) {

//            XWLog(@"key:%@, value:%@", keyObj, obj);
            
            
            model.name = keyObj;


            NSString *tmp = obj;

            if([tmp isPureInt]) {

                if (tmp.length > 7) {
                    model.type = longlongType;
                }else {
                    model.type = intType;
                }
            }else if([tmp isPureLongLong]) {
                model.type = longlongType;
            }else if ([tmp isPureFloat]) {
                model.type = floatType;
            }else if([tmp isPureBool]) {
                model.type = BOOLType;
            }else {
                model.type = stringType;

            }


        }else if([obj isKindOfClass:[NSNumber class]]){

            XWLog(@"key:%@, value:%@", keyObj, obj);

            model.name = keyObj;
            model.type = numberType;

            NSNumber *tmp = obj;

            NSString *tmpStr = [tmp stringValue];

            // 检测具体类型
            if([tmpStr isPureInt]) {

                if (tmpStr.length > 7) {
                    model.type = longlongType;
                }else {
                    model.type = intType;
                }

            }else if([tmpStr isPureLongLong]) {
                model.type = longlongType;
            }else if ([tmpStr isPureFloat]) {
                model.type = floatType;
            }else if([tmpStr isPureBool]) {
                model.type = BOOLType;
            }else {
                model.type = numberType;

            }

        }else if ([obj isKindOfClass:[NSArray class]]) {


            model.name = keyObj;
            model.type = arrayType;
            
            NSArray *tmpArray = obj;
            
            
            
            if (!tmpArray.count){
            
                model.className = nil;
                
            }else if ([tmpArray[0] isKindOfClass:[NSString class]]) {
                
                model.className = stringType;
            
            }else {

                NSString *per = [XWUserTool toolGetValueForKey:kUserSetPerClassName];;

                if (!per) {
                    per = @"";
                }

                // 如何知道 这个数组里面存放的 是什么 类型
                model.className = [NSString stringWithFormat:@"%@%@", per, [model.name  perferCharCapitalizedString]];

            }
        }else if ([obj isKindOfClass:[NSDictionary class]]){


            model.name = keyObj;
            model.type = dictionaryType;

            NSString *preString = [XWUserTool toolGetValueForKey:kUserSetPerClassName];

            if (!preString) {

                preString = @"";
            }

            model.className = [NSString stringWithFormat:@"%@%@", preString, model.name.perferCharCapitalizedString];

        }
        
        [modesM addObject:model];
    }
    
    group.modelsM = modesM;
    [resultM addObject:group];
    
    for (XWModel *xmode in modesM) {
        
        if (xmode.className && [xmode.type isEqualToString:[arrayType copy]] && ![xmode.className isEqualToString: stringType]) {
            
            id arrayObj = json[xmode.name];
            
            if ([arrayObj isKindOfClass:[NSArray class]]) {
                
                //防止为空的情况
                NSArray *tmpArray = arrayObj;
                if (!tmpArray.count) continue;
                
                id tmpJson = arrayObj[0];
                
                if (tmpJson && [tmpJson isKindOfClass:[NSDictionary class]]) {

                    converLevel(tmpJson, xmode);
                }
            }
            
        }else if ( [xmode.type isEqualToString:[dictionaryType copy]]) {
            
            id dictObj = json[xmode.name];
            
            if (dictObj && [dictObj isKindOfClass:[NSDictionary class]]) {
                
                converLevel(dictObj, xmode);
                
            }
            
        }
        
    }
    
}

@end
