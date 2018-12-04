//
//  CallbackViewController.m
//  NetworkRequestPractice
//
//  Created by Ran Zhuo on 2018-11-30.
//  Copyright © 2018 Ran Zhuo. All rights reserved.
//

#import "CallbackViewController.h"
#import "NetworkRequester.h"
#import "GitURLSession.h"
#import "AddURLViewController.h"
#import "ReadMeViewController.h"
#import "NetworkDataStore.h"

@interface CallbackViewController()
@property (strong, nonatomic) NetworkDataStore *networkDataStore;
@end

@implementation CallbackViewController
- (void)viewDidLoad {
    [super viewDidLoad];
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
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"repoName" forIndexPath:indexPath];
     cell.textLabel.text = [self.networkDataStore.arrayOfRepoNames objectAtIndex:indexPath.row];
     return cell;
 }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.networkDataStore.currentRepoName = cell.textLabel.text;
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addURL"]) {
        AddURLViewController *vc = (AddURLViewController *)segue.destinationViewController;
        vc.callbackDelegate = self;
    } else if ([segue.identifier isEqualToString:@"readme"]) {
        ReadMeViewController *vc = (ReadMeViewController *)segue.destinationViewController;
        vc.networkDataStore = self.networkDataStore;
    }
}

- (void)didFinishedWithCurrentURL:(NSString *)urlString {
    [self.networkDataStore addURL:urlString];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}


@end
