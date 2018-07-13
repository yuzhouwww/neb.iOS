//
//  NASSmartContracts.h
//  iosSDK
//
//  Created by Bobby on 2018/5/28.
//

#import <Foundation/Foundation.h>

// You need to add 'openapp.nasnano' to schema white list.
@interface NASSmartContracts : NSObject

/**
 * 初始化 SDK 设置.
 **/
+ (void)setAppName:(NSString *)name icon:(UIImage *)icon scheme:(NSString *)scheme;

/**
 * Handle result.
 **/
+ (BOOL)handleURL:(NSURL *)url;

/**
 * Go to debug mode. Default is product mode.
 **/
+ (void)debug:(BOOL)debug;

/**
 * Way to generate serialNumber.
 **/
+ (NSString *)randomCodeWithLength:(NSInteger)length;

/**
 * Check if NasNano is installed.
 **/
+ (BOOL)nasNanoInstalled;

/**
 * Go to appstore for NasNano.
 **/
+ (void)goToNasNanoAppStore;


/**
 Authenticate by a Wallet in your NASNano App.
 @param info additional data, optional
 @param complete called with a wallet address while done
 @return error occured when open NASNano App
 */
+ (NSError *)authWithInfo:(NSDictionary *)info
                 complete:(void (^)(NSString *walletAddress))complete;

/**
 * Pay for goods. Return nil if success.
 **/
+ (NSError *)payNas:(NSNumber *)nas
          toAddress:(NSString *)address
   withSerialNumber:(NSString *)sn
       forGoodsName:(NSString *)name
            andDesc:(NSString *)desc;

/**
 * Call a smart contract function. Return nil if success.
 **/
+ (NSError *)callWithMethod:(NSString *)method
                    andArgs:(NSArray *)args
                     payNas:(NSNumber *)nas
                  toAddress:(NSString *)address
           withSerialNumber:(NSString *)sn
               forGoodsName:(NSString *)name
                    andDesc:(NSString *)desc;

/**
 * Check status for an action.
 **/
+ (void)checkStatusWithSerialNumber:(NSString *)number
              withCompletionHandler:(void (^)(NSDictionary *data))handler
                       errorHandler:(void (^)(NSInteger code, NSString *msg))errorHandler;

@end
