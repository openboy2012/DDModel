//
//  ViewController.m
//  DDModel
//
//  Created by Diaoshu on 15-2-4.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import "ViewController.h"
#import "Post.h"
#import "AppDelegate.h"

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
#if UseXMLDemo

    NSDictionary *params = @{@"q":@"admin/station/station/bygroupid",
                             @"id":@(10)};
    [Station getStationList:params
                   parentVC:self
                    showHUD:YES
                  dbSuccess:^(id data){
                      NSLog(@"data = %@",data);
                      [dataList removeAllObjects];
                      [dataList addObjectsFromArray:data];
                      [self.tableView reloadData];
                  }
                    success:^(id data) {
                        NSLog(@"data = %@",data);
                        [dataList removeAllObjects];
                        [dataList addObjectsFromArray:data];
                        [self.tableView reloadData];
                    }
                    failure:^(NSError *error, NSString *message) {
                    }];
#else
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
#endif
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
#if UseXMLDemo
    Station *s = dataList[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@-%@",s.name,s.desc];
#else
    Post *p = dataList[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@-%@",p.user.username,p.text];
#endif
    return cell;
}

@end
