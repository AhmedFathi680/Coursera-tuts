//
//  ViewController.m
//  PeerReview402
//
//  Created by Ahmed Fathi on 7/22/16.
//  Copyright © 2016 company.com. All rights reserved.
//

#import "ViewController.h"
@import AudioToolbox;
@import AVFoundation.AVAudioPlayer;

@interface ViewController ()


@property (weak, nonatomic) IBOutlet UIButton *drumOneBtn;
@property (weak, nonatomic) IBOutlet UIButton *drumTwoBtn;
@property (weak, nonatomic) IBOutlet UIButton *drumThreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *drumFourBtn;

@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;



@property (assign, nonatomic) SystemSoundID soundOne;
@property (assign, nonatomic) SystemSoundID soundTwo;
@property (assign, nonatomic) SystemSoundID soundThree;
@property (assign, nonatomic) SystemSoundID soundFour;
@property (strong, nonatomic) AVAudioPlayer *player; //strong


@property (assign, nonatomic) BOOL soundOneGood;
@property (assign, nonatomic) BOOL soundTwoGood;
@property (assign, nonatomic) BOOL soundThreeGood;
@property (assign, nonatomic) BOOL soundFourGood;
@property (assign, nonatomic) BOOL playerGood;

@end




@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // SOUND 1
    
    // Load the sound, create the URL
    NSString *soundOnePath = [[NSBundle mainBundle] pathForResource:@"Button1" ofType:@"mp3"];
    NSURL *soundOneURL = [NSURL URLWithString:soundOnePath];
    
    // Check status
    OSStatus statusReport = AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundOneURL, &_soundOne);
    
    if (statusReport == kAudioServicesNoError) {
        self.soundOneGood = YES;
    } else {
        self.soundOneGood = NO;
        
        // create an alert in case of failure
        [self raiseAlertWithTitle:@"Couldn't load Sound One" andMessage:@"Sound One Problem"];
    }
    
    
    
    
    // SOUND 2
    
    // Load the sound, create the url
    NSString *soundTwoPath = [[NSBundle mainBundle] pathForResource:@"Button2" ofType:@"mp3"];
    NSURL *soundTwoURL = [NSURL URLWithString:soundTwoPath];
    
    statusReport = AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundTwoURL, &_soundTwo);
    
    if (statusReport == kAudioServicesNoError) {
        self.soundTwoGood = YES;
    } else {
        self.soundTwoGood = NO;
        
        // create alert in case of failure
        [self raiseAlertWithTitle:@"Couldn't load Sound Two" andMessage:@"Sound Two Problem"];
    }

    
    
    
    
    // SOUND 3
    
    // Load the sound, create the url
    NSString *soundThreePath = [[NSBundle mainBundle] pathForResource:@"Button3" ofType:@"mp3"];
    NSURL *soundThreeURL = [NSURL URLWithString:soundThreePath];
    
    statusReport = AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundThreeURL, &_soundThree);
    
    if (statusReport == kAudioServicesNoError) {
        self.soundThreeGood = YES;
    } else {
        self.soundThreeGood = NO;
        
        // create alert in case of failure
        [self raiseAlertWithTitle:@"Couldn't load Sound Three" andMessage:@"Sound Three Problem"];
    }

    
    
    
    // SOUND 4
    
    // Load the sound, create the url
    NSString *soundFourPath = [[NSBundle mainBundle] pathForResource:@"Button4" ofType:@"mp3"];
    NSURL *soundFourURL = [NSURL URLWithString:soundFourPath];
    
    statusReport = AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundFourURL, &_soundFour);
    
    if (statusReport == kAudioServicesNoError) {
        self.soundFourGood = YES;
    } else {
        self.soundFourGood = NO;
        
        // create alert in case of failure
        [self raiseAlertWithTitle:@"Couldn't load Sound Four" andMessage:@"Sound Four Problem"];
    }
    
    // PLAYER
    
    
    NSString *playerPath = [[NSBundle mainBundle] pathForResource:@"ThePinkPanther" ofType:@"mp3"];
    NSURL *playerURL = [NSURL URLWithString:playerPath];
    
    NSError *err;
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:playerURL error:&err];
    
    if (self.player) {
        self.playerGood = YES;
    } else {
        self.playerGood = NO;
        [self raiseAlertWithTitle:@"Couldn't Load mp3" andMessage:[err localizedDescription]];
    }
}




#pragma mark - dealloc

- (void) dealloc {
    if (self.soundOneGood) {
        AudioServicesDisposeSystemSoundID(self.soundOne);
    }
    
    if (self.soundTwoGood) {
        AudioServicesDisposeSystemSoundID(self.soundTwo);
    }
    
    if (self.soundThreeGood) {
        AudioServicesDisposeSystemSoundID(self.soundThree);
    }
    
    if (self.soundFourGood) {
        AudioServicesDisposeSystemSoundID(self.soundFour);
    }
    
}



#pragma mark - Helper Functions


- (void) raiseAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}



#pragma mark - Actions


- (IBAction)drumOne:(id)sender {
    
    if (self.soundOneGood) {
        AudioServicesPlaySystemSound(_soundOne);
    }
    
}



- (IBAction)drumTwo:(id)sender {
    
    if (self.soundTwoGood) {
        AudioServicesPlaySystemSound(_soundTwo);
    }
    
}


- (IBAction)drumThree:(id)sender {
    
    if (self.soundThreeGood) {
        AudioServicesPlaySystemSound(_soundThree);
    }

}



- (IBAction)drumFour:(id)sender {
    
    if (self.soundFourGood) {
        AudioServicesPlaySystemSound(_soundFour);
    }

}



- (IBAction)play:(id)sender {
   
    if (self.playerGood) {
        [self.player play];
    }
    
}



- (IBAction)stop:(id)sender {
    
    if (self.playerGood) {
        [self.player stop];
    }
    
}



@end



























