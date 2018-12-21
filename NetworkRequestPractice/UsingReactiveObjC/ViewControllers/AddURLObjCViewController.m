//
//  AddURLObjCViewController.m
//  NetworkRequestPractice
//
//  Created by Ran Zhuo on 2018-12-05.
//  Copyright © 2018 Ran Zhuo. All rights reserved.
//

#import "AddURLObjCViewController.h"
#import "NetworkRequestManagerReactiveObjC.h"
#import "URLConverter.h"


@interface AddURLObjCViewController ()
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UILabel *invalidURLWarning;
@property (strong, nonatomic) NetworkRequestManagerReactiveObjC *networkRequestManager;
@property (strong, nonatomic) URLConverter *urlConverter;


@end

@implementation AddURLObjCViewController
- (RACSubject *)didFinishSubject {
    if (!_didFinishSubject) {
        _didFinishSubject = [RACSubject subject];
    }
    return _didFinishSubject;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.networkRequestManager = [[NetworkRequestManagerReactiveObjC alloc] init:[NSUserDefaults standardUserDefaults]];
    self.urlConverter = [[URLConverter alloc] init];
    [self.invalidURLWarning setHidden:YES];
}

- (IBAction)addTapped:(UIButton *)sender {
    NSString *urlString = [self.urlConverter convertToGitHubApiUrl:self.urlTextField.text];
    if (!urlString) {
        return [self showWarningAndStayOnMainThread:YES];
    }
    
    [[self.networkRequestManager fetchReadMeDataFromNetworkRequest:urlString] subscribeNext:^(id _Nullable isURLValid) {
        if ([isURLValid isEqualToNumber:[NSNumber numberWithBool:NO]]) {
            __weak AddURLObjCViewController *weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf showWarningAndStayOnMainThread:YES];
            });
            return;
        } else  {
            [self.didFinishSubject sendNext:urlString];
            __weak AddURLObjCViewController *weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf showWarningAndStayOnMainThread:NO];
            });
            return;
        }
    }];
}

- (IBAction)textDidChange:(UITextField *)sender {
    [self.invalidURLWarning setHidden:YES];
}


- (void)showWarningAndStayOnMainThread:(BOOL)shouldShow {
    if (shouldShow) {
        [self.invalidURLWarning setHidden:NO];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
