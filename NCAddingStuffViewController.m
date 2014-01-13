//
//  NCAddingStuffViewController.m
//  InMinder
//
//  Created by nevercry on 1/12/14.
//  Copyright (c) 2014 nevercry. All rights reserved.
//

#import "NCAddingStuffViewController.h"

@interface NCAddingStuffViewController ()<UITextViewDelegate>


@end

@implementation NCAddingStuffViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.textView.delegate = self;
    [self.textView becomeFirstResponder];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text stringByReplacingOccurrencesOfString:@" " withString:@""].length != 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}


@end
