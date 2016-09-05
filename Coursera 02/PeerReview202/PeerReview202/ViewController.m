
//
//  ViewController.m
//  PeerReview202
//
//  Created by Ahmed Fathi on 6/28/16.
//  Copyright © 2016 company.com. All rights reserved.
//

/* 
 I have just created an instagram accout so I will access my profile picture instead of the feed
 and as a bonus I'm gonna access the username and print it on a label.
 It's the same prcess I just accessed another field in the JSON package.
 */

#import "ViewController.h"
#import "NXOAuth2.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *username;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.logoutBtn.enabled = NO;
    self.refreshBtn.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// MARK: BUTTONS TAPPED!!
- (IBAction)loginBtnTapped:(id)sender {
    [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:@"Instagram"];
    self.loginBtn.enabled = NO;
    self.logoutBtn.enabled = YES;
    self.refreshBtn.enabled = YES;
}

- (IBAction)logoutBtnTapped:(id)sender {
    NXOAuth2AccountStore *store = [NXOAuth2AccountStore sharedStore];
    NSArray *instagramAccounts = [store accountsWithAccountType:@"Instagram"];
    for (id account in instagramAccounts) {
        [store removeAccount:account];
    }
    self.loginBtn.enabled = YES;
    self.logoutBtn.enabled = NO;
    self.refreshBtn.enabled = NO;
}

- (IBAction)refreshBtnTapped:(id)sender {
    // return if no logged in accounts
    NSArray *instagramAccounts = [[NXOAuth2AccountStore sharedStore] accountsWithAccountType:@"Instagram"];
    if ([instagramAccounts count] == 0) {
        NSLog(@"Warning: %lu Instagram Accounts logged in\n", [instagramAccounts count]);
        return;
    }
    
    // Prepare account and accessToken
    NXOAuth2Account *account = instagramAccounts[0];
    NSString *accessToken = account.accessToken.accessToken;
    
    // Prepare the url
    NSString *URLStr = [@"https://api.instagram.com/v1/users/self/?access_token=" stringByAppendingString:accessToken];
    NSURL *URL = [NSURL URLWithString:URLStr];
    
    // Prepare url session
    NSURLSession *session = [NSURLSession sharedSession];
    
    // Resume session
    [[session dataTaskWithURL:URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // Check for errors
        // Network Error!
        if (error) {
            NSLog(@"Error: Data: Couldn't finish request: %@\n", error);
            return;
        }
        
        // HTTP Error!
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        if (httpResponse.statusCode < 200 || httpResponse.statusCode >= 300) {
            NSLog(@"Error: Data: Got Status Code %ld\n", httpResponse.statusCode);
            return;
        }
        
        // JSON Format Error! (Parsing Error)
        NSError *parserError;
        id package = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parserError];
        if (!package) {
            NSLog(@"Error: Data: Couldn't parse response %@\n", parserError);
            return;
        }
        @try {
            // Get the username
            NSString *username = package[@"data"][@"username"];
            
            // Get the imageURL
            NSString *imageURLStr = package[@"data"][@"profile_picture"];
            NSURL *imageURL = [NSURL URLWithString:imageURLStr];
            
            [[session dataTaskWithURL:imageURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                // Check for Errors
                // Network Error!
                if (error) {
                    NSLog(@"Error: Image: Couldn't finish request: %@\n", error);
                    return;
                }
                
                // HTTP Error!
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                if (httpResponse.statusCode < 200 || httpResponse.statusCode >= 300) {
                    NSLog(@"Error: Image: Got Status Code %ld", (long) httpResponse.statusCode);
                    return;
                }
                
                // Updating the UI only from the main queue
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.username.text = username;
                    self.imageView.image = [UIImage imageWithData:data];
                });
                
            }] resume];
        }
        @catch (NSException *exception) {
            NSLog(@"Try-Catch Error: Image: %@\n", exception);
        }
    }] resume];
}

@end
