//
//  ViewController.m
//  DDModel
//
//  Created by Diaoshu on 15-2-4.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import "ViewController.h"
#import "Post.h"

@interface ViewController (){
    NSMutableArray *dataList;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if(!dataList)
        dataList = [[NSMutableArray alloc] initWithCapacity:0];
    [Post getPostList:nil
             parentVC:self
              showHUD:YES
              success:^(id data) {
                  NSLog(@"data = %@",data);
                  [dataList removeAllObjects];
                  [dataList addObjectsFromArray:data];
                  [self.tableView reloadData];
              }
              failure:^(NSError *error, NSString *message) {
              }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    Post *p = dataList[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@-%@",p.user.username,p.text];
    return cell;
}

@end
