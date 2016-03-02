//
//  themesTableViewController.m
//  My微博
//
//  Created by Macx on 16/1/12.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "themesTableViewController.h"
#import "MainTabBarCtrl.h"

@interface themesTableViewController ()

@end

@implementation themesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"主题选择";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellIdentity"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _themeArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentity" forIndexPath:indexPath];
    
    NSString *theme =  _themeArr[indexPath.item];
    cell.textLabel.text = theme;
    cell.contentView.backgroundColor = [[ThemeManager sharedThemeManager] getThemeColor];
    cell.imageView.image = [self getThemeIcon:theme];
    cell.textLabel.textColor = [UIColor blackColor];
    
    return cell;
}

- (UIImage *)getThemeIcon:(NSString *)theme {
    //获取主包路径
    NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
    NSString *imgPath = [bundlePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/ref_log", theme]];
    return [UIImage imageWithContentsOfFile:imgPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ThemeManager *manager = [ThemeManager sharedThemeManager];
    
    manager.themeName = _themeArr[indexPath.item];
}

- (void)viewWillAppear:(BOOL)animated {
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
