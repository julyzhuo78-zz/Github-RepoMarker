//
//  NetworkRequester.h
//  NetworkRequestPractice
//
//  Created by Ran Zhuo on 2018-11-29.
//  Copyright © 2018 Ran Zhuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLSessionProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface NetworkRequester : NSObject

@property (nonatomic, weak) id<URLSessionProtocol> urlSessionProtocol;
@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, strong) NSArray *tempArray;
@property (nonatomic, strong) NSURLSessionDataTask *task;

- (void)makeNetworkRequest:(NSURL *)url urlSession:(id<URLSessionProtocol>)urlSession completionHandler:(void (^)(NSDictionary *))completionHandler;

NS_ASSUME_NONNULL_END
@end
