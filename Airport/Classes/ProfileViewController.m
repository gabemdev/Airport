//
//  ProfileViewController.m
//  Airport
//
//  Created by Rockstar. on 4/14/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "ProfileViewController.h"
#import "User.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *profileName;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    [self getTwitterProfile];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self checkUser];
}

#pragma mark - Actions

- (IBAction)onLogoutButtonTapped:(id)sender {
    [self signOut:nil];
}

- (void)signOut:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sign Out" message:@"Are you sure you want to sign out of Airport?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sign Out", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex !=1) {
        return;
    }
    [[User sharedInstance] logout];
    [self checkUser];
}

#pragma mark - User
- (void)checkUser {
    if ([[User sharedInstance] isLoggedIn]) {
        NSLog(@"CPAppDelegate.application:didFinishLaunchingWithOptions: user is logged in");
    }
    else {
        NSLog(@"AppDelegate User is not logged in");
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
}

#pragma mark - NSObject

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Social

- (void)getTwitterProfile {
    User *user = [User sharedInstance];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *profile = user.profileImageUrl;
        NSURL *profileURL = [NSURL URLWithString:profile];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *profileData = [NSData dataWithContentsOfURL:profileURL];
            if (profileData) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.profileImage.image = [UIImage imageWithData:profileData];
                });
            }
        });
    });
    self.profileName.text = user.screenName;
    self.bioLabel.text = user.status;
    [self.navigationItem setTitle:[user name]];
}

@end
