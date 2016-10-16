//
//  UITextField+Toolbar.h
//  Zattini
//
//  Created by Christopher John Morris on 7/22/15.
//  Copyright (c) 2015 Concrete Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KeyboardToolbar;

@protocol KeyboardToolbarDelegate;

@interface UITextField (Toolbar)

- (void) addDefaultToolbar;
- (void) addFocusChangingToolBarWithDelegate:(id<KeyboardToolbarDelegate>)delegate;

@end
