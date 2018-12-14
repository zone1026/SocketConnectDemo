//
//  imNWProxy.h
//  IMiPhone
//
//  Created by 尹晓君 on 14-9-9.
//  Copyright (c) 2014年 尹晓君. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMNWMessage.h"
#import "IMNWManager.h"

@interface IMNWProxy : NSObject

+ (IMNWProxy*)sharedProxy;

- (void)parseMessage:(IMNWMessage *)message;

/**
 *  消息错误码通用处理方法
 *
 *  @param errorcode 错误码，http消息的errorcode或者socket消息的res
 *  @param source    来源，path或者mark＋type
 *  @param notiName  通知系统使用的key
 */
- (void)processErrorCode:(NSInteger)errorcode fromSource:(NSString *)source useNotiName:(NSString *)notiName;

- (void)processErrorCode:(NSInteger)errorcode fromSource:(NSString *)source useNotiName:(NSString *)notiName userInfo:(NSDictionary *)userInfo;

- (void)alertErrorCode:(NSInteger)errorcode;

- (NSMutableDictionary *)processJsonData:(NSData *)responseData;

@end
