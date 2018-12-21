//
//  AddURLObjCViewController.h
//  NetworkRequestPractice
//
//  Created by Ran Zhuo on 2018-12-05.
//  Copyright © 2018 Ran Zhuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReactiveObjC.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddURLObjCViewController : UIViewController
@property (strong, nonatomic) RACSubject *didFinishSubject;
@end

NS_ASSUME_NONNULL_END
