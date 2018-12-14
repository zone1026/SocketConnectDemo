//
//  imNWSocketConnect.h
//  IMiPhone
//
//  Created by 尹晓君 on 14-8-20.
//  Copyright (c) 2014年 尹晓君. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

#define NOTI_SOCKET_CONNECT @"NWSocketConnectNotifiction"
#define NOTI_SOCKET_MANUALDISCONNECT @"NWSocketManualDisConnectNotifiction"

@interface IMNWGCDSocketConnect : NSObject <GCDAsyncSocketDelegate>

@property (nonatomic, retain) GCDAsyncSocket *socket;

@property (nonatomic) BOOL shouldReconnect;

- (id)initWithHost:(NSString *)hostIP port:(uint16_t)hostPort;

//- (void)connect:(NSString *)hostIP port:(uint16_t)hostPort;

- (void)connect;
- (void)disconnect;

- (void)sendData:(NSData *)data;

@end
