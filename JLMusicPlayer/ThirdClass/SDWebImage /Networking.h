//
//  Networking.h
//  UI_Lesson_19(异步下载)
//
//  Created by JLItem on 15/6/16.
//  Copyright (c) 2015年 JLItem. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^Block)(id object);

@interface Networking : NSObject

//声明数据请求方法，将POST和GET请求方法写进一个方法里面，判断method（请求类型）
+(void)recivedDataWithURLString:(NSString *)urlString
                         Method:(NSString *)method
                           Body:(NSString *)body
                          Block:(Block)block;






@end
