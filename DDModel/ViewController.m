//
//  ViewController.m
//  DDModel
//
//  Created by DeJohn Dong on 15-2-4.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import "ViewController.h"
#import "Post.h"
#import "AppDelegate.h"
#import <UITableView+FDTemplateLayoutCell.h>

@interface PostCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lblTitle;

- (void)setPost:(Post *)post;

@end

@implementation PostCell

- (void)setPost:(Post *)post{
    self.lblTitle.text = [NSString stringWithFormat:@"%@-%@",post.user.username,post.text];
}

@end

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
    
    self.tableView.estimatedRowHeight = 100;
#if UseXMLDemo

    NSDictionary *params = @{@"q":@"admin/station/station/bygroupid",
                             @"id":@(10)};
    [Station getStationList:params
                   parentVC:self
                    showHUD:YES
                  dbSuccess:^(id data){
                      NSLog(@"data = %@",data);
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
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell" forIndexPath:indexPath];
#if UseXMLDemo
    Station *s = dataList[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@-%@",s.name,s.desc];
#else
    Post *p = dataList[indexPath.row];
    [cell setPost:p];
#endif
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:@"PostCell"
                                    cacheByIndexPath:indexPath
                                       configuration:^(PostCell *cell) {
                                           Post *p = dataList[indexPath.row];
                                           [cell setPost:p];
                                       }];;
}

@end
