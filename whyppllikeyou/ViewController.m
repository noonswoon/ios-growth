//
//  ViewController.m
//  whyppllikeyou
//
//  Created by KHUN NINE on 7/16/15.
//  Copyright (c) 2015 KHUN NINE. All rights reserved.
//

#import "ViewController.h"

#import <Parse/Parse.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

#import <Google/Analytics.h>

#import <AdBuddiz/AdBuddiz.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {

    if ([FBSDKAccessToken currentAccessToken] != nil) {
        
        [self userLoggedIn];
    }
    else {
        

    }

    [self setLoginButton];
    
    [self testParse];
}

- (void) testParse {
    
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"foo"] = @" Khun9eiei";
    [testObject saveInBackground];
}

- (void) viewWillAppear:(BOOL)animated {
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value: @"eiei"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void) userLoggedIn {
    
    [self setShareButton];
}

- (void) setLoginButton {
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    
    loginButton.center = self.view.center;
    loginButton.delegate = self;
    
    [self.view addSubview:loginButton];
}

- (void)  loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    
    [self userLoggedIn];
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {

    [AdBuddiz showAd];
}

- (void) setShareButton {
    
    
    
    NSString *contentURL         = @"https://goo.gl/pszrQA";
    NSString *contentImageURL    = @"http://files.parsetfss.com/6a10db95-2e8a-45f0-b063-f8d3157c87e1/tfss-99e636a8-920f-4294-989f-43c49fb30ee7-UserGeneratedResult.png";
    NSString *contentTitle       = @"เหตุผลที่ทำไมคนถึงชอบคุณ";
    NSString *contentDescription = @"คุณเคยคิดหรือไม่ ว่าทำไมคนถึงชอบคุณ อะไรเป็นสาเหตุกันแน่นะ? ดาวน์โหลด 'ชอบฉันไม' สิ ด้วยอัลกอรึทึมขั้นสูงของเรา ที่วิเคราะห์จากการกดไลค์และการตอบคำถามของคุณ จะทำให้คุณรู้คำตอบที่น่าทึ่ง!";
    
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    

    
    content.imageURL           = [[NSURL alloc] initWithString: contentImageURL];
    content.contentURL         = [[NSURL alloc] initWithString: contentURL];
    content.contentTitle       = contentTitle;
    content.contentDescription = contentDescription;


//    FBSDKShareDialog *shareDialog = [[FBSDKShareDialog alloc] init];
//    shareDialog.shareContent = content;
//    [shareDialog show];

    
//    [FBSDKShareDialog showFromViewController:self withContent:content delegate:self];

    
    FBSDKShareButton *button = [[FBSDKShareButton alloc] init];
    button.frame = CGRectMake(0, 0, self.view.frame.size.width/2, 88);
    button.center = CGPointMake(self.view.center.x, self.view.center.y * 1.5);
    button.shareContent = content;
    
    [self.view addSubview: button];
}


@end
