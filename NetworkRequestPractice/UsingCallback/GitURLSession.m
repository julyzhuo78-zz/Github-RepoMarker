//
//  GitURLSession.m
//  NetworkRequestPractice
//
//  Created by Ran Zhuo on 2018-11-29.
//  Copyright © 2018 Ran Zhuo. All rights reserved.
//

#import "GitURLSession.h"

@implementation GitURLSession

- (NSURLSessionTask *)dataTaskWithRequest:(NSURLRequest *)urlRequest completionHandler:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler {
    return [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:completionHandler];
    
}


@end
