//
//  imNWMessage.m
//  IMiPhone
//
//  Created by 尹晓君 on 14-8-21.
//  Copyright (c) 2014年 尹晓君. All rights reserved.
//

#import "IMNWMessage.h"
#import "IMNWProxy.h"
#import "IMNWManager.h"

@implementation IMNWMessage

@synthesize connect;
@synthesize mark;
@synthesize type;
@synthesize data;
@synthesize multiPartData;
@synthesize host;
@synthesize port;
@synthesize path;
@synthesize responseBlocks;
@synthesize useSSL;
@synthesize method;
@synthesize url;
@synthesize _sn;

+ (IMNWMessage *)createForSocket:(NSString *)mark withType:(NSString *)type
{
    IMNWMessage *message = [[IMNWMessage alloc] init];
    message.connect = CONNECT_SOCKET;
    message.mark = mark;
    message.type = type;
    return message;
}

+ (IMNWMessage *)createForHttp:(NSString *)path withParams:(NSMutableDictionary *)params withMethod:(NSString *)method ssl:(BOOL)useSSL
{
    IMNWMessage *message = [[IMNWMessage alloc] init];
    message.connect = CONNECT_HTTP;
    message.path = path;
    if (params == nil) {
        params = [NSMutableDictionary dictionary];
    }
    //POST类型verify挪到底层，直接加在path上
//    if ([method isEqualToString:METHOD_GET]) {
//        if ([UserDataProxy sharedProxy].verify)
//            [params setObject:[UserDataProxy sharedProxy].verify forKey:HTTP_KEY_VERIFY];
//        [params setObject:[[SystemController sharedController] getProtocolVersion] forKey:HTTP_KEY_VERSION];
//    }
    message.data = params;
    message.method = method;
    message.useSSL = useSSL;
    return message;
}

+ (IMNWMessage *)createForHttpUseURL:(NSString *)url withParams:(NSMutableDictionary *)params withMethod:(NSString *)method
{
    IMNWMessage *message = [[IMNWMessage alloc] init];
    message.connect = CONNECT_HTTP;
    message.url = url;
    if (params == nil) {
        params = [NSMutableDictionary dictionary];
    }
    message.data = params;
    message.method = method;
    return message;
}

- (NSData *)getSocketData
{
    if ([self.data isKindOfClass:[NSData class]] == YES) {
        return self.data;
    }
    return nil;
}

- (NSMutableDictionary *)getHttpParams
{
    if ([self.data isKindOfClass:[NSMutableDictionary class]] == YES) {
        return self.data;
    }
    return nil;
}

- (NSDictionary *)getResponseJson
{
    if ([self.data isKindOfClass:[NSDictionary class]] == YES) {
        return self.data;
    }
    return nil;
}

- (void)excute
{
    NSString *markCapitalized = [self.mark capitalizedString];
    NSString *clz = [NSString stringWithFormat:@"%@MessageProxy", markCapitalized];
    Class clsProxy = NSClassFromString(clz);
    if (clsProxy) {
        IMNWProxy *proxy = [clsProxy sharedProxy];
        [proxy parseMessage:self];
    }
    else {
        NSLog(@"No such Class: %@", clz);
    }
}

- (void)send:(NSMutableDictionary *)info keyOfRouteId:(NSString *)ridKey
{
    if (self.connect == CONNECT_SOCKET) {
        if (!info) {
            info = [NSMutableDictionary dictionary];
        }
        if (_sn) {
            [info setObject:_sn forKey:SOCKET__SN];
        }
        NSData *dataInfo = [NSJSONSerialization dataWithJSONObject:info options:0 error:nil];
        NSString *routeId = [info objectForKey:ridKey];
        if (!routeId) {
            routeId = @"0";
        }
        NSString *head = [NSString stringWithFormat:@"%@*%@*%@*%li*\n", mark, type, routeId, (unsigned long)dataInfo.length];
        data = [NSMutableData dataWithData:[head dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:dataInfo];
    }
    [[IMNWManager sharedNWManager] sendMessage:self withResponse:nil];
}

- (void)useHost:(NSString *)phost andPort:(int)nport
{
    //底层暂不支持多http路径，需要扩展，使用dictionary持有不同host和port的http connect
    self.host = phost;
    self.port = nport;
}

@end
