//
//  MyAlertView.m
//  Track
//
//  Created by Wuffy on 11/19/15.
//  Copyright © 2015 Wuffy. All rights reserved.
//

#import "MyAlertView.h"

@implementation MyAlertView

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    if (self.handler) self.handler(buttonIndex);
    if (self.alertViewStyle != UIAlertViewStyleDefault && buttonIndex != 0) {
        return;
    }
    [super dismissWithClickedButtonIndex:buttonIndex animated:animated];
}

@end
