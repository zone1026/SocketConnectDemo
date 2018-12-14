//
//  imNWSocketConnect.m
//  IMiPhone
//
//  Created by 尹晓君 on 14-8-20.
//  Copyright (c) 2014年 尹晓君. All rights reserved.
//

#import "IMNWGCDSocketConnect.h"
#import "IMNWMessage.h"
//#import "IMNWManager.h"
//#import "crypt.h"

#define CRYPT NO

#define TAG_MSG 0
#define TAG_CRYPT 1
#define TAG_MSG_HEAD 2
#define TAG_MSG_BODY 3

#define SOCKET_TIMEOUT 10.0
#define SOCKET_BEAT_OFFTIME 1 * 60.0f

@interface IMNWGCDSocketConnect ()

@property (nonatomic, retain) NSString *host;
@property (nonatomic) NSInteger port;
//@property (nonatomic, retain) NSData *dataToSend;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) IMNWMessage *message;
//@property (nonatomic, retain) Reachability *reachability;
@property (nonatomic, retain) NSData *term;
@property (nonatomic) NSInteger reconnectCount;

@end

@implementation IMNWGCDSocketConnect

//char cryptKey[17];

- (id)initWithHost:(NSString *)hostIP port:(uint16_t)hostPort
{
    self = [self init];
    if (self) {
        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        _term = [@"\n" dataUsingEncoding:NSUTF8StringEncoding];
        _reconnectCount = 0;
        self.host = hostIP;
        self.port = hostPort;
        self.shouldReconnect = YES;
//        [self observeHostReachability];
    }
    return self;
}

- (void)dealloc
{
//    [self removeObserveHostReachability];
}

- (void)connect:(NSString *)hostIP port:(uint16_t)hostPort
{
//    if ([UserDataProxy sharedProxy].verify)
    {
        NSString *log = [NSString stringWithFormat:@"Socket ready to connect: %@ : %hu", hostIP, hostPort];
        NSLog(@"%@", log);
//        [IMLogger debugLogBeforeClientLogExpire:log];
        self.host = hostIP;
        self.port = hostPort;
        
        [self disconnect];

        if (!self.socket) {
            self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        }
        
        NSError *err = nil;
        if([self.socket connectToHost:hostIP onPort:hostPort withTimeout:SOCKET_TIMEOUT error:&err])
        {
        }
        if (err) {
            NSString *log = [NSString stringWithFormat:@"Socket preConnect error: %@", err];
            NSLog(@"%@", log);
//            [IMLogger debugLogBeforeClientLogExpire:log];

            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SOCKET_CONNECT object:err];
            //self.dataToSend = nil;
        }
    }
    
}

- (void)socket:(GCDAsyncSocket *)sender didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSString *log = [NSString stringWithFormat:@"Socket connect succceed: %@ : %hu", host, port];
    NSLog(@"%@", log);
//    [IMLogger debugLogBeforeClientLogExpire:log];
    _reconnectCount = 0;
    if (CRYPT) {
        //[self.socket readDataToData:term withTimeout:-1 tag:TAG_CRYPT];
    }
    else {
        [self.socket readDataToData:_term withTimeout:-1 tag:TAG_MSG_HEAD];
    }
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:SOCKET_BEAT_OFFTIME target:self selector:@selector(sendSystemBeat) userInfo:nil repeats:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SOCKET_CONNECT object:nil];
}

- (void)socket:(GCDAsyncSocket *)sender didReadData:(NSData *)data withTag:(long)tag
{
    if (tag == TAG_CRYPT) {
//        NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"Socket Received CRYPT: %@", content);
//        char originalKey[17];
//        [data getBytes:originalKey length:data.length];
//        keyRevert(originalKey, cryptKey);
//        [self.socket readDataToData:term withTimeout:-1 tag:TAG_MSG];
//        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.100f target:self selector:@selector(verifyUser) userInfo:nil repeats:NO];
    }
    else if (tag == TAG_MSG_HEAD) {
        NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString *log = [NSString stringWithFormat:@"Socket Received head: %@", content];
        NSLog(@"%@", log);
        
        NSArray *arrHead = [content componentsSeparatedByString:@"*"];
        self.message = [[IMNWMessage alloc] init];
        self.message.mark = [arrHead objectAtIndex:0];
        self.message.type = [arrHead objectAtIndex:1];
        NSInteger bodyLength = [[arrHead objectAtIndex:2] integerValue];
        [self.socket readDataToLength:bodyLength withTimeout:-1 tag:TAG_MSG_BODY];
    }
    else if (tag == TAG_MSG_BODY) {
        NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString *log = [NSString stringWithFormat:@"Socket Received body: %@", content];
        NSLog(@"%@", log);
        
        
        NSError *error = nil;
        NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (error) {
            NSLog(@"JSON create error: %@", error);
        }
        if (self.message) {
            self.message.data = json;
//            [[IMNWManager sharedNWManager] parseMessage:self.message];
            self.message = nil;
        }
        
        [self.socket readDataToData:_term withTimeout:-1 tag:TAG_MSG_HEAD];
    }
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sender withError:(NSError *)err
{
    NSString *log = [NSString stringWithFormat:@"Socket disconnect with error: %@", err];
    NSLog(@"%@", log);
    
    self.message = nil;
    //self.dataToSend = nil;
    if (err) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SOCKET_CONNECT object:err];
//        if (err.domain == GCDAsyncSocketErrorDomain) {
//            if (_reconnectCount == 0) {
//                [self connect:self.host port:self.port];
//                _reconnectCount++;
//            }
//        }
//        else {
////            [self observeHostReachability];
////            if (!self.tipView) {
////                self.tipView = [IMNetworkTipView create];
////            }
////            [[UIApplication sharedApplication].keyWindow addSubview:self.tipView];
//        }
    }
    else {
//        NSError *customError = [NSError errorWithDomain:ERROR_DOMAIN_MANUAL_DISCONNECT_SOCKET code:0 userInfo:nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SOCKET_CONNECT object:customError];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SOCKET_MANUALDISCONNECT object:nil];
    }
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
//    if (self.shouldReconnect) {
//        [self performSelector:@selector(reConnect) withObject:nil afterDelay:3.0];//3秒尝试一次
//    }
}
                      
- (void)socket:(GCDAsyncSocket *)sender didWriteDataWithTag:(long)tag
{
    if (tag == TAG_MSG) {
        NSLog(@"Socket Did Send !!!");
    }
}

- (void)connect {
    [self connect:@"127.0.0.1" port:[@"12345" intValue]];
}

- (void)disconnect
{
    if (self.socket && [self.socket isConnected]) {
        NSString *log = [NSString stringWithFormat:@"Socket will disconnect !!!"];
        NSLog(@"%@", log);
        
        [self.socket disconnectAfterWriting];
    }
    self.socket = nil;
}

- (void)sendData:(NSData *)data
{
    if (self.socket.isDisconnected) {
        //self.dataToSend = data;
        //[self connect:self.host port:self.port];
    }
    else if (self.socket.isConnected) {
        NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString *log = [NSString stringWithFormat:@"Socket Will Send: %@ , length: %lu", content, (unsigned long)data.length];
        NSLog(@"%@", log);
        
        if (CRYPT) {
//            cryptKey[0] = rand() % 127 + 1;
//            cryptKey[1] = rand() % 127 + 1;
//            char *dataBytes = (char*)[data bytes];
//            bitEncode(dataBytes, (int)data.length, cryptKey, 16);
//            NSMutableData *dataEncoded = [NSMutableData data];
//            [dataEncoded appendBytes:cryptKey length:2];
//            [dataEncoded appendBytes:dataBytes length:data.length];
//            [self.socket writeData:dataEncoded withTimeout:-1 tag:TAG_MSG];
//            [self.socket writeData:term withTimeout:-1 tag:TAG_MSG];
        }
        else {
            [self.socket writeData:data withTimeout:-1 tag:TAG_MSG];
        }
    }
}

@end
