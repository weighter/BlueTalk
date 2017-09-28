//
//  UToConversationViewController.m
//  BlueTalk
//
//  Created by Weighter on 2017/2/23.
//  Copyright © 2017年 Weighter. All rights reserved.
//

#import "UToConversationViewController.h"
#import "UToBlueSessionManager.h"
#import "UToChatCell.h"
#import "AppDelegate.h"
#import "UToCommonDBCache.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>
#import "UToAudioRecorder.h"

@interface UToConversationViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, NSStreamDelegate, UToMessageUpdateDelegate> {
    
    UIImagePickerController *_picker;
    UToAlert *_alret;
    MBProgressHUD *_hud;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *sendBackView;
@property (nonatomic, strong) UITextView *sendTextView;
@property (nonatomic, strong) UIButton *voiceButton;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) NSMutableData *streamData;
@property (nonatomic, strong) UToAudioRecorder *audio;

@end

@implementation UToConversationViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    utoDelegate.rdelegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    utoDelegate.rdelegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.peerId.displayName;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"连接" style:UIBarButtonItemStyleDone target:self action:@selector(linkContact)];
    
    [self.tableView reloadData];
    
    [self createUI];
}

- (void)linkContact {
    
    [get_singleton_for_class(UToBlueSessionManager) invitePeerToConnect:self.peerId connected:^{
        
    }];
}

- (UToAudioRecorder *)audio {
    
    if (!_audio) {
        
        _audio = [[UToAudioRecorder alloc] init];
        [_audio setAudioSession];
        
        __weak typeof(self) weakSelf = self;
        [_audio setAudioPowerChanged:^(CGFloat value) {
            
            _hud.progress = value;
        }];
        
        [_audio audioRecorderDidFinish:^(BOOL flag) {
            
            [weakSelf sendAsStream];
        }];
        
        [_audio audioPlayerDidFinishPlaying:^(BOOL flag) {
            
        }];
    }
    return _audio;
}

- (void)createUI {
    
    self.sendBackView = [[UIView alloc] init];
    self.sendBackView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.sendBackView];
    [self.sendBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@(0));
        make.right.mas_equalTo(@(0));
        make.height.mas_equalTo(@(45.));
        make.bottom.mas_equalTo(@(0));
    }];
    
    self.sendTextView = [[UITextView alloc] init];
    self.sendTextView.returnKeyType = UIReturnKeySend;
    self.sendTextView.font = [UIFont systemFontOfSize:17];
    self.sendTextView.editable = YES;
    self.sendTextView.delegate = self;
    [self.sendBackView addSubview:self.sendTextView];
    [self.sendTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@(10));
        make.right.mas_equalTo(@(-60));
        make.top.mas_equalTo(@(5));
        make.bottom.mas_equalTo(@(-5));
    }];
    
    self.voiceButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [self.voiceButton addTarget:self action:@selector(startVoiceRecord) forControlEvents:UIControlEventTouchDown];
    [self.voiceButton addTarget:self action:@selector(stopVoiceRecord) forControlEvents:UIControlEventTouchUpInside];
    [self.sendBackView addSubview:self.voiceButton];
    [self.voiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@(10));
        make.right.mas_equalTo(@(-60));
        make.top.mas_equalTo(@(5));
        make.bottom.mas_equalTo(@(-5));
    }];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [addButton addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
    [self.sendBackView addSubview:addButton];
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.sendTextView.mas_right);
        make.centerY.mas_equalTo(self.sendBackView.mas_centerY);
        make.width.mas_equalTo(@(30));
        make.height.mas_equalTo(@(30));
    }];
    
    self.sendButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [self.sendButton addTarget:self action:@selector(voiceRecord) forControlEvents:UIControlEventTouchUpInside];
    [self.sendBackView addSubview:self.sendButton];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(addButton.mas_right);
        make.centerY.mas_equalTo(self.sendBackView.mas_centerY);
        make.width.mas_equalTo(@(30));
        make.height.mas_equalTo(@(30));
    }];
    
    // 增加通知
    [self addTheNoticeForKeyDownUp];
}

- (BOOL)receivedNewMessage:(MCPeerID *)peerId chatItem:(UToChatItem *)chatItem {
    
    if (peerId == self.peerId) {
        
        [self.dataArray addObject:chatItem]; // 加到数组里面
        [self insertTheTableToButtom];
        return YES;
    }
    return NO;
}

- (void)insertTheTableToButtom {
    
    // 哪一组 哪一段
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:self.dataArray.count- 1 inSection:0];
    // 添加新的一行
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    // 滑动到底部  第二个参数是滑动到底部
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - 普通数据的传输
- (void)sendWeNeedNews {
    
    __weak typeof(self) weakSelf = self;
    if (!get_singleton_for_class(UToBlueSessionManager).isConnected) {
        
        _alret = [UToAlert AlertTitle:@"蓝牙已经断开了，请重新连接！" content:nil cancelButton:@"知道了" okButton:@"重新连接" complete:^(BOOL isOk) {
            
            if (isOk) {
                
                [weakSelf linkContact];
            }
            
        }];
        [_alret showAlertWithController:self];
        return;
    }
    
    if ([self.sendTextView.text isEqualToString:@""]) {
        
        return;
    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.sendTextView.text];
    
    UToChatItem *chatItem = [[UToChatItem alloc] init];
    chatItem.isSelf = YES;
    chatItem.displayName = get_singleton_for_class(UToBlueSessionManager).myPeerID.displayName;
    chatItem.states = textStates;
    chatItem.data = data;
    chatItem.time = [[NSDate date] timeIntervalSince1970];
    [self.dataArray addObject:chatItem]; // 加到数组里面
    [get_singleton_for_class(UToCommonDBCache) addHistoryMessage:chatItem];
    
    // 添加行   indexPath描述位置的具体信息
    [self insertTheTableToButtom];
    
    NSError *error = [get_singleton_for_class(UToBlueSessionManager) sendDataToAllPeers:data];
    if(!error) {
        
        //there was no error.
    } else {
        
        NSLog(@"%@", error);
    }
    
    [self returnTheNewBack];
}

- (void)returnTheNewBack {
    
    // 归零
    self.sendTextView.text = @"";
    [self.sendTextView resignFirstResponder];
}

// 这是一种很好的键盘下移方式
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    
    if ([text isEqualToString:@"\n"]) {
        
        [self sendWeNeedNews];
        [self.sendBackView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@(45.));
        }];
        return NO;
    }

    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    // 随机改变其高度
    float textHeight = [self heightForString:textView.text fontSize:16 andWidth:textView.frame.size.width];
    [self.sendBackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(textHeight+10));
    }];
}

- (float)heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width {
    
    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = [UIFont systemFontOfSize:fontSize];
    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return deSize.height;
}

#pragma mark - 图片的传输
- (void)addImage {
    
    __weak typeof(self) weakSelf = self;
    _alret = [UToAlert AlertSheetTitle:nil content:nil cancelButton:@"取消" selectButton:@[@"相机", @"相册"] complete:^(NSInteger index) {
        
        [weakSelf actionSheetClickedButtonAtIndex:index];
    }];
    [_alret showAlertWithController:self];
}

-(void)actionSheetClickedButtonAtIndex:(NSInteger)buttonIndex {
    
    _picker = [[UIImagePickerController alloc] init];
    _picker.delegate = self;
    _picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    _picker.allowsEditing = NO;
    
    switch (buttonIndex) {
        case 1: //Take picture
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                
                _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            }
            
            [self presentViewController:_picker animated:YES completion:nil];
            
            break;
        case 2: //From album
            
            _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            _picker.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
            
            [self presentViewController:_picker animated:YES completion:^{
                
                // 改变状态栏的颜色  为正常  这是这个独有的地方需要处理的
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            }];
            break;
        default:
            
            break;
    }
}

// 相册
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        
        //如果是图片
        //先把图片转成NSData
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil) {
            
            data = UIImageJPEGRepresentation(image, 1.0);
        } else {
            
            data = UIImagePNGRepresentation(image);
        }
        
        //图片保存的路径
        //这里将图片放在沙盒的documentPublic文件夹中
        NSString *path = [UToNSFileManager getAppDocumentPublicPath];
        NSString *imgPath = [NSString stringWithFormat:@"%@/%@", path, @"images"];
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath:imgPath]) { // 如果不存在直接创建
            
            [fileManager createDirectoryAtPath:imgPath withIntermediateDirectories:NO attributes:nil error:nil];
        }
        
        // 把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        NSTimeInterval dateTime = [[NSDate date] timeIntervalSince1970];
        NSString *str = [NSString stringWithFormat:@"/%f.png", dateTime];
        [fileManager createFileAtPath:[imgPath stringByAppendingString:str] contents:data attributes:nil];
        //得到选择后沙盒中图片的完整路径
        NSString *filePath = [[NSString alloc]initWithFormat:@"%@%@", imgPath, str];
        
        [picker dismissViewControllerAnimated:YES completion:^{
            
            // 改变状态栏的颜色  改变为白色
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            
            // 这边是真正的发送
            if(!get_singleton_for_class(UToBlueSessionManager).isConnected) {
                
                __weak typeof(self) weakSelf = self;
                
                _alret = [UToAlert AlertTitle:@"蓝牙已经断开了，请重新连接！" content:nil cancelButton:@"知道了" okButton:@"重新连接" complete:^(BOOL isOk) {
                    
                    if (isOk) {
                        
                        [weakSelf linkContact];
                    }
                    
                }];
                [_alret showAlertWithController:self];
                return;
            }
            
            UToChatItem *chatItem = [[UToChatItem alloc] init];
            chatItem.isSelf = YES;
            chatItem.states = picStates;
            chatItem.data = data;
            chatItem.time = dateTime;
            [self.dataArray addObject:chatItem];
            [get_singleton_for_class(UToCommonDBCache) addHistoryMessage:chatItem];
            [self insertTheTableToButtom];
            [self sendAsResource:filePath];
        }];
    } else {
        
        //如果是视频
        NSURL *url = info[UIImagePickerControllerReferenceURL];
        
        if ([[UIDevice currentDevice].systemVersion floatValue] > 8.0) {
            
            PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
            NSLog(@"%@",url);
            PHFetchResult *fetchResult = [PHAsset fetchAssetsWithALAssetURLs:@[url] options:fetchOptions];
            PHAsset *asset = [fetchResult firstObject];
            [[PHImageManager defaultManager] requestPlayerItemForVideo:asset options:nil resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
                
                
            }];
            [picker dismissViewControllerAnimated:YES completion:^{
                
            }];
            
            PHAsset *phAsset = (PHAsset *)asset;
            CGFloat aspectRatio = phAsset.pixelWidth / (CGFloat)phAsset.pixelHeight;
            CGFloat multiple = [UIScreen mainScreen].scale;
            CGFloat pixelWidth = 100 * multiple;
            CGFloat pixelHeight = pixelWidth / aspectRatio;
            
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(pixelWidth, pixelHeight) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
                if (downloadFinined && result) {
//                    result = [self fixOrientation:result];
//                    if (completion) completion(result,info,[[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
                }
                // Download image from iCloud / 从iCloud下载图片
                if ([info objectForKey:PHImageResultIsInCloudKey] && !result) {
                    PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
                    option.networkAccessAllowed = YES;
                    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                        UIImage *resultImage = [UIImage imageWithData:imageData scale:0.1];
//                        resultImage = [self scaleImage:resultImage toSize:CGSizeMake(pixelWidth, pixelHeight)];
//                        if (resultImage) {
//                            resultImage = [self fixOrientation:resultImage];
//                            if (completion) completion(resultImage,info,[[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
//                        }
                    }];
                }
            }];
        } else {
            
            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset) {
                
                ALAssetRepresentation *representation = [myasset defaultRepresentation];
                NSString *fileName = [representation filename];
                NSLog(@"fileName : %@",fileName);
                [picker dismissViewControllerAnimated:YES completion:^{
                    
                }];
            };
            
            ALAssetsLibrary *assetslibrary = [[ALAssetsLibrary alloc] init];
            [assetslibrary assetForURL:url resultBlock:resultblock failureBlock:nil];
        }
    }
}
//-(void)run
//{
//    __weak ViewController *weakSelf = self;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
//            if (group != nil) {
//                [weakSelf.groupArrays addObject:group];
//            } else {
//                [weakSelf.groupArrays enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                    [obj enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL  *stop) {
//                        if ([result thumbnail] != nil) {
//                            // 照片
//                            if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]){
//                                
//                                //                                NSDate *date= [result valueForProperty:ALAssetPropertyDate];
//                                //                                UIImage *image = [UIImage imageWithCGImage:[result thumbnail]];
//                                //                                NSString *fileName = [[result defaultRepresentation] filename];
//                                //                                NSURL *url = [[result defaultRepresentation] url];
//                                //                                int64_t fileSize = [[result defaultRepresentation] size];
//                                //
//                                //                                NSLog(@"date = %@",date);
//                                //                                NSLog(@"fileName = %@",fileName);
//                                //                                NSLog(@"url = %@",url);
//                                //                                NSLog(@"fileSize = %lld",fileSize);
//                                //
//                                //                                // UI的更新记得放在主线程,要不然等子线程排队过来都不知道什么年代了,会很慢的
//                                //                                dispatch_async(dispatch_get_main_queue(), ^{
//                                //                                    self.litimgView.image = image;
//                                //                                });
//                                NSLog(@"读取到照片了");
//                            }
//                            // 视频
//                            else if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo] ){
//                                
//                                NSURL *url = [[result defaultRepresentation] url];
//                                UIImage *image = [UIImage imageWithCGImage:[result thumbnail]];                                NSLog(@"%@",url);
//                                dispatch_async(dispatch_get_main_queue(), ^{
//                                    self.litimgView.image = image;
//                                });
//                                // 和图片方法类似
//                            }
//                        }
//                    }];
//                }];
//                
//            }
//        };
//        
//        ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error)
//        {
//            
//            NSString *errorMessage = nil;
//            
//            switch ([error code]) {
//                case ALAssetsLibraryAccessUserDeniedError:
//                case ALAssetsLibraryAccessGloballyDeniedError:
//                    errorMessage = @"用户拒绝访问相册,请在<隐私>中开启";
//                    break;
//                    
//                default:
//                    errorMessage = @"Reason unknown.";
//                    break;
//            }
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"错误,无法访问!"
//                                                                   message:errorMessage
//                                                                  delegate:self
//                                                         cancelButtonTitle:@"确定"
//                                                         otherButtonTitles:nil, nil];
//                [alertView show];
//            });
//        };
//        
//        
//        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]  init];
//        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
//                                     usingBlock:listGroupBlock failureBlock:failureBlock];
//    });
//}


// 获取毫秒
- (long long)getDateTimeTOMilliSeconds:(NSDate *)datetime {
    
    NSTimeInterval interval = [datetime timeIntervalSince1970];
    
    NSLog(@"转换的时间戳=%f",interval);
    
    long long totalMilliseconds = interval*1000 ;
    
    NSLog(@"totalMilliseconds=%llu",totalMilliseconds);
    
    return totalMilliseconds;
    
}

- (void)sendAsResource:(NSString *)path {
    
    NSLog(@"dispaly ====%@",get_singleton_for_class(UToBlueSessionManager).firstPeer.displayName);
    NSString *name = [NSString stringWithFormat:@"%@ForPic", [[UIDevice currentDevice] name]];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    NSProgress *progress = [get_singleton_for_class(UToBlueSessionManager) sendResourceWithName:name atURL:url toPeer:get_singleton_for_class(UToBlueSessionManager).firstPeer complete:^(NSError *error) {
        
        if(!error) {
            NSLog(@"finished sending resource");
        }
        else {
            NSLog(@"%@", error);
        }
    }];
    NSLog(@"%@", @(progress.fractionCompleted));
}

#pragma mark - 下面是流的传输
- (void)voiceRecord {
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    _hud.label.text = @"录音中...";
    [self.audio startRecord];
}

- (void)startVoiceRecord {
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    _hud.label.text = @"录音中...";
    [self.audio startRecord];
}

- (void)stopVoiceRecord {
    
    [_hud hideAnimated:YES];
    [self.audio stopRecord];
    NSData *data = [NSData dataWithContentsOfURL:[self.audio savePath]];
    UToChatItem *chatItem = [[UToChatItem alloc] init];
    chatItem.isSelf = YES;
    chatItem.displayName = get_singleton_for_class(UToBlueSessionManager).myPeerID.displayName;
    chatItem.states = voiceStates;
    chatItem.data = data;
    chatItem.time = [[NSDate date] timeIntervalSince1970];
    [self.dataArray addObject:chatItem];
    [self insertTheTableToButtom];
    [get_singleton_for_class(UToCommonDBCache) addHistoryMessage:chatItem];
}

- (void)sendAsStream {
    
    if(!get_singleton_for_class(UToBlueSessionManager).isConnected) {
        
        __weak typeof(self) weakSelf = self;
        
        _alret = [UToAlert AlertTitle:@"蓝牙已经断开了，请重新连接！" content:nil cancelButton:@"知道了" okButton:@"重新连接" complete:^(BOOL isOk) {
            
            if (isOk) {
                
                [weakSelf linkContact];
            }
            
        }];
        [_alret showAlertWithController:self];
        return;
    }
    
    NSError *err;
    [get_singleton_for_class(UToBlueSessionManager) streamWithName:@"audio stream" toPeer:self.peerId outputStreamData:[NSData dataWithContentsOfURL:[self.audio savePath]] error:&err];
    if(err || !get_singleton_for_class(UToBlueSessionManager).outputStream) {
        
        NSLog(@"%@", err);
    } else {
        
        [get_singleton_for_class(UToBlueSessionManager).outputStream open];
    }
}

//// 下面是一个代理
//- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
//    
//    if(eventCode == NSStreamEventHasBytesAvailable) {
//        
//        // 有可读的字节，接收到了数据
//        NSInputStream *input = (NSInputStream *)aStream;
//        uint8_t buffer[1024];
//        NSInteger length = [input read:buffer maxLength:1024];
//        [self.streamData appendBytes:(const void *)buffer length:(NSUInteger)length];
//        // 记住这边的数据陆陆续续的
//    } else if(eventCode == NSStreamEventHasSpaceAvailable) {
//        
//        // 可以使用输出流的空间，此时可以发送数据给服务器
//        // 发送数据的
//        NSData *data = [NSData dataWithContentsOfURL:[self.audio savePath]];
//        self.audio.playData = data;
//        [self.audio playRecord];
//        UToChatItem *chatItem = [[UToChatItem alloc] init];
//        chatItem.isSelf = YES;
//        chatItem.displayName = get_singleton_for_class(UToBlueSessionManager).myPeerID.displayName;
//        chatItem.states = videoStates;
//        chatItem.data = data;
//        chatItem.time = [[NSDate date] timeIntervalSince1970];
//        [self.dataArray addObject:chatItem];
//        [self insertTheTableToButtom];
//        
//        NSOutputStream *output = (NSOutputStream *)aStream;
//        [output write:data.bytes maxLength:data.length];
//        [output close];
//    }
//    
//    if(eventCode == NSStreamEventEndEncountered) {
//        
//        // 流结束事件，在此事件中负责做销毁工作
//        // 同时也是获得最终数据的好地方
//        
//        UToChatItem *chatItem = [[UToChatItem alloc] init];
//        chatItem.isSelf = NO;
//        chatItem.displayName = get_singleton_for_class(UToBlueSessionManager).myPeerID.displayName;
//        chatItem.states = videoStates;
//        chatItem.data = self.streamData;
//        chatItem.time = [[NSDate date] timeIntervalSince1970];
//        [self.dataArray addObject:chatItem];
//        [self insertTheTableToButtom];
//        
//        [aStream close];
//        [aStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
//        if([aStream isKindOfClass:[NSInputStream class]]) {
//            
//            self.streamData = nil;
//        }
//    }
//    
//    if(eventCode == NSStreamEventErrorOccurred) {
//        
//        // 发生错误
//        NSLog(@"error");
//    }
//}
//
//- (NSMutableData *)streamData
//{
//    if(!_streamData) {
//        _streamData = [NSMutableData data];
//    }
//    return _streamData;
//}
//
///***********-----------------------  公用的数据 --------------------***********************************/
//
//- (NSData *)imageData
//{
//    return [NSData dataWithContentsOfURL:[self imageURL]];
//}
//
//- (NSURL *)imageURL {
//    NSString *path = [[NSBundle mainBundle]pathForResource:@"301-alien-ship@2x" ofType:@"png"];
//    // 这儿有个技术点
//    // 那个如何将 image转化成 路径
//    
//    NSURL *url = [NSURL fileURLWithPath:path];
//    return url;
//}
//
///***********----------------------------------------------***********************************/
//#pragma mark 尝试空白处的连接
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch * touch = [[event allTouches] anyObject];
//    if(touch.tapCount >= 1)
//    {
//        [self.sendTextView resignFirstResponder];
//    }
//}
//
//
///***********-------------------语音---------------------------***********************************/
//
//#pragma mark 尝试语音的录制和播出
//
//- (void)buildVideoForWe
//{
//    // 设置录音会话
//}
//
//- (void)SetTempRecordView
//{
//    _backRemindRecordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 150)];
//    _backRemindRecordView.center = self.view.center;
//    _backRemindRecordView.backgroundColor = [UIColor lightGrayColor];
//    [self.view addSubview:_backRemindRecordView];
//    
//    
//    UILabel * beginLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 50, WIDTH -120, 50)];
//    beginLabel.backgroundColor = [UIColor greenColor];
//    beginLabel.text = @"长按录音开始···";
//    beginLabel.tag = 1001;
//    beginLabel.textAlignment = NSTextAlignmentCenter;
//    beginLabel.userInteractionEnabled = YES;
//    [_backRemindRecordView addSubview:beginLabel];
//    
//    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressNextDo:)];
//    [beginLabel addGestureRecognizer:longPress];
//    
//    
//    
//    
//    
//    
//}
//
//
//
//- (void)longPressNextDo:(UILongPressGestureRecognizer * )longPress
//{
////    if(longPress.state == UIGestureRecognizerStateBegan)
////    {
////        NSLog(@"begin");
////        UILabel * label = (UILabel *)[_backRemindRecordView viewWithTag:1001];
////        label.text = @"录音正在进行中···";
////        label.backgroundColor = [UIColor orangeColor];
////        [self BeginRecordClick];
////    }
////    if(longPress.state == UIGestureRecognizerStateEnded)
////    {
////        [self OkStopClick];
////        [_backRemindRecordView removeFromSuperview];
////        [self  sendAsStream];
////        NSLog(@"stop");
////        
////    }
//}

#pragma mark - 以下是为了配合  键盘上移的变化
- (void)addTheNoticeForKeyDownUp {
    
    [ [NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [ [NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handleKeyBoardDidShow:(NSNotification *)paramNotification {
    
    CGSize size = [[paramNotification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInset = self.tableView.contentInset;
    contentInset.bottom = size.height;
    
    [UIView animateWithDuration:0.1 animations:^{
        
        self.tableView.contentInset = contentInset;
        self.sendBackView.transform = CGAffineTransformMakeTranslation(0, -size.height);
    } completion:^(BOOL finished) {
        
        if (self.dataArray.count) {
            
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count- 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }];
}

- (void)handleKeyboardWillHide:(NSNotification *)paramNotification {
    
    UIEdgeInsets contentInset = self.tableView.contentInset;
    contentInset.bottom = 0;
    
    [UIView animateWithDuration:0.1 animations:^{
        
        self.tableView.contentInset = contentInset;
        self.sendBackView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
        if (self.dataArray.count) {
            
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count- 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }];
}

- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - tableView
- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.sectionHeaderHeight = 0.01;
        _tableView.sectionFooterHeight = 0.01;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(@(0));
            make.right.mas_equalTo(@(0));
            make.top.mas_equalTo(@(0));
            make.bottom.mas_equalTo(@(-45));
        }];
    }
    
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UToChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellIdentifier"];
    if(cell == nil) {
        
        cell = [[UToChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone; // 让后面选中的没有阴影效果
    }
    
    UToChatItem *chatItem = [self.dataArray objectAtIndex:indexPath.row];
    cell.chatItem = chatItem;
    [cell setBlock:^(BOOL startPlay) {
        
        if (startPlay) {
            
            self.audio.playData = chatItem.data;
            [self.audio playRecord];
        } else {
            
            [self.audio stopPlayRecord];
        }
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UToChatItem * chatItem = [self.dataArray objectAtIndex:indexPath.row];
    CGFloat width = SCREEN_WIDTH*3/4-LeftMargin-30-PixelSpacing-RightMargin-PixelSpacing-LeftMargin-PixelSpacing-5;
    
    if(chatItem.states == textStates) {
        
        NSString *string = [NSKeyedUnarchiver unarchiveObjectWithData:chatItem.data];
        CGRect bound = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:MessageLabelFont} context:nil];
        return bound.size.height+PixelSpacing*3+TopMargin+BottomMargin; // 与view的距离 ＋ 与Cell的距离
    } else if(chatItem.states == picStates) {
        
        UIImage *image = [UIImage imageWithData:chatItem.data];
        CGSize size = image.size;
        if (size.width > width) {
            
            size.height = width/size.width*size.height;
        }
        return size.height+TopMargin+BottomMargin+PixelSpacing*2; // 与view的距离 ＋ 与Cell的距离
    } else {
        
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
// Get the new view controller using [segue destinationViewController].
// Pass the selected object to the new view controller.
}
*/

@end
