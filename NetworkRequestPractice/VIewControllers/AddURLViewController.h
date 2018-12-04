//
//  AddURLViewController.h
//  NetworkRequestPractice
//
//  Created by Ran Zhuo on 2018-11-30.
//  Copyright © 2018 Ran Zhuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallbackDelegate.h"
#import "NetworkDataStore.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddURLViewController : UIViewController
@property (weak, nonatomic) id<CallbackDelegate> callbackDelegate;
@end

NS_ASSUME_NONNULL_END
