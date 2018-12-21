//
//  NetworkRequestManagerReactiveObjC.h
//  NetworkRequestPractice
//
//  Created by Ran Zhuo on 2018-12-05.
//  Copyright © 2018 Ran Zhuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"

NS_ASSUME_NONNULL_BEGIN

@interface NetworkRequestManagerReactiveObjC : NSObject
- (instancetype)init:(NSUserDefaults *)userDefaults;
- (RACSignal *)fetchReadMeDataFromNetworkRequest:(NSString *)urlString;
- (RACSignal *)fetchReadmeHTML:(NSString *)urlString;
@end

NS_ASSUME_NONNULL_END
