//
//  ViewController.m
//  demo
//
//  Created by Bobby on 2018/5/28.
//

#import "ViewController.h"
#import <NASSmartContracts.h>

@interface ViewController ()

@property (nonatomic, strong) NSString *sn;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)auth:(id)sender {
    self.textView.text = @"authorizing...";
    __weak typeof(self) wself = self;
    [NASSmartContracts authWithInfo:nil complete:^(NSString *walletAddress) {
        if (walletAddress.length) {
            wself.textView.text = [NSString stringWithFormat:@"Auth succeed! Wallet address:\n%@", walletAddress];
        } else {
            wself.textView.text = @"Failed to auth";
        }
    }];
}

- (IBAction)pay:(id)sender {
    self.sn = [NASSmartContracts randomSerialNumber];
    NSError *error = [NASSmartContracts payNas:@(0.0001)
                                     toAddress:@"n1RZfatTFvkXPUa8M9bGJyV8AZmjLQZQzrt"
                                  serialNumber:self.sn
                                     goodsName:@"test1"
                                   description:@"desc1"
                                   callbackURL:nil
                                      complete:^(BOOL success, NSString *txHash) {
                                          if (success) {
                                              self.textView.text = [NSString stringWithFormat:@"Pay succeed! txHash:\n%@", txHash];
                                          } else {
                                              self.textView.text = @"Failed to pay";
                                          }
                                      }];
    if (error) {
        self.textView.text = error.userInfo[@"msg"];
        [NASSmartContracts goToNasNanoAppStore];
    } else {
        self.textView.text = @"Paying...";
    }
}

- (IBAction)payNrc20:(id)sender {
    self.sn = [NASSmartContracts randomSerialNumber];
    NSError *error = [NASSmartContracts payNrc20:@(1)
                                       toAddress:@"n1awhGQjpjWya785r5ht7FYTNoVAmQAqKpb"
                                    serialNumber:self.sn
                                       goodsName:@"test2"
                                     description:@"des2"
                                     callbackURL:nil
                                        complete:^(BOOL success, NSString *txHash) {
                                            if (success) {
                                                self.textView.text = [NSString stringWithFormat:@"Pay succeed! txHash:\n%@", txHash];
                                            } else {
                                                self.textView.text = @"Failed to pay";
                                            }
                                      }];
    if (error) {
        self.textView.text = error.userInfo[@"msg"];
        [NASSmartContracts goToNasNanoAppStore];
    } else {
        self.textView.text = @"Paying...";
    }
}

- (IBAction)call:(id)sender {
    self.sn = [NASSmartContracts randomSerialNumber];
    NSError *error = [NASSmartContracts callMethod:@"save"
                                          withArgs:@[@"key111", @"value111"]
                                            payNas:@(0)
                                         toAddress:@"n1zVUmH3BBebksT4LD5gMiWgNU9q3AMj3se"
                                      serialNumber:self.sn
                                         goodsName:@"test3"
                                       description:@"desc3"
                                       callbackURL:nil
                                          complete:^(BOOL success, NSString *txHash) {
                                                  if (success) {
                                                      self.textView.text = [NSString stringWithFormat:@"Call succeed! txHash:\n%@", txHash];
                                                  } else {
                                                      self.textView.text = @"Failed to call";
                                                  }
                                              }];
    if (error) {
        self.textView.text = error.userInfo[@"msg"];
        [NASSmartContracts goToNasNanoAppStore];
    } else {
        self.textView.text = @"Calling...";
    }
}

- (IBAction)deploy:(id)sender {
    self.sn = [NASSmartContracts randomSerialNumber];
    NSError *error = [NASSmartContracts deployContractWithSource:nil
                                                      sourceType:nil
                                                          binary:nil
                                                    serialNumber:self.sn
                                                     callbackURL:nil complete:^(BOOL success, NSString *txHash) {
        if (success) {
            self.textView.text = [NSString stringWithFormat:@"Deploy succeed! txHash:\n%@", txHash];
        } else {
            self.textView.text = @"Failed to deploy";
        }
    }];
    if (error) {
        self.textView.text = error.userInfo[@"msg"];
        [NASSmartContracts goToNasNanoAppStore];
    } else {
        self.textView.text = @"Deploying...";
    }
}

- (IBAction)check:(id)sender {
    self.textView.text = @"checking...";
    [NASSmartContracts checkStatusWithSerialNumber:self.sn
                             withCompletionHandler:^(NSDictionary *data) {
                                 NSData *json = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
                                 NSString *string = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     self.textView.text = string;
                                 });
                             } errorHandler:^(NSInteger code, NSString *msg) {
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     self.textView.text = msg;
                                 });
                             }];
}

- (IBAction)goAppStore:(id)sender {
    [NASSmartContracts goToNasNanoAppStore];
}

@end
