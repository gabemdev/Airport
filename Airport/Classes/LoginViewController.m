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
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonBottomConstraint;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    [self.view layoutIfNeeded];

    [UIView animateWithDuration:1.5 animations:^{
        if (self.logoTopConstraint.constant == 150) {
            self.singUpButton.alpha = 1;
            self.logoImageView.alpha = 1;
            self.logoTopConstraint.constant = -193;
            self.buttonBottomConstraint.constant = -152;
        }
        [self.view layoutIfNeeded];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.singUpButton.layer.cornerRadius = 15;
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Twitter SDK
- (IBAction)onTwitterSignUp:(id)sender {
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (error) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            [self navigateToMainAppScreen];
        }
    }];
}

- (void)navigateToMainAppScreen {
    [self performSegueWithIdentifier:@"ShowMain" sender:self];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
