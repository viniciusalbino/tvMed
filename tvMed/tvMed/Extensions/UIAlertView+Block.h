//
//  UIAlertView+Block.h
//  Zattini
//
//  Created by Christopher John Morris on 7/27/15.
//  Copyright (c) 2015 Concrete Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Block)

- (void)showWithCompletion:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))completion;

@end