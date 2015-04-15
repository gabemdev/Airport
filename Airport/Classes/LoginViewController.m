//
//  LoginViewController.m
//  Airport
//
//  Created by Rockstar. on 4/13/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "LoginViewController.h"
#import <TwitterKit/TwitterKit.h>


@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *singUpButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.singUpButton.layer.cornerRadius = 15;


    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Twitter SDK
- (IBAction)onTwitterSignUp:(id)sender {
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
            [self navigateToMainAppScreen];
        }else {

        }
    }];
}

- (void)navigateToMainAppScreen {
    [self performSegueWithIdentifier:@"ShowMain" sender:self];
}

@end
