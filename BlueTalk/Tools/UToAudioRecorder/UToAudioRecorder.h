//
//  UToAudioRecorder.h
//  UToHitchhike
//
//  Created by Weighter on 2017/5/25.
//  Copyright © 2017年 uto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^AudioPowerChanged)(CGFloat value);
typedef void(^AudioRecorderFinished)(BOOL flag);
typedef void(^AudioPlayerFinishedPlaying)(BOOL flag);

@interface UToAudioRecorder : NSObject

@property (nonatomic, copy) NSURL *savePath;
@property (nonatomic, strong) NSData *playData;

/**
 *  设置音频会话
 */
- (void)setAudioSession;

/**
 *  点击录音按钮
 *
 *  sender 录音按钮
 */
- (void)startRecord;

/**
 *  点击录音暂定按钮
 *
 *  sender 暂停按钮
 */
- (void)pauseRecord;

/**
 *  点击录音恢复按钮
 *  恢复录音只需要再次调用record，AVAudioSession会帮助你记录上次录音位置并追加录音
 *
 *  sender 恢复按钮
 */
- (void)resumeRecord;

/**
 *  点击录音停止按钮
 *
 *  sender 停止按钮
 */
- (void)stopRecord;

/**
 *  点击播放按钮
 *
 *  sender 停止按钮
 */
- (void)playRecord;

/**
 *  点击播放暂停按钮
 *
 *  sender 停止按钮
 */
- (void)pausePlayRecord;

/**
 *  点击播放停止按钮
 *
 *  sender 停止按钮
 */
- (void)stopPlayRecord;

/**
 音频波动改变

 block 回调
 */
- (void)setAudioPowerChanged:(AudioPowerChanged)block;

- (void)audioRecorderDidFinish:(AudioRecorderFinished)block;

- (void)audioPlayerDidFinishPlaying:(AudioPlayerFinishedPlaying)block;

@end
