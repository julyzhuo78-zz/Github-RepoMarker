//
//  RepositoryListObjCTableViewController.m
//  NetworkRequestPractice
//
//  Created by Ran Zhuo on 2018-12-05.
//  Copyright © 2018 Ran Zhuo. All rights reserved.
//

#import "RepositoryListObjCTableViewController.h"
#import "NetworkDataStoreReactiveObjC.h"
#import "NetworkRequestManagerReactiveObjC.h"
#import "AddURLObjCViewController.h"
#import <SafariServices/SafariServices.h>

@interface RepositoryListObjCTableViewController ()
@property (strong, nonatomic) NetworkDataStoreReactiveObjC *networkDataStore;
@property (strong, nonatomic) NetworkRequestManagerReactiveObjC *networkRequestManager;
@end

@implementation RepositoryListObjCTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNetworkDataStore];
    self.networkRequestManager = [[NetworkRequestManagerReactiveObjC alloc] init:[NSUserDefaults standardUserDefaults]];
}

- (void)setUpNetworkDataStore {
    self.networkDataStore = [[NetworkDataStoreReactiveObjC alloc] init];
    [self.networkDataStore refreshRepositoryNames];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.networkDataStore.arrayOfRepoNames.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"repoNames" forIndexPath:indexPath];
    cell.textLabel.text = self.networkDataStore.arrayOfRepoNames[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.networkDataStore.currentRepoName = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    [self fetchReadMeData];
}





#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    AddURLObjCViewController *vc = (AddURLObjCViewController *)segue.destinationViewController;
    [vc.didFinishSubject subscribeNext:^(id  _Nullable urlString) {
        NSString *url = (NSString *)urlString;
        [self.networkDataStore addURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}


- (void)fetchReadMeData {
    NSString *readMeURL = [self.networkDataStore getReadMeURL];
    [[self.networkRequestManager fetchReadmeHTML:readMeURL] subscribeNext:^(id  _Nullable htmlURL) {
        if (!htmlURL) {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURL *url = [NSURL URLWithString:htmlURL];
            SFSafariViewController *vc = [[SFSafariViewController alloc] initWithURL:url];
            [self presentViewController:vc animated:YES completion:nil];
        });
    }];
}

@end
