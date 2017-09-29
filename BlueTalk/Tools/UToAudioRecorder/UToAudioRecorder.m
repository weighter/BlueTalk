//
//  UToAudioRecorder.m
//  UToHitchhike
//
//  Created by Weighter on 2017/5/25.
//  Copyright © 2017年 uto. All rights reserved.
//

#import "UToAudioRecorder.h"
#import "UToNSFileManager.h"

@interface UToAudioRecorder () <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioRecorder *audioRecorder; //音频录音机
@property (nonatomic, strong) AVAudioPlayer *audioPlayer; //音频播放器，用于播放录音文件
@property (nonatomic, strong) NSTimer *timer; //录音声波监控（注意这里暂时不对播放进行监控）
@property (nonatomic, copy) AudioPowerChanged block;
@property (nonatomic, copy) AudioRecorderFinished rblock;
@property (nonatomic, copy) AudioPlayerFinishedPlaying pblock;

@end

@implementation UToAudioRecorder

#pragma mark - 私有方法
// 设置音频会话
- (void)setAudioSession {
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //设置为播放和录音状态，以便可以在录制完之后播放录音
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
}

// 取得录音文件保存路径
- (NSURL *)getSavePath {
    
    NSString *plistPath = [NSString stringWithFormat:@"%@",[UToNSFileManager getAppDocumentPublicPath]];
    NSString *voicePath = [NSString stringWithFormat:@"%@/%@", plistPath, @"voices"];
    
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:voicePath]) { // 如果不存在直接创建
        
        [fileManager createDirectoryAtPath:voicePath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    //得到完整的文件名
    NSTimeInterval dateTime = [[NSDate date] timeIntervalSince1970];
    NSString *str = [NSString stringWithFormat:@"/%f.caf", dateTime];
    NSString *filename = [plistPath stringByAppendingPathComponent:str];
    NSURL *url = [NSURL fileURLWithPath:filename];
    return url;
}

// 取得录音文件设置
- (NSDictionary *)getAudioSetting {
    
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    //设置录音格式
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    //设置录音采样率，8000是电话采样率，对于一般录音已经够了
    [dicM setObject:@(8000) forKey:AVSampleRateKey];
    //设置通道,这里采用单声道
    [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];
    //每个采样点位数,分为8、16、24、32
    [dicM setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    //....其他设置等
    return dicM;
}

// 获得录音机对象
- (AVAudioRecorder *)audioRecorder {
    
    if (!_audioRecorder) {
        
        //创建录音文件保存路径
        NSURL *url = self.savePath;
        if (!url) {
            
            url = [self getSavePath];
            self.savePath = url;
        }
        //创建录音格式设置
        NSDictionary *setting = [self getAudioSetting];
        //创建录音机
        NSError *error = nil;
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:setting error:&error];
        _audioRecorder.delegate = self;
        _audioRecorder.meteringEnabled = YES;//如果要监控声波则必须设置为YES
        if (error) {
            
            NSLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioRecorder;
}

// 创建播放器
- (AVAudioPlayer *)audioPlayer {
    
    if (!_audioPlayer) {
        
        NSError *error = nil;
        _audioPlayer = [[AVAudioPlayer alloc] initWithData:self.playData error:&error];
        _audioPlayer.delegate = self;
        _audioPlayer.numberOfLoops = 0;
        [_audioPlayer prepareToPlay];
        
        if (error) {
            
            NSLog(@"创建播放器过程中发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioPlayer;
}

// 录音声波监控定制器
- (NSTimer *)timer {
    
    if (!_timer) {
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(audioPowerChange) userInfo:nil repeats:YES];
    }
    return _timer;
}

// 录音声波状态设置  音频波动
- (void)audioPowerChange {
    
    [self.audioRecorder updateMeters];//更新测量值
    float power = [self.audioRecorder averagePowerForChannel:0];//取得第一个通道的音频，注意音频强度范围时-160到0
    CGFloat progress = (1.0/160.0)*(power+160.0);
    if (self.block) {
        
        self.block(progress);
    }
}

- (void)setAudioPowerChanged:(AudioPowerChanged)block {
    
    _block = block;
}

- (void)setPlayData:(NSData *)playData {
    
    self.audioPlayer = nil;
    _playData = playData;
}

#pragma mark - UI事件
// 点击录音按钮
- (void)startRecord {
    
    [self setAudioSession];
    
    if (![self.audioRecorder isRecording]) {
        
        [self.audioRecorder record]; //首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
        self.timer.fireDate = [NSDate distantPast];
    }
}

// 点击暂定按钮
- (void)pauseRecord {
    
    if ([self.audioRecorder isRecording]) {
        
        [self.audioRecorder pause];
        self.timer.fireDate = [NSDate distantFuture];
    }
}

// 点击恢复按钮
// 恢复录音只需要再次调用record，AVAudioSession会帮助你记录上次录音位置并追加录音
- (void)resumeRecord {
    
    [self startRecord];
}

// 点击停止按钮
- (void)stopRecord {
    
    [self.audioRecorder stop];
    self.timer.fireDate = [NSDate distantFuture];
}

// 点击播放按钮
- (void)playRecord {
    
    if (![self.audioPlayer isPlaying]) {
        
        [self.audioPlayer play];
    }
}

// 点击暂停按钮
- (void)pausePlayRecord {
    
    if ([self.audioPlayer isPlaying]) {
        
        [self.audioPlayer pause];
    }
}

// 点击停止按钮
- (void)stopPlayRecord {
    
    [self.audioPlayer stop];
    self.audioPlayer = nil;
}

#pragma mark - 录音机代理方法
// 录音完成，录音完成后播放录音
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    
    recorder = nil;
    if (self.rblock) {
        
        self.rblock(flag);
    }
    NSLog(@"录音完成!");
}

// 播放录音完成
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    // 每次完成后都将这个对象释放
    player = nil;
    if (self.pblock) {
        
        self.pblock(flag);
    }
}

- (void)audioRecorderDidFinish:(AudioRecorderFinished)block {
    
    _rblock = block;
}

- (void)audioPlayerDidFinishPlaying:(AudioPlayerFinishedPlaying)block {
    
    _pblock = block;
}

@end
