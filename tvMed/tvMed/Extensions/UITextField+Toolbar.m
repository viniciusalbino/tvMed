//
//  UITextField+Toolbar.m
//  Zattini
//
//  Created by Christopher John Morris on 7/22/15.
//  Copyright (c) 2015 Concrete Solutions. All rights reserved.
//

#import "UITextField+Toolbar.h"
#import "tvMed-Swift.h"

@implementation UITextField (Toolbar)

- (void) addDefaultToolbar {
    self.inputAccessoryView = [[KeyboardToolbar alloc] initWithTextField:self shouldShowFocusButtons:NO];
}

- (void) addFocusChangingToolBarWithDelegate:(id<KeyboardToolbarDelegate>)delegate {
    self.inputAccessoryView = [[KeyboardToolbar alloc] initWithTextField:self delegate:delegate shouldShowFocusButtons:YES];
}

@end
