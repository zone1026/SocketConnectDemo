//
//  imNWManager.m
//  IMiPhone
//
//  Created by 尹晓君 on 14-8-20.
//  Copyright (c) 2014年 尹晓君. All rights reserved.
//

#import "IMNWManager.h"

@implementation IMNWManager

@synthesize socketConnect;
@synthesize dicLastHost = _dicLastHost;
@synthesize urlLog = _urlLog;

static IMNWManager *sharedNWManager = nil;

+ (IMNWManager*)sharedNWManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedNWManager = [[self alloc] init];
    });
    return sharedNWManager;
}

- (void)initSocketConnect
{
    //static dispatch_once_t onceToken;
    //dispatch_once(&onceToken, ^{
//        socketConnect = [[IMNWGCDSocketConnect alloc] initWithHost:SOCKET_HOST port:SOCKET_PORT];
        socketConnect = [[IMNWGCDSocketConnect alloc] initWithHost:self.hostLongHost port:self.hostLongPort];
    //});
}

- (void)initHttpConnect
{
}

- (void)sendMessage:(IMNWMessage *)message withResponse:(imNWResponseBlock)response
{
    switch (message.connect) {
        case CONNECT_HTTP:
        {
//                if (message.useSSL)
//                    self.httpConnect.portNumber = self.hostShortPortSSL;
//                else
//                    self.httpConnect.portNumber = self.hostShortPort;
//                [self.httpConnect sendHttpRequest:message withResponse:response];
            break;
        }
        case CONNECT_SOCKET:
        {
            NSData *data = [message getSocketData];
            [self.socketConnect sendData:data];
            break;
        }
        case CONNECT_HTTPOUT:
        {
//            [self.httpConnect sendHttpRequest:message withResponse:response];
            break;
        }
        default:
            break;
    }
}

- (void)parseMessage:(IMNWMessage *)message
{
    [message excute];
}

- (NSDictionary *)dicLastHost {
    if (_dicLastHost == nil) {
//        _dicLastHost = [imRms userDefaultsReadObject:KEY_RMS_LASTHOST isBindUid:NO];
    }
    return _dicLastHost;
}

- (void)setDicLastHost:(NSDictionary *)dicLastHost {
    _dicLastHost = dicLastHost;
//    [imRms userDefaultsWrite:KEY_RMS_LASTHOST withObjectValue:dicLastHost isBindUid:NO];
}

- (void)parseHost {
    if (self.dicLastHost) {
        self.hostShort = [self.dicLastHost objectForKey:@"short"];
        NSArray *arrHostLong = [self.dicLastHost objectForKey:@"long"];
        self.hostLongHost = [arrHostLong objectAtIndex:0];
        self.hostLongPort = [[arrHostLong objectAtIndex:1] intValue];
        NSArray *arrHostShort = [self.dicLastHost objectForKey:@"shortex"];
        self.hostShortHost = [arrHostShort objectAtIndex:0];
        self.hostShortPort = [[arrHostShort objectAtIndex:1] intValue];
        NSArray *arrHostShortSSL = [self.dicLastHost objectForKey:@"https"];
        //                    [IMNWManager sharedNWManager].hostShortHostSSL = [arrHostShort objectAtIndex:0];
        self.hostShortPortSSL = [[arrHostShortSSL objectAtIndex:1] intValue];
        //[IMNWManager sharedNWManager].hostShortPortSSL = 443;
        
        NSArray *arrHostLog = [self.dicLastHost objectForKey:@"log"];
        if (arrHostLog.count) {
            NSString *hostLogHost = [arrHostLog objectAtIndex:0];
            int hostLogPort = [[arrHostLog objectAtIndex:1] intValue];
            self.urlLog = [NSString stringWithFormat:@"http://%@:%@", hostLogHost, @(hostLogPort)];
        }
    }
}

//- (void)showNetWorkTipView:(BOOL)show {
//    if (show) {
//        if (!self.tipView) {
//            self.tipView = [IMNetworkTipView create];
//            [self updateNetWorkTipViewPosition:self.isTipViewTop];
//        }
//        [[UIApplication sharedApplication].keyWindow addSubview:self.tipView];
//    }
//    else {
//        if (self.tipView) {
//            [self.tipView removeFromSuperview];
//            self.tipView = nil;
//        }
//    }
//}
//
//- (void)updateNetWorkTipViewPosition:(BOOL)isTop {
//    if (self.tipView) {
//        CGRect frame = self.tipView.frame;
//        frame.origin.y = (isTop ? 20 : 64);
//        self.tipView.frame = frame;
//    }
//    else
//        self.isTipViewTop = isTop;
//}

- (NSString *)urlLog
{
    if(_urlLog == nil)
    {
        [self parseHost];
    }
    return _urlLog;
}

@end
