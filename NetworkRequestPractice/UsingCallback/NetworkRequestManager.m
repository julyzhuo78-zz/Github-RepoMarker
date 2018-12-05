//
//  NetworkRequestManager.m
//  NetworkRequestPractice
//
//  Created by Ran Zhuo on 2018-11-30.
//  Copyright © 2018 Ran Zhuo. All rights reserved.
//

#import "NetworkRequestManager.h"
#import "NetworkRequester.h"
#import "GitURLSession.h"

@interface NetworkRequestManager()
@property (strong, nonatomic) NetworkRequester *networkRequester;
@property (strong, nonatomic) NSUserDefaults *userDefaults;

@end


@implementation NetworkRequestManager
- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefaults
{
    self = [super init];
    if (self) {
        self.networkRequester = [[NetworkRequester alloc] init];
        self.userDefaults = userDefaults;
    }
    return self;
}
- (void)fetchReadmeDataFromRequesterWithURLString:(NSString *)urlString completionHandler:(void (^) (BOOL needUpdate))completionHandler {
    GitURLSession *gitURLSession = [[GitURLSession alloc] init];
    [self.networkRequester makeNetworkRequest:[NSURL URLWithString:urlString] urlSession:gitURLSession completionHandler:^(NSDictionary * _Nonnull dict) {
        if (!dict) {
            return completionHandler(false);
        }
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
        NSString *repoName = [dict valueForKey:@"full_name"];
        NSString *readmeString = [NSString stringWithFormat:@"%@/readme",[dict valueForKey:@"url"]];
        if (!(repoName && readmeString)) {
            return completionHandler(false);
        }
        [userInfo setValue:repoName forKey:@"repositoryName"];
        [userInfo setValue:readmeString forKey:@"readmeURL"];
        [self.userDefaults setObject:userInfo forKey:urlString];
        NSMutableArray *arrayOfKeys = [[self.userDefaults valueForKey:@"keys"] mutableCopy];
        // if the url entered already exists
        if ([arrayOfKeys containsObject:urlString]) {
            return completionHandler(false);
        }
    
        if (arrayOfKeys) {
            [arrayOfKeys addObject:urlString];
        } else {
            arrayOfKeys = [[NSMutableArray alloc] initWithObjects:urlString, nil];
        }
        [self.userDefaults setObject:arrayOfKeys forKey:@"keys"];
        completionHandler(true);
    }];
}

- (void)fetchReadmeContentWithURLString:(NSString *)urlString completionHandler:(void (^) (NSString * readmeContent))completionHandler {
    GitURLSession *gitURLSession = [[GitURLSession alloc] init];
    [self.networkRequester makeNetworkRequest:[NSURL URLWithString:urlString] urlSession:gitURLSession completionHandler:^(NSDictionary * _Nonnull dict) {
        if (!dict) {
            return completionHandler(nil);
        }
        NSData *data = [[NSData alloc] initWithBase64EncodedString:[dict valueForKey:@"content"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSString *readmeContent = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        completionHandler(readmeContent);
    }];
}

- (void)fetchReadmeHTMLWithURLString:(NSString *)urlString completionHandler:(void (^) (NSString * readmeHTML))completionHandler {
    GitURLSession *gitURLSession = [[GitURLSession alloc] init];
    [self.networkRequester makeNetworkRequest:[NSURL URLWithString:urlString] urlSession:gitURLSession completionHandler:^(NSDictionary * _Nonnull dict) {
        if (!dict) {
            return completionHandler(nil);
        }
        NSString *htmlURL = [dict valueForKey:@"html_url"];
        completionHandler(htmlURL);
    }];
}
     
@end
