//
//  URLConverter.m
//  NetworkRequestPractice
//
//  Created by Ran Zhuo on 2018-12-03.
//  Copyright © 2018 Ran Zhuo. All rights reserved.
//

#import "URLConverter.h"

@implementation URLConverter
- (NSString *)convertToGitHubApiUrl:(NSString *)userURL {
   // https://github.com/vsouza/awesome-ios -> https://api.github.com/repos/vsouza/awesome-ios
    NSURL *url = [NSURL URLWithString:userURL];
    if (![url.host isEqualToString:@"github.com"]) {
        return nil;
    }
    
    NSArray *components = [userURL componentsSeparatedByString:@"/"];
    if (components.count < 5) {
        return nil;
    }
    
    NSString *userName = [components objectAtIndex:components.count - 2];
    NSString *repoName = [components objectAtIndex:components.count - 1];
    return [NSString stringWithFormat:@"https://api.github.com/repos/%@/%@", userName, repoName];
}

@end
