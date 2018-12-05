//
//  NetworkDataStore.m
//  NetworkRequestPractice
//
//  Created by Ran Zhuo on 2018-12-03.
//  Copyright © 2018 Ran Zhuo. All rights reserved.
//

#import "NetworkDataStore.h"
@interface NetworkDataStore()

@property (strong, nonatomic) NSUserDefaults *userDefaults;

@end


@implementation NetworkDataStore

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userDefaults = [NSUserDefaults standardUserDefaults];
        self.arrayOfRepoNames = [[NSMutableArray alloc] init];
        self.arrayOfURLs = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)refreshRepositoryNames { //will only be called once when initializing the store
    [self.arrayOfRepoNames removeAllObjects];
    NSMutableArray *arrayOfKeys = [[self.userDefaults valueForKey:@"keys"] mutableCopy];
    if (arrayOfKeys) {
        self.arrayOfURLs = arrayOfKeys;
    }
    for (NSString *key in self.arrayOfURLs) {
        NSDictionary *currentDict = [self.userDefaults valueForKey:key];
        [self.arrayOfRepoNames addObject:[currentDict valueForKey:@"repositoryName"]];
    }
}

- (void)addURL:(NSString *)urlString {
    //add new url
    [self.arrayOfURLs addObject:urlString];
    
    //add new repository name
    [self.arrayOfRepoNames addObject:[[self.userDefaults valueForKey:urlString] valueForKey:@"repositoryName"]];
}

- (NSString *)getReadMeURL {
    if (!self.currentRepoName) {
        return nil;
    }
    
    NSInteger pos = [self.arrayOfRepoNames indexOfObject:self.currentRepoName];
    NSDictionary *currentDict = [self.userDefaults objectForKey:[self.arrayOfURLs objectAtIndex:pos]];
    return [currentDict valueForKey:@"readmeURL"];
}

@end
