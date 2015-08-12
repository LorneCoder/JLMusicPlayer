//
//  Networking.m
//  UI_Lesson_19(异步下载)
//
//  Created by JLItem on 15/6/16.
//  Copyright (c) 2015年 JLItem. All rights reserved.
//

#import "Networking.h"

@implementation Networking

//实现
+(void)recivedDataWithURLString:(NSString *)urlString Method:(NSString *)method Body:(NSString *)body Block:(Block)block
{
    //1、将传进来的 urlString 转成 url
    NSURL *url=[NSURL URLWithString:urlString];
    
    //2、准备请求
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    
    //3、设置请求方式 Method
    [request setHTTPMethod:method];
    
    //4、判断请求方式 (以 Method 传进来的值为判断依据)
    if ([method compare:@"POST"]==0) {
        
        NSData *data=[body dataUsingEncoding:NSUTF8StringEncoding];
        
        [request setHTTPBody:data];
    }
    
    //执行链接
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        //json解析第一步
        id tempObj=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

        //使用block将此对象传回到视图控制器类里面
        block(tempObj);
        
    }];
    
}




@end
