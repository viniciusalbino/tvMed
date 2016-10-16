//
//  UIAlertView+Helper.m
//  Zattini
//
//  Created by Christopher John Morris on 8/7/15.
//  Copyright (c) 2015 Netshoes. All rights reserved.
//

#import "UIAlertView+Helper.h"
#import "UIAlertView+Block.h"
#import "NSString+Utils.h"

@implementation UIAlertView (Helper)

+ (void)showDefaultAlertWithMessage:(NSString *)message {
    if (![NSString isEmpty:message]) {
        [[[UIAlertView alloc] initWithTitle:@"Aviso" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

+ (void)showDefaultAlertWithTitle:(NSString *)title message:(NSString *)message {
    if (![NSString isEmpty:message] && ![NSString isEmpty:title]) {
        [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

+ (UIAlertView *)showConfirmationAlertWithTitle:(NSString *)title
                                message:(NSString *)message
                      cancelButtonTitle:(NSString *)cancelButtonTitle
                confirmationButtonTitle:(NSString *)confirmationButtonTitle
                             completion:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))completion {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:confirmationButtonTitle, nil];
    [alert showWithCompletion:completion];
    return alert;
}

+ (void) showPlainTextAlertWithTitle:(NSString *)title
                                message:(NSString *)message
                      cancelButtonTitle:(NSString *)cancelButtonTitle
                otherButtonTitles:(NSString *)otherButtonTitles
                             completion:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))completion {

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:cancelButtonTitle
                                              otherButtonTitles:otherButtonTitles, nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView showWithCompletion:completion];
}

@end
