//
//  SoundsRecordViewController.m
//  TheMusicCamera
//
//  Created by song on 13-12-14.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import "SoundsRecordViewController.h"
#import "DataManager.h"
#import "DataManager.h"
#import "Music.h"

@interface SoundsRecordViewController ()

@end

@implementation SoundsRecordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) getTodayTime
{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    dateString = [dateFormat stringFromDate:today];
    
    NSLog(@"date: %@", dateString);

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    dataManager = [DataManager sharedManager];

    [self getTodayTime];
    
    self.hidesBottomBarWhenPushed = YES;
    _isRecording = NO;
    _isPlaying = NO;
    
    musicNameLabel.text = dateString;
    
    [self navgationImage:@"header_recording"];
    
    UIButton *btn = [self navgationButton:@"button_back" andFrame:CGRectMake(10, 7, 46, 31)];
    [btn addTarget:self action:@selector(backBtuuon) forControlEvents:UIControlEventTouchUpInside];
    
    saveBtn = [self navgationButton:@"button_save" andFrame:CGRectMake(260, 10, 52, 28)];
    [saveBtn addTarget:self action:@selector(saveBtuuon) forControlEvents:UIControlEventTouchUpInside];
    saveBtn.hidden = YES;
    
//////////////////////////////////////////////////////////////////////////////////
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    if(session == nil)
        NSLog(@"Error creating session: %@", [sessionError description]);
    else
        [session setActive:YES error:nil];
    
    NSString *savePath = [dataManager.downloadPath  stringByAppendingPathComponent:[NSString stringWithFormat:@"music"]];
    NSString *recorderFilePath = [NSString stringWithFormat:@"%@/%@.caf", savePath,dateString];
    recordedFile = [NSURL fileURLWithPath:recorderFilePath];
    
    recorder = [[AVAudioRecorder alloc] initWithURL:recordedFile settings:nil error:nil];
    [recorder prepareToRecord];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backBtuuon
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveBtuuon
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)recordVoice:(id)sender {

    

    if (_isRecording) {
//        _isRecording = NO;
        
        [sender setBackgroundImage:[UIImage imageNamed:@"recording_play"] forState:UIControlStateNormal];

        if (!_isPlaying) {
            _isPlaying = YES;
            [recorder stop];
            recorder = nil;
            deleteBtn.hidden = NO;
            saveBtn.hidden = NO;
            [timer invalidate];

        }
        else
        {
            NSError *playerError;
            
            player = [[AVAudioPlayer alloc] initWithContentsOfURL:recordedFile error:&playerError];
            
            if (player == nil)
            {
                NSLog(@"ERror creating player: %@", [playerError description]);
            }
            player.delegate = self;
            
            [player play];

        }
        
    }
    else
    {
        _isRecording = YES;
        
        [sender setBackgroundImage:[UIImage imageNamed:@"recording_stop"] forState:UIControlStateNormal];
        
        [recorder record];

        intTime = 0;
        
        Music *music = [[Music alloc]init];
        music.name = dateString;
        music.path = [NSString stringWithFormat:@"%@.caf",dateString];
        [dataManager insertMusicInfo:music];

        
        NSTimeInterval timeInterval =1.0 ;
        //定时器
        timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                               target:self
                                                             selector:@selector(showTimer:)
                                                             userInfo:nil
                                                              repeats:YES];
        [timer fire];
        
    }


    
}

- (void)showTimer:(NSTimer *)theTimer
{
    intTime++;

    timeLabel.text = [NSString stringWithFormat:@"%d:00/10:00",intTime];
    timeLabel.font = [UIFont fontWithName:@"SnackerComic_PerosnalUseOnly" size:30];

    if (intTime==10) {
        [timer invalidate];
        
        _isPlaying = YES;
        [recorder stop];
        recorder = nil;
        deleteBtn.hidden = NO;
        saveBtn.hidden = NO;
        [recordBtn setBackgroundImage:[UIImage imageNamed:@"recording_play"] forState:UIControlStateNormal];

    }
    timeImage.frame = CGRectMake(timeImage.frame.origin.x, timeImage.frame.origin.y-21, timeImage.frame.size.width, 481);
    
    NSLog(@"%f   %f   %f   %f   ",timeImage.frame.origin.x,timeImage.frame.origin.y,timeImage.frame.size.width,timeImage.frame.size.height);
    

}

- (IBAction)deleteSounds:(id)sender
{
    _isRecording = NO;
    _isPlaying = NO;
    
    saveBtn.hidden = YES;
    deleteBtn.hidden = YES;

    [recordBtn setBackgroundImage:[UIImage imageNamed:@"recording_rec"] forState:UIControlStateNormal];
    timeImage.frame = CGRectMake(timeImage.frame.origin.x, 346, timeImage.frame.size.width, 481);

    NSString *savePath = [dataManager.downloadPath  stringByAppendingPathComponent:[NSString stringWithFormat:@"music"]];
    NSString *recorderFilePath = [NSString stringWithFormat:@"%@/%@.caf", savePath,dateString];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:recorderFilePath error:nil];
    
    [dataManager deleteMusicWithName:[NSString stringWithFormat:@"%@.caf",dateString]];

}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
//    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
}

@end
