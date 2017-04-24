//
//  UToRootViewController.m
//  BlueTalk
//
//  Created by Weighter on 2017/2/23.
//  Copyright © 2017年 Weighter. All rights reserved.
//

#import "UToRootViewController.h"
#import "BlueSessionManager.h"
#import "UToChatCell.h"
#import "ChatItem.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

#define kRecordAudioFile @"myRecord.caf"

#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define ChatHeight 45.0

@interface UToRootViewController () <NSStreamDelegate, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate> {
    
    float _sendBackViewHeight;
    float _sendTextViewHeight;

    UIImagePickerController * _picker;
    UIView * _backRemindRecordView;
}

// DataAndBlue
@property (strong, nonatomic) BlueSessionManager *sessionManager;

@property (strong, nonatomic) NSMutableArray *datasource;
@property (strong, nonatomic) NSMutableArray *myDataArray;

@property (strong, nonatomic) NSMutableData *streamData;
@property (strong, nonatomic) NSOutputStream *outputStream;
@property (strong, nonatomic) NSInputStream *inputStream;

// UI
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *sendBackView;
@property (strong, nonatomic) UITextView *sendTextView;
@property (strong, nonatomic) UIButton *sendButton;

@property (nonatomic,strong) AVAudioRecorder *audioRecorder;
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;
@property (nonatomic,strong) NSTimer *timer;
@property (strong, nonatomic) UIProgressView *audioPower;

@end


@implementation UToRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self makeBlueData];

    [self readyUI];

    [self buildVideoForWe];
}

#pragma mark -

- (void)readyUI {
    
    self.title = @"蓝牙设置";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;

    NSArray * buttonTitleArray = @[@"寻找设备",@"打开天线"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:buttonTitleArray[0] style:UIBarButtonItemStyleDone target:self action:@selector(lookOtherDevice)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:buttonTitleArray[1] style:UIBarButtonItemStyleDone target:self action:@selector(showSelfAdvertiser)];
    [self makeUIView];

}

- (void)lookOtherDevice {
    
    [self.sessionManager browseWithControllerInViewController:self connected:^{
        
    NSLog(@"connected");
    } canceled:^{
        
    NSLog(@"cancelled");
    }];
}

- (void)showSelfAdvertiser {
    
    [self.sessionManager advertiseForBrowserViewController];
}

#pragma mark - UI
- (void)makeUIView {
    
    //    NSLog(@"width === %f,height===== %f",WIDTH,HEIGHT);

    self.myDataArray = [NSMutableArray arrayWithCapacity:0];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64 - ChatHeight - 10)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:self.tableView];
        
    //-------------------------------------------------------------------------//

    self.sendBackView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT - ChatHeight, WIDTH, ChatHeight)];
    self.sendBackView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    [self.view addSubview:self.sendBackView];

    //    float heightView = self.sendBackView.frame.size.height;

    self.sendTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, WIDTH - 10 - 90, 35)];
    //    self.sendTextView.backgroundColor = [UIColor lightGrayColor];
    self.sendTextView.returnKeyType = UIReturnKeySend;
    self.sendTextView.font = [UIFont systemFontOfSize:17];
    self.sendTextView.editable = YES;
    self.sendTextView.delegate = self;
    [self.sendBackView addSubview:self.sendTextView];

    UIButton * addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    addButton.frame = CGRectMake(WIDTH - 85, 2, 37, 37);
    [addButton addTarget:self action:@selector(addNextImage) forControlEvents:UIControlEventTouchUpInside];
    [self.sendBackView addSubview:addButton];

    self.sendButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    self.sendButton.frame = CGRectMake(WIDTH - 45, 5, 40, 30);

//    [self.sendButton setImage:[UIImage imageNamed:@"record.png"] forState:UIControlStateNormal];
    [self.sendButton addTarget:self action:@selector(videoRecord) forControlEvents:UIControlEventTouchUpInside];
    [self.sendBackView addSubview:self.sendButton];

    [self addTheNoticeForKeyDownUp];
}

#pragma mark -

- (void)addNextImage {

    UIActionSheet *chooseImageSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册", nil];
    [chooseImageSheet showInView:self.view];
}

#pragma mark UIActionSheetDelegate Method
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _picker = [[UIImagePickerController alloc] init];
    _picker.delegate = self;

    switch (buttonIndex) {
            
        case 0://Take picture
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {

                _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            }

            [self presentViewController:_picker animated:NO completion:nil];
        break;

        case 1:
            //From album
            _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:_picker animated:NO completion:^{
                
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            }];
        break;

        default:

        break;
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];

    if ([type isEqualToString:@"public.image"])
    {

        UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }

        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];

        NSFileManager *fileManager = [NSFileManager defaultManager];

        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];

        NSString * filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        
        [_picker dismissViewControllerAnimated:NO completion:^{

            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

            if(!self.sessionManager.isConnected)
            {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"尚无连接设备" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
                return;
            }

            ChatItem * chatItem = [[ChatItem alloc] init];
            chatItem.isSelf = YES;
            chatItem.states = picStates;
            chatItem.picImage = image;
            [self.datasource addObject:chatItem];
            [self insertTheTableToButtom];
            [self sendAsResource:filePath];

        }];
    }
}

- (void)sendAsResource:(NSString *)path
{
    NSLog(@"dispaly ====%@",self.sessionManager.firstPeer.displayName);
    NSString * name = [NSString stringWithFormat:@"%@ForPic",[[UIDevice currentDevice] name]];
    NSURL * url = [NSURL fileURLWithPath:path];

    NSProgress *progress = [self.sessionManager sendResourceWithName:name atURL:url toPeer:self.sessionManager.firstPeer complete:^(NSError *error) {
        if(!error) {
            NSLog(@"finished sending resource");
        }
        else {
            NSLog(@"%@", error);
        }
    }];
    NSLog(@"%@", @(progress.fractionCompleted));
}


#pragma mark
- (void)sendWeNeedNews
{
    if(!self.sessionManager.isConnected)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"尚无连接设备" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
        
    if([self.sendTextView.text isEqualToString:@""])
    {
        return;
    }


    ChatItem * chatItem = [[ChatItem alloc] init];
    chatItem.isSelf = YES;
    chatItem.states = textStates;
    chatItem.content = self.sendTextView.text;
    [self.datasource addObject:chatItem];
    [self insertTheTableToButtom];

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.sendTextView.text];
    NSError *error = [self.sessionManager sendDataToAllPeers:data];
    if(!error) {
        //there was no error.
    }
    else {
        NSLog(@"%@", error);
    }

    [self returnTheNewBack];
}

- (void)returnTheNewBack
{
    self.sendTextView.text = @"";
    [self.sendTextView resignFirstResponder];
    self.tableView.frame = CGRectMake(0, 64, WIDTH, HEIGHT - 64 - ChatHeight - 10 );
    self.sendBackView.frame = CGRectMake(0, HEIGHT - ChatHeight , WIDTH, ChatHeight);
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {

        [self sendWeNeedNews];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    float textHeight = [self heightForString:textView.text fontSize:16 andWidth:textView.frame.size.width];
    _sendTextViewHeight = textHeight;
    //    NSLog(@"teztheight ===== %f",textHeight);
    self.sendTextView.frame = CGRectMake(10, 5, WIDTH - 10 - 90, _sendTextViewHeight);
    self.sendBackView.frame = CGRectMake(0, HEIGHT -  _sendBackViewHeight - _sendTextViewHeight - 10, WIDTH, _sendTextViewHeight + 10);
}

- (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = [UIFont systemFontOfSize:fontSize];
    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return deSize.height;
}



#pragma mark

- (void)addTheNoticeForKeyDownUp
{
    [ [NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [ [NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)handleKeyBoardDidShow:(NSNotification *)paramNotification
{
    CGSize size = [[paramNotification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    _sendBackViewHeight = size.height;
    [UIView animateWithDuration:0.000001 animations:^{
        self.tableView.frame = CGRectMake(0, 64, WIDTH, HEIGHT - 64 - ChatHeight - size.height);
        self.sendBackView.frame = CGRectMake(0, HEIGHT - ChatHeight - size.height, WIDTH, ChatHeight);
    }];
}

-(void)handleKeyboardWillHide:(NSNotification *)paramNotification
{
    [UIView animateWithDuration:0.1 animations:^{
        if(_sendTextViewHeight > 0)
        {
            self.tableView.frame = CGRectMake(0, 64, WIDTH, HEIGHT - 64 - _sendTextViewHeight + 10 );
            self.sendBackView.frame = CGRectMake(0, HEIGHT - _sendTextViewHeight  - 10, WIDTH, _sendTextViewHeight + 10);
        }
        else
        {
            self.tableView.frame = CGRectMake(0, 64, WIDTH, HEIGHT - 64 - ChatHeight - 10 );
            self.sendBackView.frame = CGRectMake(0, HEIGHT - ChatHeight , WIDTH, ChatHeight);
        }
    }];
}

/*--------------------------------------------------------------------------------------------*/

- (void)insertTheTableToButtom
{
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:self.datasource.count- 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.datasource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatItem * chatItem = [self.datasource objectAtIndex:indexPath.row];
    if(chatItem.states == picStates)
    {
        NSLog(@"widht====%f,height======%f",chatItem.picImage.size.width,chatItem.picImage.size.height);
        return 50;
    } else if(chatItem.states == textStates) {

        CGSize size = [chatItem.content boundingRectWithSize:CGSizeMake(250, 1000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size;
        return size.height + 20 + 10;
    } else {
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * iden = @"iden";
    UToChatCell * cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if(cell == nil)
    {
        cell = [[UToChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    ChatItem * chatItem = [self.datasource objectAtIndex:indexPath.row];
    CGSize size = [chatItem.content boundingRectWithSize:CGSizeMake(250, 1000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size;

    if(chatItem.isSelf)
    {
        cell.leftHeadImage.hidden = YES;
        cell.rightHeadImage.hidden = NO;
        if(chatItem.states == picStates)
        {
            cell.lefeView.hidden = YES;
            cell.rightView.hidden = YES;
            cell.rightPicImage.image = chatItem.picImage;
            cell.leftPicImage.hidden = YES;
            cell.rightPicImage.hidden = NO;
            cell.leftVideoButton.hidden = YES;
            cell.rightVideoButton.hidden = YES;
            NSLog(@"self send");
        }
        else if(chatItem.states == textStates)
        {
            cell.rightPicImage.hidden = YES;
            cell.leftPicImage.hidden = YES;
            cell.lefeView.hidden = YES;
            cell.rightView.hidden = NO;
            cell.leftVideoButton.hidden = YES;
            cell.rightVideoButton.hidden = YES;
            cell.rightLabel.frame = CGRectMake(10, 5, size.width, size.height);
            cell.rightView.frame = CGRectMake(WIDTH - 40 -size.width-25, 5, size.width + 25, size.height + 18);
            cell.rightLabel.text = chatItem.content;
        }
        else
        {
            cell.rightView.hidden = YES;
            cell.lefeView.hidden = YES;
            cell.rightView.hidden = YES;
            cell.lefeView.hidden = YES;
            cell.leftVideoButton.hidden = YES;
            cell.rightVideoButton.hidden = NO;
            cell.rightVideoButton.tag = 300 + indexPath.row;
            [cell.rightVideoButton addTarget:self action:@selector(cellSelectIndex:) forControlEvents:UIControlEventTouchUpInside];
            [cell.rightVideoButton setImage:[UIImage imageNamed:@"record.png"] forState:UIControlStateNormal];
        }
    }
    else
    {
        cell.leftHeadImage.hidden = NO;
        cell.rightHeadImage.hidden = YES;
        if(chatItem.states == picStates)
        {
            cell.rightView.hidden = YES;
            cell.lefeView.hidden = YES;
            cell.leftVideoButton.hidden = YES;
            cell.rightVideoButton.hidden = YES;
            cell.leftPicImage.image = chatItem.picImage;
            cell.rightPicImage.hidden = YES;
            cell.leftPicImage.hidden = NO;
        }
        else if(chatItem.states == textStates)
        {
            cell.rightPicImage.hidden = YES;
            cell.leftPicImage.hidden = YES;
            cell.rightView.hidden = YES;
            cell.lefeView.hidden = NO;
            cell.leftVideoButton.hidden = YES;
            cell.rightVideoButton.hidden = YES;
            cell.leftLabel.frame = CGRectMake(15, 5, size.width, size.height);
            cell.lefeView.frame = CGRectMake(40, 5, size.width +30, size.height + 25);
            cell.leftLabel.text = chatItem.content;
        }
        else
        {
            cell.rightView.hidden = YES;
            cell.lefeView.hidden = YES;
            cell.rightView.hidden = YES;
            cell.lefeView.hidden = YES;
            cell.leftVideoButton.hidden = NO;
            cell.rightVideoButton.hidden = YES;
            cell.leftVideoButton.tag = 300 + indexPath.row;
            [cell.leftVideoButton setImage:[UIImage imageNamed:@"record.png"] forState:UIControlStateNormal];
            [cell.leftVideoButton addTarget:self action:@selector(cellSelectIndex:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return cell;
}

- (void)cellSelectIndex:(UIButton *)cellBtn
{
    ChatItem *chatIden = [self.datasource objectAtIndex:cellBtn.tag - 300];
    if(chatIden.states == videoStates)
    {
    NSLog(@"realy play");
//    [self makeVideoPlayer:[self getVideoStremData]];
    [self makeVideoPlayer:chatIden.recordData];
    }
}


#pragma mark - MCSession
/***************************-------**********************************************/
- (void)makeBlueData
{
    __weak typeof (self) weakSelf = self;
    self.datasource = [NSMutableArray arrayWithCapacity:0];

    self.sessionManager = [[BlueSessionManager alloc]initWithDisplayName:[NSString stringWithFormat:@" %@",  [[UIDevice currentDevice] name]]];

    [self.sessionManager didReceiveInvitationFromPeer:^void(MCPeerID *peer, NSData *context) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"buzhidao" message:[NSString stringWithFormat:@"%@%@", peer.displayName, @"aa"] delegate:strongSelf cancelButtonTitle:@"aa" otherButtonTitles:@"aa", nil];
        [alertView show];
    }];

    [self.sessionManager peerConnectionStatusOnMainQueue:YES block:^(MCPeerID *peer, MCSessionState state) {
        if(state == MCSessionStateConnected) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"sda" message:[NSString stringWithFormat:@"ss%@", peer.displayName] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ss", nil];
            [alertView show];
        }
    }];

    [self.sessionManager receiveDataOnMainQueue:YES block:^(NSData *data, MCPeerID *peer) {
        
        __strong typeof (weakSelf) strongSelf = weakSelf;
        NSString *string = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        ChatItem * chatItem = [[ChatItem alloc] init];
        chatItem.isSelf = NO;
        chatItem.states = textStates;
        chatItem.content = string;
        [strongSelf.datasource addObject:chatItem];
        [strongSelf insertTheTableToButtom];
    }];

    [self.sessionManager receiveFinalResourceOnMainQueue:YES complete:^(NSString *name, MCPeerID *peer, NSURL *url, NSError *error) {

        __strong typeof (weakSelf) strongSelf = weakSelf;
        NSData *data = [NSData dataWithContentsOfURL:url];

        ChatItem * chatItem = [[ChatItem alloc] init];
        chatItem.isSelf = NO;
        chatItem.states = picStates;
        chatItem.content = name;
        chatItem.picImage = [UIImage imageWithData:data];
        [strongSelf.datasource addObject:chatItem];
        [strongSelf insertTheTableToButtom];
    }];

    [self.sessionManager didReceiveStreamFromPeer:^(NSInputStream *stream, MCPeerID *peer, NSString *streamName) {
        
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.inputStream = stream;
        strongSelf.inputStream.delegate = self;
        [strongSelf.inputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        [strongSelf.inputStream open];
        NSLog(@"we need");
    }];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.sessionManager connectToPeer:buttonIndex == 1];
}

#pragma mark -
/***********---------------------------------------------***********************************/

- (void)videoRecord
{
    [self SetTempRecordView];
}


- (void)sendAsStream
{
    if(!self.sessionManager.isConnected)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"尚无连接设备" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }

    NSError *err;
    self.outputStream = [self.sessionManager streamWithName:@"super stream" toPeer:self.sessionManager.firstPeer error:&err];
    self.outputStream.delegate = self;
    [self.outputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    if(err || !self.outputStream) {
        NSLog(@"%@", err);
    }
    else
    {

        [self.outputStream open];
    }
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{

    if(eventCode == NSStreamEventHasBytesAvailable)
    {

        NSInputStream *input = (NSInputStream *)aStream;
        uint8_t buffer[1024];
        NSInteger length = [input read:buffer maxLength:1024];
        [self.streamData appendBytes:(const void *)buffer length:(NSUInteger)length];
    }
    else if(eventCode == NSStreamEventHasSpaceAvailable)
    {
        NSData *data = [self getVideoStremData];
        ChatItem * chatItem = [[ChatItem alloc] init];
        chatItem.isSelf = YES;
        chatItem.states = videoStates;
        chatItem.recordData = data;

        [self.datasource addObject:chatItem];
        [self insertTheTableToButtom];

        NSOutputStream *output = (NSOutputStream *)aStream;
        [output write:data.bytes maxLength:data.length];
        [output close];
    }
    if(eventCode == NSStreamEventEndEncountered)
    {
        ChatItem * chatItem = [[ChatItem alloc] init];
        chatItem.isSelf = NO;
        chatItem.states = videoStates;
        chatItem.recordData = self.streamData;

        [self.datasource addObject:chatItem];
        [self insertTheTableToButtom];

        [aStream close];
        [aStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        if([aStream isKindOfClass:[NSInputStream class]])
        {
            self.streamData = nil;
        }
    }
    if(eventCode == NSStreamEventErrorOccurred)
    {
        NSLog(@"error");
    }
}

- (NSMutableData *)streamData
{
    if(!_streamData) {
        _streamData = [NSMutableData data];
    }
    return _streamData;
}

/***********-------------------------------------------***********************************/

- (NSData *)imageData
{
    return [NSData dataWithContentsOfURL:[self imageURL]];
}

- (NSURL *)imageURL {
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"301-alien-ship@2x" ofType:@"png"];
    NSURL *url = [NSURL fileURLWithPath:path];
    return url;
}

/***********----------------------------------------------***********************************/
#pragma mark -

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [[event allTouches] anyObject];
    if(touch.tapCount >= 1)
    {
        [self.sendTextView resignFirstResponder];
    }
}


/***********----------------------------------------------***********************************/

#pragma mark -

- (void)buildVideoForWe
{
    [self setAudioSession];
}

- (void)SetTempRecordView
{
    _backRemindRecordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 150)];
    _backRemindRecordView.center = self.view.center;
    _backRemindRecordView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_backRemindRecordView];
    
    UILabel * beginLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 50, WIDTH -120, 50)];
    beginLabel.backgroundColor = [UIColor greenColor];
    beginLabel.text = @"长按说话";
    beginLabel.tag = 1001;
    beginLabel.textAlignment = NSTextAlignmentCenter;
    beginLabel.userInteractionEnabled = YES;
    [_backRemindRecordView addSubview:beginLabel];

    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressNextDo:)];
    [beginLabel addGestureRecognizer:longPress];
}

- (void)longPressNextDo:(UILongPressGestureRecognizer * )longPress
{
    if(longPress.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"开始录音");
        UILabel * label = (UILabel *)[_backRemindRecordView viewWithTag:1001];
        label.text = @"请说话";
        label.backgroundColor = [UIColor orangeColor];
        [self BeginRecordClick];
    }
    if(longPress.state == UIGestureRecognizerStateEnded)
    {
        [self OkStopClick];
        [_backRemindRecordView removeFromSuperview];
        [self  sendAsStream];
        NSLog(@"停止录音");

    }
}


#pragma mark -

-(void)setAudioSession
{
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
}

- (NSURL *)getSavePath
{
    NSString *urlStr=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    urlStr=[urlStr stringByAppendingPathComponent:kRecordAudioFile];
    NSLog(@"file path:%@",urlStr);
    NSURL *url=[NSURL fileURLWithPath:urlStr];
    return url;
}

- (NSData *)getVideoStremData
{
    return [NSData dataWithContentsOfURL:[self getSavePath]];
}

- (NSDictionary *)getAudioSetting {
    
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    [dicM setObject:@(8000) forKey:AVSampleRateKey];
    [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];
    [dicM setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    return dicM;
}

-(AVAudioRecorder *)audioRecorder
{
    if (!_audioRecorder) {
        
        NSURL *url=[self getSavePath];
        NSDictionary *setting=[self getAudioSetting];
        NSError *error=nil;
        _audioRecorder=[[AVAudioRecorder alloc]initWithURL:url settings:setting error:&error];
        _audioRecorder.delegate=self;
        _audioRecorder.meteringEnabled=YES;
        if (error) {
            NSLog(@"shenme%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioRecorder;
}

- (void)makeVideoPlayer:(NSData *)data
{
    NSError *error=nil;
    self.audioPlayer=[[AVAudioPlayer alloc]initWithData:data error:&error];
    self.audioPlayer.delegate = self;
    self.audioPlayer.numberOfLoops=0;
    [self.audioPlayer prepareToPlay];
    if (error)
    {
        NSLog(@"ok%@",error.localizedDescription);
    }
    else
    {
        if (![self.audioPlayer isPlaying]) {
            NSLog(@"play");
            [self.audioPlayer play];
        }
    }
}

-(NSTimer *)timer {
    
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(audioPowerChange) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)audioPowerChange {
    
    [self.audioRecorder updateMeters];
    float power= [self.audioRecorder averagePowerForChannel:0];
    CGFloat progress=(1.0/160.0)*(power+160.0);
    [self.audioPower setProgress:progress];
}

#pragma mark - UI

- (void)BeginRecordClick
{
    if (![self.audioRecorder isRecording])
    {
        [self.audioRecorder record];
        self.timer.fireDate=[NSDate distantPast];
    }
}

- (void)StopPauseClick
{
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder pause];
        self.timer.fireDate=[NSDate distantFuture];
    }
}

- (void)OkStopClick
{
    [self.audioRecorder stop];
    self.timer.fireDate=[NSDate distantFuture];
    self.audioPower.progress=0.0;
}

#pragma mark -

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
//    if (![self.audioPlayer isPlaying]) {
//        [self.audioPlayer play];
//    }
    NSLog(@"录音成功");
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    player =nil;
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
