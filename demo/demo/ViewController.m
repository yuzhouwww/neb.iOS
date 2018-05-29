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

- (IBAction)pay:(id)sender {
    self.sn = [NASSmartContracts randomCodeWithLength:32];
    NSError *error = [NASSmartContracts payNas:@(0.0001)
                                     toAddress:@"n1a4MqSPPND7d1UoYk32jXqKb5m5s3AN6wB"
                              withSerialNumber:self.sn
                                  forGoodsName:@"test1"
                                       andDesc:@"desc"];
    if (error) {
        NSLog(@"%@", error.userInfo[@"msg"]);
        [NASSmartContracts goToNasNanoAppStore];
    }
}

- (IBAction)call:(id)sender {
    self.sn = [NASSmartContracts randomCodeWithLength:32];
    NSError *error = [NASSmartContracts callWithMethod:@"save"
                                               andArgs:@[@"key111", @"value111"]
                                                payNas:@(0)
                                             toAddress:@"n1zVUmH3BBebksT4LD5gMiWgNU9q3AMj3se"
                                      withSerialNumber:self.sn
                                          forGoodsName:@"test2"
                                               andDesc:@"desc2"];
    if (error) {
        NSLog(@"%@", error.userInfo[@"msg"]);
        [NASSmartContracts goToNasNanoAppStore];
    }
}

- (IBAction)check:(id)sender {
    [NASSmartContracts checkStatusWithSerialNumber:self.sn
                             withCompletionHandler:^(NSDictionary *data) {
                                 NSData *json = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
                                 NSString *string = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
                                 NSLog(@"%@", string);
                             } errorHandler:^(NSInteger code, NSString *msg) {
                                 NSLog(@"%@", msg);
                             }];
}

- (IBAction)goAppStore:(id)sender {
    [NASSmartContracts goToNasNanoAppStore];
}

@end