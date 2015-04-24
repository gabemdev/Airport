//
//  SettingsViewController.m
//  Airport
//
//  Created by Rockstar. on 4/22/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "SettingsViewController.h"
#import <TwitterKit/TwitterKit.h>
#import "MessageUI/MFMailComposeViewController.h"
#import "User.h"
#import "LoginViewController.h"

@interface SettingsViewController ()<UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property User *user;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setProfile];
    self.title = @"Settings";
    // Do any additional setup after loading the view.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    else if (section == 1) {
        return 1;
    }
    else if (section == 2) {
        return 3;
    }
    else if (section == 3) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }

    [self configureCell:cell forRowAtIndexPath:indexPath];

    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
    self.profileImageView.layer.masksToBounds = YES;

    [User getUserInformationWithCompletion:^(User *userInfo) {
        self.user = userInfo;

        self.nameLabel.text = self.user.name;
        self.bioLabel.text = self.user.bio;

        dispatch_async(dispatch_get_main_queue(), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.user.imageURL]];
            self.profileImageView.image = [UIImage imageWithData:data];
        });


        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"Following";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.user.followingCount];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"Followers";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.user.followerCount];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }

        }
        else if (indexPath.section == 1) {
            cell.textLabel.text = @"Settings";
            cell.detailTextLabel.text = nil;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"Share Airport";
                cell.detailTextLabel.text = nil;
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"Send Feedback";
                cell.detailTextLabel.text = nil;
            } else if (indexPath.row == 2) {
                cell.textLabel.text = @"Privacy Policy";
                cell.detailTextLabel.text = nil;
            }
        }
        else if (indexPath.section == 3) {
            cell.textLabel.text = @"Logout";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor redColor];
            cell.detailTextLabel.text = nil;
        }
    }];

}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }

    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }

    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return;
    }
    else if (indexPath.section == 1) {
        [self performSegueWithIdentifier:@"ShowSettings" sender:self];
    }
    else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            //Twitter/Facebook
            NSURL *url = [NSURL URLWithString:@"http://gabemdev.com/airport"];
            NSString *shareString = [NSString stringWithFormat:@"Check out Airport!"];
            NSArray *shareItems = @[shareString, url];
            UIActivityViewController *share = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
            share.excludedActivityTypes = @[UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeAddToReadingList, UIActivityTypePostToTencentWeibo, UIActivityTypePrint, UIActivityTypePostToWeibo, UIActivityTypePostToVimeo, UIActivityTypePrint];
            [self presentViewController:share animated:YES completion:nil];
        }
        else if (indexPath.row == 1) {
            //Email
            MFMailComposeViewController * composer = [[MFMailComposeViewController alloc]init];
            [composer setMailComposeDelegate:self];

            if ([MFMailComposeViewController canSendMail]) {
                NSString *device = [[UIDevice currentDevice] model];
                NSString *systemInfo = [NSString stringWithFormat:@"%@ %@", [[UIDevice currentDevice] systemName], [[UIDevice currentDevice] systemVersion]];
                NSString *appInfo = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                NSString *message = [NSString stringWithFormat:@"<br><br><hr>Device: %@ <br> System: %@ <br> App Version: %@", device, systemInfo, appInfo];
                [composer setToRecipients:[NSArray arrayWithObjects:@"help@airport.io", nil]];
                [composer setSubject:@"Airport App - Feedback"];
                [composer setMessageBody:message isHTML:YES];
                [composer setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
                [self presentViewController:composer animated:YES completion:nil];
            }
        }
        else if (indexPath.row == 2) {
            //web view
        }
    }
    else if (indexPath.section == 3) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"Are you sure you want to logout?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *logout = [UIAlertAction actionWithTitle:@"Logout" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[Twitter sharedInstance] logOut];
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LoginViewController"];
            [self presentViewController:vc animated:YES completion:nil];
        }];
        [alert addAction:cancel];
        [alert addAction:logout];
        [self presentViewController:alert animated:YES completion:nil];
    }

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - MailComposer
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{

    [self dismissViewControllerAnimated:YES completion:nil];

    if (result == MFMailComposeResultFailed) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"Unable to send email" delegate:self
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }

}

#pragma mark - Action & Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowSettings"]) {
        
    }
}

@end
