//
//  BTSearchHistoryViewController.m
//  Bullet
//
//  Created by 钟奇龙 on 16/9/19.
//  Copyright © 2016年 com.developer.jaccob. All rights reserved.
//

#import "BTSearchHistoryViewController.h"
#import "BTSearchHistoryCell.h"
@interface BTSearchHistoryViewController ()<BTSearchHistoryCellDelegate>

@property (nonatomic,strong) UIButton *clearHistoryButton;

@end

@implementation BTSearchHistoryViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _clearHistoryButton = [[UIButton alloc] init];
    _clearHistoryButton.frame = CGRectMake(0, 0, UIScreenWidth, 44);
    _clearHistoryButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_clearHistoryButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
//    _clearHistoryButton.titleLabel.textColor = [UIColor blackColor];
    [_clearHistoryButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_clearHistoryButton setTitle:@"清除搜索历史" forState:UIControlStateNormal];
    [_clearHistoryButton addTarget:self action:@selector(clearSearchHistory) forControlEvents:UIControlEventTouchUpInside];
    
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"searchHistoryArray"]) {
        NSArray *tempArray  = [[NSUserDefaults standardUserDefaults]objectForKey:@"searchHistoryArray"];
        self.searchHistoryArray = [NSMutableArray arrayWithArray:tempArray];
    }
    
    
    
  
    
   
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

      [self.tableView reloadData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    
    
    
    return self.searchHistoryArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"historyCell";
    BTSearchHistoryCell *cell = [BTSearchHistoryCell cellWithTableView:tableView andIdentifier:cellId];
    
    cell.historyName = self.searchHistoryArray[indexPath.row];
    cell.tag = indexPath.row;
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(searchHistoryCellDidClicked:)]) {
        [self.delegate searchHistoryCellDidClicked:self.searchHistoryArray[indexPath.row]];
    }
}






- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
//    UIView *coverView = [[UIView alloc ]initWithFrame:CGRectMake(0, 0, UIScreenWidth, 44)];
//    coverView.backgroundColor = [UIColor blackColor];
//    [coverView addSubview:_clearHistoryButton];
//
        if (self.searchHistoryArray.count > 4) {
            return  _clearHistoryButton;

        }else{
            return nil;
        }
}

- (void)clearSearchHistory
{
    [self.searchHistoryArray removeAllObjects];
    [[NSUserDefaults standardUserDefaults]setObject:self.searchHistoryArray forKey:@"searchHistoryArray"];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.searchHistoryArray.count > 4) {
        return  44;
        
    }else{
        return 0;
    }
 
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//   
//}

- (void)deleteHistoryCellWithTag:(NSUInteger)tag
{
    NSArray *visibleCells = [self.tableView visibleCells];
    for (BTSearchHistoryCell *cell in visibleCells) {
        if (cell.tag == tag) {
            [self.searchHistoryArray removeObjectAtIndex:tag];
            [[NSUserDefaults standardUserDefaults]setObject:self.searchHistoryArray forKey:@"searchHistoryArray"];
            [self.tableView reloadData];
            break;
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
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
