//
//  NetworkRequesterReactiveObjC.h
//  NetworkRequestPractice
//
//  Created by Ran Zhuo on 2018-12-05.
//  Copyright © 2018 Ran Zhuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjc/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkRequesterReactiveObjC : NSObject

- (RACSignal *)makeNetworkRequest: (NSURL *)url;

@end

NS_ASSUME_NONNULL_END
