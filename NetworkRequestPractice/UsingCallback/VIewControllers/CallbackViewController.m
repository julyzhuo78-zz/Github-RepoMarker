//
//  CallbackViewController.m
//  NetworkRequestPractice
//
//  Created by Ran Zhuo on 2018-11-30.
//  Copyright © 2018 Ran Zhuo. All rights reserved.
//
//https://github.com/julyzhuo/dev
#import "CallbackViewController.h"
#import "NetworkRequestManager.h"
#import "GitURLSession.h"
#import "AddURLViewController.h"
#import "ReadMeViewController.h"
#import "NetworkDataStore.h"
#import <SafariServices/SafariServices.h>


@interface CallbackViewController()
@property (strong, nonatomic) NetworkDataStore *networkDataStore;
@property (strong, nonatomic) NetworkRequestManager *networkRequestManager;
@end

@implementation CallbackViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.networkRequestManager = [[NetworkRequestManager alloc] initWithUserDefaults:[NSUserDefaults standardUserDefaults]];
    [self setUpNetworkDataStore];
    [self reloadInputViews];
}

- (void)setUpNetworkDataStore {
    self.networkDataStore = [[NetworkDataStore alloc] init];
    [self.networkDataStore refreshRepositoryNames];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.networkDataStore.arrayOfRepoNames count];
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"callback" forIndexPath:indexPath];
     cell.textLabel.text = [self.networkDataStore.arrayOfRepoNames objectAtIndex:indexPath.row];
     return cell;
 }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.networkDataStore.currentRepoName = cell.textLabel.text;
    [self fetchReadMeContent];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addURL"]) {
        AddURLViewController *vc = (AddURLViewController *)segue.destinationViewController;
        vc.callbackDelegate = self;
    } 
}

- (void)didFinishedWithCurrentURL:(NSString *)urlString {
    [self.networkDataStore addURL:urlString];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)fetchReadMeContent {
    NSString *readMeURL = [self.networkDataStore getReadMeURL];
    if (!readMeURL) {
        [self invalidReadMeContent];
        return;
    }

    [self.networkRequestManager fetchReadmeHTMLWithURLString:readMeURL completionHandler:^(NSString * _Nonnull readmeHTML) {
        if (!readmeHTML) {
            return [self invalidReadMeContent];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURL *url = [NSURL URLWithString:readmeHTML];
            SFSafariViewController *vc = [[SFSafariViewController alloc] initWithURL:url];
            [self presentViewController:vc animated:YES completion:nil];
        });
    }];
}

- (void)invalidReadMeContent {
//    self.readMeContent.text = @"Error found in searching content of README.md";
}


@end
