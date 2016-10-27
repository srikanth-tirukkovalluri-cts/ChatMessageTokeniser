//
//  ATChatViewController.m
//  ChatMessageTokeniser
//
//  Created by Srikanth on 10/25/16.
//  Copyright © 2016 Atlassian. All rights reserved.
//

#import "ATChatViewController.h"
#import "ATDeterminePageTitle.h"
#import "ATPlaceholderTextView.h"
#import "ATChatMessage.h"
#import "ATChatViewModel.h"

@interface ATChatViewController () <ATChatViewModelDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatMessageInputFieldContainerHeightConstraint;

@property (weak, nonatomic) IBOutlet ATPlaceholderTextView *jsonOutputTextView;
@property (weak, nonatomic) IBOutlet ATPlaceholderTextView *chatMessageInputTextView;

@property (strong, nonatomic) ATChatMessage *chatMessage;
@property (strong, nonatomic) ATChatViewModel *chatViewModel;

@end

@implementation ATChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.chatViewModel = [[ATChatViewModel alloc] initWithModel:nil];
    self.chatViewModel.chatViewModelDelegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextview Delegate Methods
- (void)textViewDidChange:(UITextView *)textView {
    
    CGFloat minimumWidth = textView.frame.size.width;
    CGSize size = [self.chatViewModel findHeightForText:textView.text havingWidth:textView.frame.size.width andFont:textView.font];
    
    // Make sure the minimum width is always maintained
    if (size.width < minimumWidth) {
        size.width = minimumWidth;
    }
    
    self.chatMessageInputFieldContainerHeightConstraint.constant = size.height + 30;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Keyboard Movements
- (void)keyboardWillShow:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;

    self.bottomConstraint.constant = keyboardSize.height;
    
    NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification {
    NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.bottomConstraint.constant = 0;
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - ATChatViewModelDelegate Methods
- (void)refreshJSONOutput {
    self.jsonOutputTextView.text = [self.chatMessage prettyPrintedJSONString];
}

#pragma mark - Action Methods
- (IBAction)tokeniseMessage:(id)sender {
    NSString *message = self.chatMessageInputTextView.text;
    
    // Create model object, and update view model with the new model
    self.chatMessage = [[ATChatMessage alloc] initWithMessage:message];
    self.chatViewModel.chatMessage = self.chatMessage;
    self.jsonOutputTextView.text = [self.chatMessage prettyPrintedJSONString];
    
    // Clear input and also resize the textview
    self.chatMessageInputTextView.text = @"";
    [self textViewDidChange:self.chatMessageInputTextView];
    
    // Load the page titles lazily
    [self.chatViewModel lazilyDeterminePageTitles];
}

- (IBAction)clearOutput:(id)sender {
    self.jsonOutputTextView.text = @"";
}

@end
