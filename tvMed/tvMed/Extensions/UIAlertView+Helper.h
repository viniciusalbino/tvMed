//
//  UIAlertView+Helper.h
//  Zattini
//
//  Created by Christopher John Morris on 8/7/15.
//  Copyright (c) 2015 Netshoes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Helper)

+ (void)showDefaultAlertWithMessage:(NSString *)message;

+ (void)showDefaultAlertWithTitle:(NSString *)title
                          message:(NSString *)message;

+ (UIAlertView *)showConfirmationAlertWithTitle:(NSString *)title
                                        message:(NSString *)message
                              cancelButtonTitle:(NSString *)cancelButtonTitle
                        confirmationButtonTitle:(NSString *)confirmationButtonTitle
                                     completion:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))completion;

+ (void) showPlainTextAlertWithTitle:(NSString *)title
                             message:(NSString *)message
                   cancelButtonTitle:(NSString *)cancelButtonTitle
                   otherButtonTitles:(NSString *)confirmationButtonTitle
                          completion:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))completion;

@end
