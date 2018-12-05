//
//  NetworkDataStore.h
//  NetworkRequestPractice
//
//  Created by Ran Zhuo on 2018-12-03.
//  Copyright © 2018 Ran Zhuo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkDataStore : NSObject
@property (strong, nonatomic) NSMutableArray *arrayOfURLs;
@property (strong, nonatomic) NSMutableArray *arrayOfRepoNames;
@property (strong, nonatomic) NSString *currentRepoName;

- (void)refreshRepositoryNames;
- (void)addURL:(NSString *)urlString;
- (NSString *)getReadMeURL;

@end

NS_ASSUME_NONNULL_END
