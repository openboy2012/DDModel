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
#import "AFHTTPSessionManager+DDModel.h"
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
    BOOL isChanged;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if(!dataList)
        dataList = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.tableView.estimatedRowHeight = 100;
    
    NSLog(@"url = %@",[DDModelHttpClient sharedInstance].baseURL);
    [BESTItemListRoot getItemList:@{@"sortBy":@"recommend",@"keyword":@"coach"} showHUD:YES parentViewController:self
                          success:^(BESTItemListRoot *data) {
                              NSLog(@"data.size = %i",(int)data.count);
                              
                              NSLog(@"data = %@",data);
                              [dataList removeAllObjects];
                              [dataList addObjectsFromArray:data.list];
                              [self.tableView reloadData];
                              
                              
                          } failure:^(NSError *error, NSString *message, id data) {
                              NSLog(@"error = %@ message = %@",error, message);
                          }];

#if UseXMLDemo


#else
//    [Post getPostList:nil
//             parentVC:self
//              showHUD:YES
//              success:^(id data) {
//                  NSLog(@"data = %@",data);
//                  [dataList removeAllObjects];
//                  [dataList addObjectsFromArray:data];
//                  [self.tableView reloadData];
//              }
//              failure:^(NSError *error, NSString *message) {
//              }];
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
    if([[DDModelHttpClient sharedInstance].baseURL.absoluteString hasPrefix:@"http://mapi.bstapp"]){
//        Station *s = dataList[indexPath.row];
        BESTItemList *item = dataList[indexPath.row];
        cell.lblTitle.text = [NSString stringWithFormat:@"%@-%@",item.title,item.image];
    }else{
        Post *p = dataList[indexPath.row];
        [cell setPost:p];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:@"PostCell"
                                    cacheByIndexPath:indexPath
                                       configuration:^(PostCell *cell) {
                                           if([[DDModelHttpClient sharedInstance].baseURL.absoluteString hasPrefix:@"http://mapi.bstapp"]){
                                               BESTItemList *item = dataList[indexPath.row];
                                               cell.lblTitle.text = [NSString stringWithFormat:@"%@-%@",item.title,item.image];
                                           }else{
                                               Post *p = dataList[indexPath.row];
                                               [cell setPost:p];
                                           }
                                       }];;
}

- (IBAction)changeURL:(id)sender{
//    [[DDModelHttpClient sharedInstance] dd_addUrl:@"http://prov.mobile.arnd.fm"];
//    [DDModelHttpClient sharedInstance].type = DDResponseXML;
//    NSLog(@"url = %@",[DDModelHttpClient sharedInstance].baseURL);
//    NSDictionary *params = @{@"q":@"admin/station/station/bygroupid",
//                             @"id":@(5)};
//    [Station getStationList:params
//                   parentVC:self
//                    showHUD:YES
//                  dbSuccess:^(id data){
//                      NSLog(@"data = %@",data);
//                  }
//                    success:^(id data) {
//                        NSLog(@"data = %@",data);
//                        [dataList removeAllObjects];
//                        [dataList addObjectsFromArray:data];
//                        [self.tableView reloadData];
//                    }
//                    failure:^(NSError *error, NSString *message) {
//                        NSLog(@"error = %@ message = %@",error, message);
//                    }];
    
    if(!isChanged){
        [[DDModelHttpClient sharedInstance] dd_addURL:@"https://api.app.net/"];
        NSLog(@"url = %@",[DDModelHttpClient sharedInstance].baseURL);
        [Post getPostList:nil
                 parentVC:self
                  showHUD:YES
                  success:^(id data) {
                      NSLog(@"data = %@",data);
                      [dataList removeAllObjects];
                      [dataList addObjectsFromArray:data];
                      [self.tableView reloadData];
                  }
                  failure:^(NSError *error, NSString *message, id data) {
                  }];
    }else{
        [[DDModelHttpClient sharedInstance] dd_addURL:@"http://mapi.bstapp.cn"];
        NSLog(@"url = %@",[DDModelHttpClient sharedInstance].baseURL);
        [BESTItemListRoot getItemList:@{@"sortBy":@"recommend",@"keyword":@"coach"} showHUD:YES parentViewController:self
                              success:^(BESTItemListRoot *data) {
                                  NSLog(@"data.size = %i",(int)data.count);
                                  
                                  NSLog(@"data = %@",data);
                                  [dataList removeAllObjects];
                                  [dataList addObjectsFromArray:data.list];
                                  [self.tableView reloadData];
                                  
                                  
                              } failure:^(NSError *error, NSString *message, id data) {
                                  NSLog(@"error = %@ message = %@",error, message);
                              }];
    }
    isChanged = !isChanged;
}

@end
