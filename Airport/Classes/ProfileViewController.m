//
//  ProfileViewController.m
//  Airport
//
//  Created by Rockstar. on 4/14/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "ProfileViewController.h"
#import <TwitterKit/TwitterKit.h>
#import "LoginViewController.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *profileName;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UILabel *followerLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"arches"]]];
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    self.profileImage.layer.masksToBounds = YES;
    self.logoutButton.layer.cornerRadius = 15;
    [self getLargeProfile];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - Actions

- (IBAction)onLogoutButtonTapped:(id)sender {
    [[Twitter sharedInstance] logOut];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)setProfile {
    [[[Twitter sharedInstance] APIClient] loadUserWithID:[[Twitter sharedInstance] session].userID completion:^(TWTRUser *user, NSError *error) {
        if (user) {
            NSString *image = [NSString stringWithFormat:@"%@", user.profileImageLargeURL];
            NSURL *url = [NSURL URLWithString:image];
            NSData *data = [NSData dataWithContentsOfURL:url];
            self.profileImage.image = [UIImage imageWithData:data];
            [self.navigationItem setTitle:[user name]];
            self.profileName.text = user.name;
            self.bioLabel.text = user.description;
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancel];

            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

- (void)getLargeProfile {
    [[[Twitter sharedInstance] APIClient] loadUserWithID:[[Twitter sharedInstance] session].userID completion:^(TWTRUser *user, NSError *error) {
        if (user) {
            NSString *userString = @"https://api.twitter.com/1.1/users/show.json";
            NSDictionary *params = @{@"screen_name" : [user screenName]};
            NSError *error;
            NSURLRequest *request = [[[Twitter sharedInstance] APIClient] URLRequestWithMethod:@"GET"
                                                                                           URL:userString
                                                                                    parameters:params
                                                                                         error:&error];
            if (request) {
                [[[Twitter sharedInstance] APIClient] sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                    if (data) {
                        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            // Profile Image
                            NSString *image = [NSString stringWithFormat:@"%@", json[@"profile_image_url"]];
                            image = [image stringByReplacingOccurrencesOfString:@"_normal" withString:@"_reasonably_small"];
                            NSURL *url = [NSURL URLWithString:image];
                            NSData *data = [NSData dataWithContentsOfURL:url];

                            // Profile Info
                            NSString *name = [NSString stringWithFormat:@"%@", json[@"name"]];
                            NSString *bio = [NSString stringWithFormat:@"%@", json[@"description"]];

                            //Profile links
                            NSDictionary *urls = json[@"entities"][@"url"];
                            NSArray *urlArray = urls[@"urls"];
                            NSString *expanded_url = [NSString stringWithFormat:@"%@", urlArray[0][@"expanded_url"]];

                            //Follower info
                            NSString *followingCount = [NSString stringWithFormat:@"%@", json[@"friends_count"]];
                            NSString *followerCount = [NSString stringWithFormat:@"%@", json[@"followers_count"]];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                self.profileImage.image = [UIImage imageWithData:data];
                                self.profileName.text = name;
                                self.bioLabel.text = bio;
                                self.followingLabel.text = followingCount;
                                self.followerLabel.text = followerCount;
                                 NSLog(@"%@", expanded_url);
                
                                [self saveUserName:name withBio:bio andImage:image];
                            });
                            
                        });

                    } else {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error!" message:connectionError.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                        [alert addAction:cancel];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                }];
            }
        }
    }];
}



- (void)saveUserName:(NSString *)user withBio:(NSString *)bio andImage:(NSString *)imageUrl {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:user forKey:@"userName"];
    [defaults setObject:bio forKey:@"bio"];
    [defaults setObject:imageUrl forKey:@"image"];
    [defaults synchronize];
}


- (IBAction)onDismissButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
