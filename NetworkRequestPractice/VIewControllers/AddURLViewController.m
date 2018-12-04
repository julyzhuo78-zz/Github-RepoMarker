//
//  AddURLViewController.m
//  NetworkRequestPractice
//
//  Created by Ran Zhuo on 2018-11-30.
//  Copyright © 2018 Ran Zhuo. All rights reserved.
//

#import "AddURLViewController.h"
#import "NetworkRequester.h"
#import "GitURLSession.h"
#import "NetworkRequestManager.h"
#import "URLConverter.h"

@interface AddURLViewController ()
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIButton *addURLButton;
@property (weak, nonatomic) IBOutlet UILabel *invalidURLWarning;
@property (strong, nonatomic) NetworkRequestManager *networkRequestManager;
@property (strong, nonatomic) URLConverter *urlConverter;
@end

@implementation AddURLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.invalidURLWarning setHidden:YES];
    self.networkRequestManager = [[NetworkRequestManager alloc] initWithUserDefaults:[NSUserDefaults standardUserDefaults]];
    self.urlConverter = [[URLConverter alloc] init];
    [self configureURLTextField];
}

- (void)configureURLTextField {
    self.urlTextField.placeholder = @"Sample: https://github.com/user-name/repo-name";
}

- (IBAction)addTapped:(UIButton *)sender {
    [self makeNetworkRequest];
}

- (IBAction)textDidChange:(UITextField *)sender {
    [self.invalidURLWarning setHidden:YES];
}

- (void)makeNetworkRequest {
    NSString *urlString = [self.urlConverter convertToGitHubApiUrl:self.urlTextField.text];
    if (!urlString) {
        return [self showWarningAndStayOnMainThread:YES];
    }
    [self.networkRequestManager fetchReadmeDataFromRequesterWithURLString:urlString completionHandler:^(BOOL needUpdate) {
        if (!needUpdate) {
            NSLog(@"Duplicate url has been entered");
            __weak AddURLViewController *weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf showWarningAndStayOnMainThread:YES];
            });
            return;
        }
        [self.callbackDelegate didFinishedWithCurrentURL:urlString];
        __weak AddURLViewController *weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf showWarningAndStayOnMainThread:NO];
        });
        return;
    }];
}

- (void)showWarningAndStayOnMainThread:(BOOL)shouldShow {
    if (shouldShow) {
        [self.invalidURLWarning setHidden:NO];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
