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
 Config SDK.

 @param name your app's name
 @param icon your appls icon image
 @param scheme URL scheme which is supported by your app
 */
+ (void)setupWithAppName:(NSString *)name icon:(UIImage *)icon scheme:(NSString *)scheme;

/**
 * Set debug mode. Default is NO. Don't call this in your release version!
 **/
+ (void)debugMode:(BOOL)debugMode;

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
                 complete:(void (^)(BOOL success, NSString *walletAddress, NSString *message))complete;

/**
 * Pay for goods. Return nil if success.
 **/
+ (NSError *)payNas:(NSNumber *)nas
          toAddress:(NSString *)address
           gasLimit:(NSString *)gasLimit
           gasPrice:(NSString *)gasPrice
       serialNumber:(NSString *)sn
          goodsName:(NSString *)name
        description:(NSString *)desc
        callbackURL:(NSString *)url
           complete:(void (^)(BOOL success, NSString *txHash, NSString *message))complete;

/**
 * Pay for goods. Return nil if success.
 **/
+ (NSError *)payNrc20:(NSNumber *)nrc
            toAddress:(NSString *)address
             gasLimit:(NSString *)gasLimit
             gasPrice:(NSString *)gasPrice
         serialNumber:(NSString *)sn
            goodsName:(NSString *)name
          description:(NSString *)desc
          callbackURL:(NSString *)url
             complete:(void (^)(BOOL success, NSString *txHash, NSString *message))complete;

/**
 * Call a smart contract function. Return nil if success.
 **/
+ (NSError *)callMethod:(NSString *)method
               withArgs:(NSArray *)args
                 payNas:(NSNumber *)nas
              toAddress:(NSString *)address
               gasLimit:(NSString *)gasLimit
               gasPrice:(NSString *)gasPrice
           serialNumber:(NSString *)sn
              goodsName:(NSString *)name
            description:(NSString *)desc
            callbackURL:(NSString *)url
               complete:(void (^)(BOOL success, NSString *txHash, NSString *message))complete;

/**
 * Deploy a smart contract. Return nil if success.
 **/
+ (NSError *)deployContractWithSource:(NSString *)source
                           sourceType:(NSString *)sourceType
                               binary:(NSString *)binary
                             gasLimit:(NSString *)gasLimit
                             gasPrice:(NSString *)gasPrice
                         serialNumber:(NSString *)sn
                          callbackURL:(NSString *)url
                             complete:(void (^)(BOOL success, NSString *txHash, NSString *message))complete;

/**
 * Check status for an action.
 **/
+ (void)checkStatusWithSerialNumber:(NSString *)number
              withCompletionHandler:(void (^)(NSDictionary *data))handler
                       errorHandler:(void (^)(NSInteger code, NSString *msg))errorHandler;

@end
