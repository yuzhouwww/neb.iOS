//
//  ViewController.m
//  demo
//
//  Created by Bobby on 2018/5/28.
//

#import "ViewController.h"
#import <NASSmartContracts.h>

#define ViewTagOffset 100

@interface ViewController () <UITextFieldDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSDictionary<NSString *, id> *config;
@property (nonatomic, strong) NSString *sn;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIScrollView *inputScrollView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputScrollViewHeightConstraint;

@property (nonatomic) CGFloat originScrollviewHeight;
@property (nonatomic) CGFloat originTextViewHeight;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.config =
    @{
        @"Auth":
        @{
            @"buttons":
            @[
             @"Request Authentication"
             ]
        },
        
        @"NAS":
        @{
            @"inputs":
            @[
             @{
                 @"name": @"to",
                 @"text": @"n1RZfatTFvkXPUa8M9bGJyV8AZmjLQZQzrt"
             },
             @{
                 @"name": @"value",
                 @"text": @"1"
             }
             ],
            @"buttons":
            @[
             @"Pay",
             @"Check"
             ]
        },
        
        @"NRC20":
        @{
            @"inputs":
            @[
             @{
                 @"name": @"to",
                 @"text": @"n22PdtQepev7rcQgy3zqfdAkNPN2pSpywZ8"
             },
             @{
                 @"name": @"value",
                 @"text": @"1"
             }
             ],
            @"buttons":
            @[
             @"Pay",
             @"Check"
             ]
        },
        
        @"CALL":
        @{
            @"inputs":
            @[
             @{
                 @"name": @"to",
                 @"text": @"n22PdtQepev7rcQgy3zqfdAkNPN2pSpywZ8"
             },
             @{
                 @"name": @"value",
                 @"text": @"1"
             },
             @{
                 @"name": @"method",
                 @"text": @"save"
             },
             @{
                 @"name": @"args",
                 @"text": @"testkey,testvalue",
                 @"placeholder": @"args seperated by comma（参数以半角逗号隔开）"
             }
             ],
            @"buttons":
            @[
             @"Call",
             @"Check"
            ]
        },
        
        @"DEPLOY":
        @{
            @"inputs":
            @[
             @{
                 @"name": @"source"
             },
             @{
                 @"name": @"sourceType",
                 @"placeholder": @"javascript/typescript"
             }
             ],
            @"buttons":
            @[
             @"Deploy",
             @"Check"
             ]
        }
    };
    
    NSArray *titles = @[@"NAS", @"NRC20", @"CALL", @"DEPLOY", @"Auth"];
    
    [self.segmentedControl removeAllSegments];
    for (NSString *title in titles) {
        [self.segmentedControl insertSegmentWithTitle:title atIndex:self.segmentedControl.numberOfSegments animated:NO];
    }
    
    [self.segmentedControl setSelectedSegmentIndex:0];
    [self segmentAction:self.segmentedControl];
}

- (IBAction)segmentAction:(UISegmentedControl *)sender {
    for (UIView *view in self.inputScrollView.subviews.copy) {
        [view removeFromSuperview];
    }
    
    NSDictionary *configItem = self.config[[self.segmentedControl titleForSegmentAtIndex:self.segmentedControl.selectedSegmentIndex]];
    NSArray<NSDictionary *> *inputs = configItem[@"inputs"];
    NSArray<NSString *> *buttons = configItem[@"buttons"];
    
    __block CGFloat currentY = 20;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat scrollViewWidth = screenWidth - 40;
    CGFloat buttonSpace = 20;
    
    [inputs enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull input, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *name = input[@"name"];
        NSString *text = input[@"text"];
        NSString *placeholder = input[@"placeholder"];
        
        UILabel *label = [UILabel new];
        label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        label.textColor = [UIColor blackColor];
        label.text = name;
        [label sizeToFit];
        label.frame = CGRectMake(0, currentY, label.bounds.size.width, label.bounds.size.height);
        [self.inputScrollView addSubview:label];
        currentY += label.bounds.size.height + 8;
        
        UITextField *field = [UITextField new];
        field.delegate = self;
        field.tag = ViewTagOffset + idx;
        field.borderStyle = UITextBorderStyleRoundedRect;
        field.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        field.textColor = [UIColor blackColor];
        field.text = text ?: nil;
        field.placeholder = placeholder ?: name;
        field.keyboardType = [name isEqualToString:@"value"] ? UIKeyboardTypeDecimalPad : UIKeyboardTypeDefault;
        field.returnKeyType = UIReturnKeyDone;
        field.frame = CGRectMake(0, currentY, scrollViewWidth , 40);
        [self.inputScrollView addSubview:field];
        currentY += field.bounds.size.height + 10;
    }];
    
    if (buttons.count) {
        currentY += 20;
        CGFloat buttonWidth = (scrollViewWidth - (buttons.count - 1) * buttonSpace) / buttons.count;
        [buttons enumerateObjectsUsingBlock:^(NSString * _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.backgroundColor = button.tintColor;
            button.layer.cornerRadius = 5;
            button.layer.masksToBounds = YES;
            button.frame = CGRectMake(idx * (buttonWidth + buttonSpace), currentY, buttonWidth, 44);
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.inputScrollView addSubview:button];
        }];
        currentY += 44;
    }
    
    currentY += 20;
    
    self.inputScrollView.contentSize = CGSizeMake(scrollViewWidth, currentY);
    
    if (currentY > self.inputScrollView.bounds.size.height) {
        [UIView animateWithDuration:0.3 animations:^{
            self.inputScrollViewHeightConstraint.constant = currentY;
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)buttonAction:(UIButton *)button {
    NSString *segmentTitle = [self.segmentedControl titleForSegmentAtIndex:self.segmentedControl.selectedSegmentIndex];
    if ([segmentTitle isEqualToString:@"Auth"]) {
        [self auth];
    } else if ([segmentTitle isEqualToString:@"NAS"]) {
        if ([button.titleLabel.text isEqualToString:@"Check"]) {
            [self check];
        } else {
            [self payNasTo:[self inputAtIndex:0] value:[self inputAtIndex:1]];
        }
    } else if ([segmentTitle isEqualToString:@"NRC20"]) {
        if ([button.titleLabel.text isEqualToString:@"Check"]) {
            [self check];
        } else {
            [self payNrc20To:[self inputAtIndex:0] value:[self inputAtIndex:1]];
        }
    } else if ([segmentTitle isEqualToString:@"CALL"]) {
        if ([button.titleLabel.text isEqualToString:@"Check"]) {
            [self check];
        } else {
            [self callMethod:[self inputAtIndex:2] args:[self inputAtIndex:3] to:[self inputAtIndex:0] value:[self inputAtIndex:1]];
        }
    } else if ([segmentTitle isEqualToString:@"DEPLOY"]) {
        if ([button.titleLabel.text isEqualToString:@"Check"]) {
            [self check];
        } else {
            [self deploySource:[self inputAtIndex:0] sourceType:[self inputAtIndex:1]];
        }
    }
}

- (NSString *)inputAtIndex:(NSInteger)index {
    UITextField *field = [self.inputScrollView viewWithTag:ViewTagOffset + index];
    if ([field isKindOfClass:UITextField.class]) {
        NSLog(@"index: %ld", (long)index);
        NSLog(@"input: %@", field.text);
        return field.text;
    }
    return nil;
}

- (void)auth {
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

- (void)payNasTo:(NSString *)to value:(NSString *)value {
    self.sn = [NASSmartContracts randomSerialNumber];
    NSError *error = [NASSmartContracts payNas:[NSNumber numberWithLongLong:value.longLongValue]
                                     toAddress:to
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

- (void)payNrc20To:(NSString *)to value:(NSString *)value {
    self.sn = [NASSmartContracts randomSerialNumber];
    NSError *error = [NASSmartContracts payNrc20:[NSNumber numberWithLongLong:value.longLongValue]
                                       toAddress:to
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

- (void)callMethod:(NSString *)method
              args:(NSString *)args
                to:(NSString *)to
             value:(NSString *)value {
    self.sn = [NASSmartContracts randomSerialNumber];
    NSArray *argsArray = [args componentsSeparatedByString:@","];
    NSError *error = [NASSmartContracts callMethod:method
                                          withArgs:argsArray
                                            payNas:[NSNumber numberWithLongLong:value.longLongValue]
                                         toAddress:to
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

- (void)deploySource:(NSString *)source sourceType:(NSString *)sourceType {
    self.sn = [NASSmartContracts randomSerialNumber];
    NSError *error = [NASSmartContracts deployContractWithSource:source
                                                      sourceType:sourceType
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

- (void)check {
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

- (IBAction)goAppStore {
    [NASSmartContracts goToNasNanoAppStore];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.isTracking) {
        [self.view endEditing:YES];
    }
}

- (IBAction)handlerPanAction:(UIPanGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            self.originScrollviewHeight = self.inputScrollView.bounds.size.height;
            self.originTextViewHeight = self.textView.bounds.size.height;
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint offset = [gesture translationInView:gesture.view];
            CGFloat targetHeight = self.originScrollviewHeight + offset.y;
            if (targetHeight >= 100) {
                self.inputScrollViewHeightConstraint.constant = targetHeight;
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            self.originScrollviewHeight = 0;
            self.originTextViewHeight = 0;
            break;
        default:
            break;
    }
}

@end
