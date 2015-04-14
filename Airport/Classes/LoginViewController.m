//
//  LoginViewController.m
//  Airport
//
//  Created by Rockstar. on 4/13/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "LoginViewController.h"
#import <SimpleAuth/SimpleAuth.h>
#import "User.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *singUpButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.singUpButton.layer.cornerRadius = 15;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Twitter SDK
- (IBAction)onTwitterSignUp:(id)sender {
    SimpleAuth.configuration[@"twitter"] = @{
                                             @"consumer_key" : @"DAUtzCzGtSJLjYep5hJWn2uVl",
                                             @"consumer_secret" : @"psvDan1X1W2cwAoREgwhav0UAt0lacNb9Z95UjxHudKUjJrX4W"
                                             };
    [SimpleAuth authorize:@"twitter" completion:^(id responseObject, NSError *error) {
        NSLog(@"%@", responseObject);
        if (error) {
            UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"Alert" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertview performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];

        } else {
            [self.navigationController popToRootViewControllerAnimated:YES];
            [[User sharedInstance] loginWithDictionary:responseObject];

        }
    }];
}

@end
