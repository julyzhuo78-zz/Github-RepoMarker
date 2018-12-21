//
//  NetworkRequesterReactiveObjC.m
//  NetworkRequestPractice
//
//  Created by Ran Zhuo on 2018-12-05.
//  Copyright © 2018 Ran Zhuo. All rights reserved.
//

#import "NetworkRequesterReactiveObjC.h"

@implementation NetworkRequesterReactiveObjC

- (RACSignal *)makeNetworkRequest: (NSURL *)url {
    RACSignal *getDataWithRequestSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                [subscriber sendNext:nil];
            } else {
                NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSDictionary *resultDict = [[NSDictionary alloc] init];
                if ([array isKindOfClass:[NSDictionary class]]) {
                    resultDict = (NSDictionary *)array;
                } else if ([array isKindOfClass:[NSArray class]]){
                    resultDict = [array objectAtIndex:0];
                }
                [subscriber sendNext:resultDict];
            }
        }];
        [task resume];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
        return getDataWithRequestSignal;
}


@end
