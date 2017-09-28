//
//  UToLinkmanViewController.m
//  BlueTalk
//
//  Created by Weighter on 2017/9/20.
//  Copyright © 2017年 Weighter. All rights reserved.
//

#import "UToLinkmanViewController.h"
#import "UToConversationViewController.h"
#import "UToBlueSessionManager.h"
#import "AppDelegate.h"

@interface UToLinkmanViewController () <UITableViewDelegate, UITableViewDataSource, UToMessageUpdateDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation UToLinkmanViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    utoDelegate.rdelegate = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"right_menu_addFri"] style:UIBarButtonItemStylePlain target:self action:@selector(addContacts)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"打开天线" style:UIBarButtonItemStyleDone target:self action:@selector(showSelfAdvertiser)];
    [self.tableView reloadData];
}

- (void)addContacts {
    
    [get_singleton_for_class(UToBlueSessionManager) browseWithControllerInViewController:self connected:^{
        
        NSLog(@"connected");
    } canceled:^{
        
        NSLog(@"cancelled");
    }];
}

- (void)showSelfAdvertiser {
    
    [get_singleton_for_class(UToBlueSessionManager) advertiseForBrowserViewController];
}

- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)peerConnectionStatusChange:(MCPeerID *)peer state:(MCSessionState)state {
    
    self.dataArray =  [get_singleton_for_class(UToBlueSessionManager).connectedPeers mutableCopy];
    [self.tableView reloadData];
}

#pragma mark - tableView

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.sectionHeaderHeight = 0.01;
        _tableView.sectionFooterHeight = 0.01;
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(@(0));
            make.right.mas_equalTo(@(0));
            make.top.mas_equalTo(@(0));
            make.bottom.mas_equalTo(@(0));
        }];
    }
    
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellIdentifier"];
    if(cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCellIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone; // 让后面选中的没有阴影效果
    }
    
    MCPeerID *peerId = [self.dataArray objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"qq_addfriend_search_friend"];
    cell.textLabel.text = peerId.displayName;
    cell.detailTextLabel.text = @"新消息";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MCPeerID *peerId = [self.dataArray objectAtIndex:indexPath.row];
    UToConversationViewController *cvc = [[UToConversationViewController alloc] init];
    cvc.peerId = peerId;
    cvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cvc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44.;
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
