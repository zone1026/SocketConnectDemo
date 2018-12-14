//
//  imNWMessage.h
//  IMiPhone
//
//  Created by 尹晓君 on 14-8-21.
//  Copyright (c) 2014年 尹晓君. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CONNECT_HTTP 0
#define CONNECT_SOCKET 1
#define CONNECT_HTTPOUT 2

#define SOCKET_MARK @"mark"
#define SOCKET_TYPE @"type"
#define SOCKET__SN @"_sn"

@interface IMNWMessage : NSObject

@property (nonatomic) int connect;
@property (nonatomic, retain) NSString *mark;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSNumber *_sn;
@property (nonatomic, retain) id data;
///multi-part 类型数据，图片等
@property (nonatomic, retain) NSMutableDictionary *multiPartData;
@property (nonatomic, retain) NSString *host;
@property (nonatomic) int port;
@property (nonatomic, retain) NSString *path;
@property (nonatomic, strong) NSMutableArray *responseBlocks;
@property (nonatomic) BOOL useSSL;
@property (nonatomic, retain) NSString *method;
@property (nonatomic, retain) NSString *url;

/**
 *  创建socket基础消息，完善消息数据后，通过send方法发送消息
 *
 *  @param mark 消息所属模块
 *  @param type 消息所属功能
 *
 *  @return 返回消息实例
 */
+ (IMNWMessage *)createForSocket:(NSString *)mark withType:(NSString *)type;

/**
 *  创建http基础消息，随后通过imNWManager发送消息
 *
 *  @param path   消息接口路径，不包括域名和端口
 *  @param params 需要发送的参数
 *  @param method POST或者GET
 *  @param useSSL 是否https
 *
 *  @return 返回消息实例
 */
+ (IMNWMessage *)createForHttp:(NSString *)path withParams:(NSMutableDictionary *)params withMethod:(NSString *)method ssl:(BOOL)useSSL;

///使用完整url创建http消息
+ (IMNWMessage *)createForHttpUseURL:(NSString *)url withParams:(NSMutableDictionary *)params withMethod:(NSString *)method;

- (NSData *)getSocketData;
- (NSMutableDictionary *)getHttpParams;
- (NSDictionary *)getResponseJson;
- (void)excute;

/**
 *  socket消息的发送方法，http消息不使用此方法
 *
 *  @param info 需要发送的json数据对象，如果需要使用NSMutableArray类型，需要修改此方法
 *  @param ridKey 路由id，消息常量中ROUTI开头的常量值
 */
- (void)send:(NSMutableDictionary *)info keyOfRouteId:(NSString *)ridKey;

- (void)useHost:(NSString *)phost andPort:(int)nport;

@end
