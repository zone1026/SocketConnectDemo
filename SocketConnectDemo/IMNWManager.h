//
//  imNWManager.h
//  IMiPhone
//
//  Created by 尹晓君 on 14-8-20.
//  Copyright (c) 2014年 尹晓君. All rights reserved.
//
/*
Socket发送消息


Http发送消息
imNWMessage *message = [[imNWMessage alloc] init];
message.host = @"gamify.tianya.cn";
srand((unsigned)time(0));
message.path = [NSString stringWithFormat:@"/app/bobing/server/?&r=%i",rand()];
message.connect = CONNECT_HTTP;
[[imNWManager sharedNWManager] sendMessage:message withResponse:^(NSString *responseString, NSData *responseData) {
    NSLog(@"Http connect response string: %@", responseString);
    NSLog(@"Http connect response data: %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
}];
*/
#import <Foundation/Foundation.h>
#import "IMNWGCDSocketConnect.h"
#import "IMNWMessage.h"

#define KEY_RMS_LASTHOST @"lasthost"

typedef void (^imNWResponseBlock)(NSString* responseString, NSData* responseData);

@interface IMNWManager : NSObject

@property (nonatomic, retain) IMNWGCDSocketConnect *socketConnect;

@property (nonatomic, retain) NSString *hostShort;
@property (nonatomic, retain) NSString *hostLongHost;
@property (nonatomic) int hostLongPort;
@property (nonatomic, retain) NSString *hostShortHost;
@property (nonatomic) int hostShortPort;
@property (nonatomic) int hostShortPortSSL;
@property (nonatomic, retain) NSString *urlLog;

@property (nonatomic, retain) NSArray *arrHosts;
@property (nonatomic, retain) NSDictionary *dicLastHost;

@property (nonatomic) BOOL isTipViewTop;

+ (IMNWManager*)sharedNWManager;

- (void)initSocketConnect;
- (void)initHttpConnect;

- (void)sendMessage:(IMNWMessage *)message withResponse:(imNWResponseBlock)response;
- (void)parseMessage:(IMNWMessage *)message;
- (void)parseHost;

//- (void)showNetWorkTipView:(BOOL)show;
//- (void)updateNetWorkTipViewPosition:(BOOL)isTop;

@end
