//
//  UToMsgViewController.m
//  BlueTalk
//
//  Created by Weighter on 2017/9/20.
//  Copyright © 2017年 Weighter. All rights reserved.
//

#import "UToMsgViewController.h"

@interface UToMsgViewController ()

@end

@implementation UToMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBarItem.badgeValue = @"1";
    [self performSelector:@selector(test) withObject:nil afterDelay:5.0];
}

- (void)test {
    
    self.tabBarItem.badgeValue = @"0";
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
