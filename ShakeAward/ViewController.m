//
//  ViewController.m
//  ShakeAward
//
//  Created by  on 12-11-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)userComein:(id)sender {
    NSString *memberId = [[NSUserDefaults standardUserDefaults] objectForKey:@"MEMBER_ID"];
    NSLog(@"memberId : %@",memberId);
    if (memberId >0) {
        MemberShakeAwardViewController *memberVC = [[MemberShakeAwardViewController alloc] initWithNibName:@"MemberShakeAwardViewController" bundle:nil];
        [self presentModalViewController:memberVC animated:YES];
    }else {
        UsersViewController *userVC = [[UsersViewController alloc] initWithNibName:@"UsersViewController" bundle:nil];
        [self presentModalViewController:userVC animated:YES];
    }
    
}

- (IBAction)managerComein:(id)sender {
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"USER_ID"];
    NSLog(@"userId : %@",userId);
    if (userId >0) {
        SettingAwardViewController *settingVC = [[SettingAwardViewController alloc] initWithNibName:@"SettingAwardViewController" bundle:nil];
        [self presentModalViewController:settingVC animated:YES];
    }else {
        LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self presentModalViewController:loginVC animated:YES];
    }
    
}

- (IBAction)help:(id)sender {
//    HelpViewController *helpVC = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
//    [self presentModalViewController:helpVC animated:YES];
    
//    ShakeAwardViewController *helpVC = [[ShakeAwardViewController alloc] initWithNibName:@"ShakeAwardViewController" bundle:nil];
//    [self presentModalViewController:helpVC animated:YES];
    
//    AddAwardGradeViewController *helpVC = [[AddAwardGradeViewController alloc] initWithNibName:@"AddAwardGradeViewController" bundle:nil];
//    [self presentModalViewController:helpVC animated:YES];
    
    MemberShakeAwardViewController *helpVC = [[MemberShakeAwardViewController alloc] initWithNibName:@"MemberShakeAwardViewController" bundle:nil];
    [self presentModalViewController:helpVC animated:YES];
}
@end
