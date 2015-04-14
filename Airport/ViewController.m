//
//  ViewController.m
//  Airport
//
//  Created by Rockstar. on 4/13/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "ViewController.h"
#import "User.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkUser];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - Actions
- (IBAction)onSettingsButtonTapped:(id)sender {

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

@end
