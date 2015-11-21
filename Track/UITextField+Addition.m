//
//  UITextField+Addition.m
//  Location
//
//  Created by Wuffy on 11/12/15.
//  Copyright © 2015 Rover. All rights reserved.
//

#import "UITextField+Addition.h"

@implementation UITextField (Addition)

//输入框不显示纠错
- (UITextAutocorrectionType)autocorrectionType
{
    return UITextAutocorrectionTypeNo;
}

@end
