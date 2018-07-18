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
 * Config SDK.
 **/
+ (void)setAppName:(NSString *)name icon:(UIImage *)icon scheme:(NSString *)scheme;

/**
 * Go to debug mode. Default is product mode.
 **/
+ (void)debug:(BOOL)debug;

/**
 * Handle openURL.
 **/
+ (BOOL)handleURL:(NSURL *)url;

/**
 * Check if NasNano is installed.
 **/
+ (BOOL)nasNanoInstalled;

/**
 * Go to appstore for NasNano.
 **/
+ (void)goToNasNanoAppStore;

/**
 * Generate a 32-length SerialNumber.
 **/
+ (NSString *)randomSerialNumber;

/**
 Authenticate by a Wallet in your NASNano App.
 @param info additional data, optional
 @param complete called with a wallet address while done
 @return error occured when open NASNano App
 */
+ (NSError *)authWithInfo:(nullable NSDictionary *)info
                 complete:(void (^)(NSString *walletAddress))complete;

/**
 * Pay for goods. Return nil if success.
 **/
+ (NSError *)payNas:(NSNumber *)nas
          toAddress:(NSString *)address
       serialNumber:(NSString *)sn
          goodsName:(NSString *)name
        description:(NSString *)desc
        callbackURL:(NSString *)url
           complete:(void (^)(BOOL success, NSString *txHash))complete;

/**
 * Pay for goods. Return nil if success.
 **/
+ (NSError *)payNrc20:(NSNumber *)nrc
            toAddress:(NSString *)address
         serialNumber:(NSString *)sn
            goodsName:(NSString *)name
          description:(NSString *)desc
          callbackURL:(NSString *)url
             complete:(void (^)(BOOL success, NSString *txHash))complete;

/**
 * Call a smart contract function. Return nil if success.
 **/
+ (NSError *)callMethod:(NSString *)method
               withArgs:(NSArray *)args
                 payNas:(NSNumber *)nas
              toAddress:(NSString *)address
           serialNumber:(NSString *)sn
              goodsName:(NSString *)name
            description:(NSString *)desc
            callbackURL:(NSString *)url
               complete:(void (^)(BOOL success, NSString *txHash))complete;

/**
 * Deploy a smart contract. Return nil if success.
 **/
+ (NSError *)deployContractWithSource:(NSString *)source
                           sourceType:(NSString *)sourceType
                               binary:(NSString *)binary
                         serialNumber:(NSString *)sn
                          callbackURL:(NSString *)url
                             complete:(void (^)(BOOL success, NSString *txHash))complete;

/**
 * Check status for an action.
 **/
+ (void)checkStatusWithSerialNumber:(NSString *)number
              withCompletionHandler:(void (^)(NSDictionary *data))handler
                       errorHandler:(void (^)(NSInteger code, NSString *msg))errorHandler;

@end
