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
 * Set debug mode. Default is NO. Don't call this in your product release!
 **/
+ (void)debugMode:(BOOL)debugMode;

/**
 * Handle openURL.
 **/
+ (BOOL)handleURL:(NSURL *)url;

/**
 * Check if NAS nano app is installed.
 **/
+ (BOOL)nasNanoInstalled;

/**
 * Go to NAS nano page in App Store.
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
 Pay with NAS

 @param amount amount of NAS
 @param address address to pay to
 @param gasLimit max limit of gas
 @param gasPrice price you wish to pay for a gas
 @param sn serial number of this payment
 @param name goods name
 @param desc payment description
 @param url callback url which can receive the payment result
 @param complete callback block
 @return if user didn't install NAS nano app, this method will return an error
 */
+ (NSError *)payNas:(NSNumber *)amount
          toAddress:(NSString *)address
           gasLimit:(NSString *)gasLimit
           gasPrice:(NSString *)gasPrice
       serialNumber:(NSString *)sn
          goodsName:(NSString *)name
        description:(NSString *)desc
        callbackURL:(NSString *)url
           complete:(void (^)(BOOL success, NSString *txHash, NSString *message))complete;

/**
 * Pay with NAS
 
 @param amount amount of NAS
 @param address address to pay to
 @param gasLimit max limit of gas
 @param gasPrice price you wish to pay for a gas
 @param sn serial number of this payment
 @param name goods name
 @param desc payment description
 @param url callback url which can receive the payment result
 @param complete callback block
 **/
+ (NSError *)payNRC20:(NSNumber *)amount
            toAddress:(NSString *)address
             gasLimit:(NSString *)gasLimit
             gasPrice:(NSString *)gasPrice
         serialNumber:(NSString *)sn
            goodsName:(NSString *)name
          description:(NSString *)desc
          callbackURL:(NSString *)url
             complete:(void (^)(BOOL success, NSString *txHash, NSString *message))complete;

/**
 * Call a smart contract function
 
 @param method method to call
 @param args arguments to pass
 @param amount amount of NAS
 @param address wallet address you are about to transfer NAS to
 @param gasLimit max limit of gas
 @param gasPrice price you wish to pay for a gas
 @param sn serial number of this payment
 @param name goods name
 @param desc payment description
 @param url callback url which can receive the payment result
 @param complete callback block
 @return if user didn't install NAS nano app, this method will return an error
 **/
+ (NSError *)callMethod:(NSString *)method
               withArgs:(NSArray *)args
                 payNas:(NSNumber *)amount
              toAddress:(NSString *)address
               gasLimit:(NSString *)gasLimit
               gasPrice:(NSString *)gasPrice
           serialNumber:(NSString *)sn
              goodsName:(NSString *)name
            description:(NSString *)desc
            callbackURL:(NSString *)url
               complete:(void (^)(BOOL success, NSString *txHash, NSString *message))complete;


/**
 Deploy a contract

 @param source source code
 @param sourceType type of the source code, available values are "javascript" and "typescript"
 @param binary optional
 @param gasLimit max limit of gas
 @param gasPrice price you wish to pay for a gas
 @param sn serial number of this payment
 @param url callback url which can receive the payment result
 @param complete callback block
 @return if user didn't install NAS nano app, this method will return an error
 */
+ (NSError *)deployContractWithSource:(NSString *)source
                           sourceType:(NSString *)sourceType
                               binary:(NSString *)binary
                             gasLimit:(NSString *)gasLimit
                             gasPrice:(NSString *)gasPrice
                         serialNumber:(NSString *)sn
                          callbackURL:(NSString *)url
                             complete:(void (^)(BOOL success, NSString *txHash, NSString *message))complete;

/**
 * Check transfer's status with a serial number.
 **/
+ (void)checkStatusWithSerialNumber:(NSString *)sn
              withCompletionHandler:(void (^)(NSDictionary *data))handler
                       errorHandler:(void (^)(NSInteger code, NSString *msg))errorHandler;

@end
