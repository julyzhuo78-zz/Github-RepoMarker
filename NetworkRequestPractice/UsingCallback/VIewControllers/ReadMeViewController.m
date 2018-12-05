//
//  ReadMeViewController.m
//  NetworkRequestPractice
//
//  Created by Ran Zhuo on 2018-12-03.
//  Copyright © 2018 Ran Zhuo. All rights reserved.
//

#import "ReadMeViewController.h"
#import "NetworkRequestManager.h"
#import <SafariServices/SafariServices.h>

@interface ReadMeViewController ()
@property (strong, nonatomic) NetworkRequestManager *networkRequestManager;
@property (weak, nonatomic) IBOutlet UITextView *readMeContent;

@end

@implementation ReadMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.networkRequestManager = [[NetworkRequestManager alloc] initWithUserDefaults:[NSUserDefaults standardUserDefaults]];
    [self fetchReadMeContent];
}


- (void)fetchReadMeContent {
    NSString *readMeURL = [self.networkDataStore getReadMeURL];
    if (!readMeURL) {
        [self invalidReadMeContent];
        return;
    }
//    [self.networkRequestManager fetchReadmeContentWithURLString:readMeURL completionHandler:^(NSString * _Nonnull readmeContent) {
//        if (!readmeContent){
//            return [self invalidReadMeContent];
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.readMeContent.text = readmeContent;
//        });
//    }];
    [self.networkRequestManager fetchReadmeHTMLWithURLString:readMeURL completionHandler:^(NSString * _Nonnull readmeHTML) {
        if (!readMeURL) {
            return [self invalidReadMeContent];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURL *url = [NSURL URLWithString:readmeHTML];
            SFSafariViewController *vc = [[SFSafariViewController alloc] initWithURL:url];
            [self.navigationController pushViewController:vc animated:YES];
        });
    }];
}

- (void)invalidReadMeContent {
    self.readMeContent.text = @"Error found in searching content of README.md";
}

@end
