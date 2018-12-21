//
//  NetworkRequestManagerReactiveObjC.m
//  NetworkRequestPractice
//
//  Created by Ran Zhuo on 2018-12-05.
//  Copyright © 2018 Ran Zhuo. All rights reserved.
//

#import "NetworkRequestManagerReactiveObjC.h"
#import "NetworkRequesterReactiveObjC.h"

@interface NetworkRequestManagerReactiveObjC()
@property (nonatomic, strong) NetworkRequesterReactiveObjC *networkRequester;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@end



@implementation NetworkRequestManagerReactiveObjC
- (instancetype)init:(NSUserDefaults *)userDefaults
{
    self = [super init];
    if (self) {
        self.networkRequester = [[NetworkRequesterReactiveObjC alloc] init];
        self.userDefaults = userDefaults;
    }
    return self;
}

- (RACSignal *)fetchReadMeDataFromNetworkRequest:(NSString *)urlString {
    RACSignal *isValid = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        if (!urlString) {
            [subscriber sendNext:[NSNumber numberWithBool:NO]];
        } else {
            NSURL *resultURL = [NSURL URLWithString:urlString];
            [[self.networkRequester makeNetworkRequest:resultURL] subscribeNext:^(NSDictionary *  _Nullable dict) {
                NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
                NSString *repoName = [dict valueForKey:@"full_name"];
                NSString *readmeString = [NSString stringWithFormat:@"%@/readme",[dict valueForKey:@"url"]];
                if (!(repoName && readmeString)) {
                    [subscriber sendNext:[NSNumber numberWithBool:NO]];
                    return;
                }
                [userInfo setValue:repoName forKey:@"repositoryName"];
                [userInfo setValue:readmeString forKey:@"readmeURL"];
                [self.userDefaults setObject:userInfo forKey:urlString];
                NSMutableArray *arrayOfKeys = [[self.userDefaults valueForKey:@"objc_keys"] mutableCopy];
                // if the url entered already exists
                if ([arrayOfKeys containsObject:urlString]) {
                    [subscriber sendNext:[NSNumber numberWithBool:NO]];
                    return;
                }
                
                if (arrayOfKeys) {
                    [arrayOfKeys addObject:urlString];
                } else {
                    arrayOfKeys = [[NSMutableArray alloc] initWithObjects:urlString, nil];
                }
                [self.userDefaults setObject:arrayOfKeys forKey:@"objc_keys"];
                return [subscriber sendNext:[NSNumber numberWithBool:YES]];
            }];
        }
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"dispose");
        }];
    }];
    return isValid;
}

- (RACSignal *)fetchReadmeHTML:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    RACSignal *htmlSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [[self.networkRequester makeNetworkRequest:url] subscribeNext:^(NSDictionary* _Nullable dict) {
            if (!dict) {
                [subscriber sendNext:nil];
            }
            NSString *htmlURL = [dict valueForKey:@"html_url"];
            [subscriber sendNext:htmlURL];
        }];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"dispose");
        }];
    }];
    return htmlSignal;
}


@end
