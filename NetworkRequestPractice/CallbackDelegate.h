//
//  CallbackDelegate.h
//  NetworkRequestPractice
//
//  Created by Ran Zhuo on 2018-12-03.
//  Copyright © 2018 Ran Zhuo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CallbackDelegate <NSObject>

- (void)didFinishedWithCurrentURL:(NSString *)urlString;

@end

NS_ASSUME_NONNULL_END
