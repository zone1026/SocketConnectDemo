//
//  imNWProxy.m
//  IMiPhone
//
//  Created by 尹晓君 on 14-9-9.
//  Copyright (c) 2014年 尹晓君. All rights reserved.
//

#import "IMNWProxy.h"

@implementation IMNWProxy

static IMNWProxy *sharedNWProxy = nil;

+ (IMNWProxy *)sharedProxy
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedNWProxy = [[self alloc] init];
    });
    return sharedNWProxy;
}

- (void)parseMessage:(IMNWMessage *)message
{
    NSString *type = [message.type capitalizedString];
    NSString *method = [NSString stringWithFormat:@"parseType%@:", type];
    SEL selector = NSSelectorFromString(method);
    if ([self respondsToSelector:selector]) {
        [self performSelector:selector withObject:message.data];
    }
    else {
        NSLog(@"%@MessageProxy has no such method: %@", [message.mark capitalizedString], method);
    }
}

- (void)processErrorCode:(NSInteger)errorcode fromSource:(NSString *)source useNotiName:(NSString *)notiName
{
    [self processErrorCode:errorcode fromSource:source useNotiName:notiName userInfo:nil];
}

- (void)processErrorCode:(NSInteger)errorcode fromSource:(NSString *)source useNotiName:(NSString *)notiName userInfo:(NSDictionary *)userInfo
{
    if (errorcode == 10042 || errorcode == 10008 || errorcode == 10012 || errorcode == 10016) {
//        [imUtil logout:YES];
    }
    if (errorcode == 10069) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SYSTEM_FROZEN object:self];
    }
//    NSNumber *errorCodeNumber = [NSNumber numberWithLong:errorcode];
//    NSString *errorMessage = [errorCodeNumber errorMessage];
//    NSLog(@"Network connect response error: %li", (long)errorcode);
//    NSLog(@"Network connect response errormessage: %@", errorMessage);
//    NSDictionary *errorUserInfo = [NSDictionary dictionaryWithObject:errorMessage
//                                                         forKey:NSLocalizedDescriptionKey];
//    NSError *error = [NSError errorWithDomain:source code:errorcode userInfo:errorUserInfo];
//    [[NSNotificationCenter defaultCenter] postNotificationName:notiName object:error userInfo:userInfo];
}

- (void)alertErrorCode:(NSInteger)errorcode {
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert", nil) message:[NSString stringWithFormat:@"%li: %@", (long)errorcode, [[NSNumber numberWithLong:errorcode] errorMessage]] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert", nil) message:[[NSNumber numberWithLong:errorcode] errorMessage] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
//    [alertView show];
}

- (NSMutableDictionary *)processJsonData:(NSData *)responseData
{
    if (responseData) {
        NSError *error;
        NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
        if (error) {
//            if ([HeibaController sharedController].debug || [[HeibaController sharedController].appBundleId isEqualToString:BUNDLE_IDENTIFIER_DEVELOP]) {
                NSString *content = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert", nil) message:[NSString stringWithFormat:@"Http JSON create error: \"%@\"; %@", content, error] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
//                [alertView show];
//            }
//            return nil;
        }
        else
            return json;
    }
    
        return nil;
}

@end
