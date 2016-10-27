//
//  ATPlaceholderTextView.h
//  ChatMessageTokeniser
//
//  Created by Srikanth on 10/27/16.
//  Copyright © 2016 Atlassian. All rights reserved.
//

#import <UIKit/UIKit.h>

/// This class enables TextViews to show placeholder text, and provides options to set the values in storyboard/interface builder

IB_DESIGNABLE
@interface ATPlaceholderTextView : UITextView

@property (nonatomic) IBInspectable NSString *placeholder;
@property (nonatomic) IBInspectable UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
