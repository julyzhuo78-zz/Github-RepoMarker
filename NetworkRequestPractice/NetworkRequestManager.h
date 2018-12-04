//
//  NetworkRequestManager.h
//  NetworkRequestPractice
//
//  Created by Ran Zhuo on 2018-11-30.
//  Copyright © 2018 Ran Zhuo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkRequestManager : NSObject
- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefaults;
- (void)fetchReadmeDataFromRequesterWithURLString:(NSString *)urlString completionHandler:(void (^) (BOOL needUpdate))completionHandler;
- (void)fetchReadmeContentWithURLString:(NSString *)urlString completionHandler:(void (^) (NSString *readmeContent))completionHandler;


@end

NS_ASSUME_NONNULL_END
