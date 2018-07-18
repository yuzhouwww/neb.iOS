//
//  NASSmartContracts.m
//  iosSDK
//
//  Created by Bobby on 2018/5/28.
//

#import <UIKit/UIKit.h>
#import "NASSmartContracts.h"

#define NAS_NANO_SCHEMA_URL @"openapp.nasnano://virtual?params=%@"

#define NAS_CALLBACK_DEBUG @"https://pay.nebulas.io/api/pay"
#define NAS_CHECK_URL_DEBUG @"https://pay.nebulas.io/api/pay/query?payId=%@"
#define NAS_HOST_DEBUG @"https://testnet.nebulas.io%@"

#define NAS_CALLBACK @"https://pay.nebulas.io/api/mainnet/pay"
#define NAS_CHECK_URL @"https://pay.nebulas.io/api/mainnet/pay/query?payId=%@"
#define NAS_HOST @"https://mainnet.nebulas.io%@"

static NSString *kNASCallback = NAS_CALLBACK;
static NSString *kNASCheckUrl = NAS_CHECK_URL;

static NSString *kAppName;
static UIImage *kAppIcon;
static NSString *kAppScheme;

static void (^kAuthBlock)(NSString *);
static void (^kPayBlock)(BOOL, NSString *);

@implementation NASSmartContracts

#pragma mark - public

+ (void)setAppName:(NSString *)name icon:(UIImage *)icon scheme:(NSString *)scheme {
    kAppName = name;
    kAppIcon = icon;
    kAppScheme = scheme;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        if (kAuthBlock) {
            kAuthBlock(nil);
            kAuthBlock = nil;
        }
        if (kPayBlock) {
            kPayBlock(NO, nil);
            kPayBlock = nil;
        }
    }];
}

+ (void)debug:(BOOL)debug {
    if (debug) {
        kNASCallback = NAS_CALLBACK_DEBUG;
        kNASCheckUrl = NAS_CHECK_URL_DEBUG;
    } else {
        kNASCallback = NAS_CALLBACK;
        kNASCheckUrl = NAS_CHECK_URL;
    }
}

+ (BOOL)nasNanoInstalled {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:NAS_NANO_SCHEMA_URL]];
}

+ (void)goToNasNanoAppStore {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/id1281191905?mt=8"]];
}

+ (NSString *)randomSerialNumber {
    static NSString *charSet = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *string = [NSMutableString string];
    for (int i = 0; i < 32; i++) {
        int index = arc4random() % [charSet length];
        [string appendString:[charSet substringWithRange:NSMakeRange(index, 1)]];
    }
    return [string copy];
}


+ (NSError *)authWithInfo:(NSDictionary *)info
                 complete:(void (^)(NSString *address))complete {
    kAuthBlock = complete;
    
    NSString *url = [NSString stringWithFormat:NAS_NANO_SCHEMA_URL,
                     [self authQureyValueWithInfo:info]];
    return [self openUrl:url];
}

+ (NSError *)payNas:(NSNumber *)nas
          toAddress:(NSString *)address
       serialNumber:(NSString *)sn
          goodsName:(NSString *)name
        description:(NSString *)desc
        callbackURL:(NSString *)url
           complete:(void (^)(BOOL success, NSString *txHash))complete {
    NSNumber *wei = @(1000000000000000000L * [nas doubleValue]);
    NSDictionary *info = @{
                           @"goods" : @{
                                   @"name" : name ?: @"",
                                   @"desc" : desc ?: @""
                                   },
                           @"pay" : @{
                                   @"value" : [NSString stringWithFormat:@"%lld", [wei longLongValue]],
                                   @"to" :  address ?: @"",
                                   @"payload" : @{
                                           @"type" : @"binary"
                                           },
                                   @"currency" : @"NAS"
                                   },
                           @"callback" : url ?: kNASCallback
                           };
    
    kPayBlock = complete;
    NSString *urlString = [NSString stringWithFormat:NAS_NANO_SCHEMA_URL,
                     [self queryValueWithSerialNumber:sn andInfo:info]];
    return [self openUrl:urlString];
}

+ (NSError *)payNrc20:(NSNumber *)nrc
            toAddress:(NSString *)address
         serialNumber:(NSString *)sn
            goodsName:(NSString *)name
          description:(NSString *)desc
          callbackURL:(NSString *)url
             complete:(void (^)(BOOL success, NSString *txHash))complete {
    NSDictionary *info = @{
                           @"goods" : @{
                                   @"name" : name ?: @"",
                                   @"desc" : desc ?: @""
                                   },
                           @"pay" : @{
                                   @"value" : [NSString stringWithFormat:@"%lld", [nrc longLongValue]],
                                   @"to" :  @"n22PdtQepev7rcQgy3zqfdAkNPN2pSpywZ8",
                                   @"payload" : @{
                                           @"type" : @"call",
                                           @"function" : @"transfer",
                                           @"args" : @[address ?: @""]
                                           },
                                   @"currency" : @"NRC"
                                   },
                           @"callback" : url ?: kNASCallback
                           };
    
    kPayBlock = complete;
    NSString *urlString = [NSString stringWithFormat:NAS_NANO_SCHEMA_URL,
                           [self queryValueWithSerialNumber:sn andInfo:info]];
    return [self openUrl:urlString];
}

+ (NSError *)callMethod:(NSString *)method
               withArgs:(NSArray *)args
                 payNas:(NSNumber *)nas
              toAddress:(NSString *)address
           serialNumber:(NSString *)sn
              goodsName:(NSString *)name
            description:(NSString *)desc
            callbackURL:(NSString *)url
               complete:(void (^)(BOOL success, NSString *txHash))complete {
    NSNumber *wei = @(1000000000000000000L * [nas doubleValue]);
    NSData *argsData = [NSJSONSerialization dataWithJSONObject:args options:0 error:nil];
    NSDictionary *info = @{
                           @"goods" : @{
                                   @"name" : name ?: @"",
                                   @"desc" : desc ?: @""
                                   },
                           @"pay" : @{
                                   @"value" : [NSString stringWithFormat:@"%lld", [wei longLongValue]],
                                   @"to" :  address ?: @"",
                                   @"payload" : @{
                                           @"type" : @"call",
                                           @"function" : method ?: @"",
                                           @"args" : [[NSString alloc] initWithData:argsData encoding:NSUTF8StringEncoding]
                                           },
                                   @"currency" : @"NAS"
                                   },
                           @"callback" : url ?: kNASCallback
                           };
    
    kPayBlock = complete;
    NSString *urlString = [NSString stringWithFormat:NAS_NANO_SCHEMA_URL,
                     [self queryValueWithSerialNumber:sn andInfo:info]];
    return [self openUrl:urlString];
}

+ (NSError *)deployContractWithSource:(NSString *)source
                           sourceType:(NSString *)sourceType
                               binary:(NSString *)binary
                         serialNumber:(NSString *)sn
                          callbackURL:(NSString *)url
                             complete:(void (^)(BOOL success, NSString *txHash))complete {
    NSDictionary *info = @{
                           @"goods" : @{
                                   @"name" : @"",
                                   @"desc" : @""
                                   },
                           @"pay" : @{
                                   @"value" : @"0",
                                   @"to" : @"",
                                   @"payload" : @{
                                           @"type" : @"deploy",
                                           @"function" : @"transfer",
                                           @"args" : @"",
                                           @"source" : source ?: @"",
                                           @"sourceType" : sourceType ?: @"",
                                           @"binary" : binary ?: @"",
                                           },
                                   @"currency" : @"NAS"
                                   },
                           @"callback" : url ?: kNASCallback
                           };
    
    kPayBlock = complete;
    NSString *urlString = [NSString stringWithFormat:NAS_NANO_SCHEMA_URL,
                           [self queryValueWithSerialNumber:sn andInfo:info]];
    return [self openUrl:urlString];
}

+ (void)checkStatusWithSerialNumber:(NSString *)number
              withCompletionHandler:(void (^)(NSDictionary *data))handler
                       errorHandler:(void (^)(NSInteger code, NSString *msg))errorHandler {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kNASCheckUrl, number]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            if (errorHandler) {
                errorHandler(error.code, error.description);
            }
        } else {
            NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if (resDict[@"code"] && [resDict[@"code"] integerValue] == 0) {
                if (handler) {
                    handler(resDict[@"data"]);
                }
            } else {
                if (errorHandler) {
                    errorHandler([resDict[@"code"] integerValue], resDict[@"msg"]);
                }
            }
        }
    }];
    [sessionDataTask resume];
}

+ (BOOL)handleURL:(NSURL *)url {
    NSString *prefix = [NSString stringWithFormat:@"%@://virtual?params=", kAppScheme];
    if (![url.absoluteString.lowercaseString containsString:@"://virtual?params="]) {
        return NO;
    }
    NSString *params = [url.absoluteString substringFromIndex:prefix.length].stringByRemovingPercentEncoding;
    return [self handleURLParams:params];
}


#pragma mark - private

+ (NSError *)openUrl:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
        return nil;
    }
    return [NSError errorWithDomain:@"Need NasNano"
                               code:-1
                           userInfo:@{
                                      @"msg" : @"没安装Nebulas智能数字钱包，请下载安装"
                                      }];
}

///handel openURL data
+ (BOOL)handleURLParams:(NSString *)params {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[params dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    if ([dict isKindOfClass:NSDictionary.class]) {
        NSString *action = [NSString stringWithFormat:@"%@", dict[@"action"]];
        NSInteger code = [dict[@"code"] integerValue];
        NSString *data = nil;
        if (dict[@"data"]) {
            data = [NSString stringWithFormat:@"%@", dict[@"data"]];
        }
        
        if ([action isEqualToString:@"auth"]) {
            if (code == 0) {
                kAuthBlock ? kAuthBlock(data) : nil;
            } else {
                kAuthBlock ? kAuthBlock(nil) : nil;
            }
            kAuthBlock = nil;
            return YES;
        } else if ([action isEqualToString:@"pay"]) {
            if (code == 0) {
                kPayBlock ? kPayBlock(YES, data) : nil;
            } else {
                kPayBlock ? kPayBlock(NO, nil) : nil;
            }
            kPayBlock = nil;
            return YES;
        }
    }
    return NO;
}


///generate query string
+ (NSString *)queryValueWithSerialNumber:(NSString *)sn andInfo:(NSDictionary *)info {
    NSMutableDictionary *dict = [NSMutableDictionary
                                 dictionaryWithDictionary:@{
                                                            @"category" : @"jump",
                                                            @"des" : @"confirmTransfer"
                                                            }];
    NSMutableDictionary *pageParams = [NSMutableDictionary
                                       dictionaryWithDictionary:@{ @"serialNumber" : sn ?: @"" }];
    if (info) {
        [pageParams addEntriesFromDictionary:info];
    }
    //app info
    if (kAppName && kAppIcon && kAppScheme) {
        //base64 encode image
        NSData *data = UIImageJPEGRepresentation(kAppIcon, 0.9f);
        NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        dict[@"dapp"] = @{@"name":kAppName,
                          @"icon":encodedImageStr,
                          @"scheme":kAppScheme
                          };
    }
    dict[@"pageParams"] = pageParams;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    return [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]
            stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
}

+ (NSString *)authQureyValueWithInfo:(NSDictionary *)info {
    NSMutableDictionary *dict = [NSMutableDictionary
                                 dictionaryWithDictionary:@{
                                                            @"category" : @"jump",
                                                            @"des" : @"auth"
                                                            }];
    if (info) {
        dict[@"pageParams"] = info;
    }
    //app info
    if (kAppName && kAppIcon && kAppScheme) {
        //base64 encode image
        NSData *data = UIImageJPEGRepresentation(kAppIcon, 0.9f);
        NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        dict[@"dapp"] = @{@"name":kAppName,
                          @"icon":encodedImageStr,
                          @"scheme":kAppScheme
                          };
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    return [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]
            stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
}

@end
