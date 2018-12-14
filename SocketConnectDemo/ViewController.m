//
//  ViewController.m
//  SocketConnectDemo
//
//  Created by hyz on 2018/12/12.
//  Copyright © 2018 hyz. All rights reserved.
//

#import "ViewController.h"
#import "IMNWManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[IMNWManager sharedNWManager] initSocketConnect];
}

- (IBAction)btnConnectTouchUpInside:(UIButton *)sender {
    [[IMNWManager sharedNWManager].socketConnect connect];
    
}

@end
