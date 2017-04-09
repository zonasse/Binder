//
//  BTBookBrowserViewController.m
//  Binder
//
//  Created by 钟奇龙 on 17/4/2.
//  Copyright © 2017年 com.developer.jaccob. All rights reserved.
//

#import "BTBookBrowserViewController.h"
#import "BTBookBrowser.h"
#import "BTChapter.h"

@interface  BTBookBrowserViewController()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITextView *contentTextView;
@property (nonatomic,strong) UILabel *pageInfoLabel;
@property (nonatomic,strong) UISlider *pageSlider;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UITableView *chapterListTableView;
@property (nonatomic,assign) BOOL isReading;
@property (nonatomic,assign) BOOL isChoosingChapter;
@end

@implementation BTBookBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isReading = YES;
    _isChoosingChapter = NO;
   
    

    
    //初始化视图
    //顶部导航条
    
    UIBarButtonItem *chapterItem = [[UIBarButtonItem alloc] initWithTitle:@"章节" style:UIBarButtonItemStylePlain target:self action:@selector(displayChapters)];
    self.title = self.browser.book.title;
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeBack)];
    
    self.navigationItem.leftBarButtonItem = chapterItem;
    self.navigationItem.rightBarButtonItem = closeItem;
    //底部工具条
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, UIScreenHeight-84, UIScreenWidth, 84)];
    bottomView.backgroundColor = [UIColor blackColor];
    bottomView.alpha = 0.5;
    _bottomView = bottomView;
    
    UILabel *pageInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.5*(UIScreenWidth - 80), 0, 80, 20)];
    pageInfoLabel.text = @"300/883";
    pageInfoLabel.backgroundColor = [UIColor redColor];
    _pageInfoLabel = pageInfoLabel;
    
    UISlider *pageSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(pageInfoLabel.frame)+5, UIScreenWidth, 15)];
    pageSlider.maximumValue = 1.0;
    pageSlider.minimumValue = 0.0;
    pageSlider.value = 0.5;
    _pageSlider = pageSlider;
    
    [bottomView addSubview:pageInfoLabel];
    [bottomView addSubview:pageSlider];
    
//    [self.view addSubview:bottomView];
    
    //初始化章节列表视图
    self.chapterListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame)+20, UIScreenWidth * 0.5, UIScreenHeight - bottomView.height - self.navigationController.navigationBar.height - 20) style:UITableViewStylePlain];
    self.chapterListTableView.delegate = self;
    self.chapterListTableView.dataSource = self;
}
- (void)displayChapters
{
    if(!_isChoosingChapter)
    {
        [self.view addSubview:_chapterListTableView];
        [self.chapterListTableView reloadData];
        
    }else{
        [self.chapterListTableView removeFromSuperview];
    }
    _isChoosingChapter = !_isChoosingChapter;

}
- (void)closeBack
{
    [self dismissViewControllerAnimated:YES completion:^{
        //保存数据到持久层
//        [self saveContext];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.browser.chapters.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"chapterCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    BTChapter *chapter = self.browser.chapters[indexPath.row];
    cell.textLabel.text = chapter.title;
    
    return cell;
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(_isChoosingChapter)
    {
        [self.chapterListTableView removeFromSuperview];
        _isChoosingChapter = !_isChoosingChapter;
    }
    CGPoint point = [[touches anyObject]locationInView:self.view];
    if( CGRectContainsPoint(CGRectMake(_bottomView.x, _bottomView.y, _bottomView.width, _bottomView.height), point) )
    {
        if(_isReading)
        {
            [self.view addSubview:_bottomView];
            _isReading = !_isReading;
        }
        
    }else{
        if(!_isReading)
        {
            [_bottomView removeFromSuperview];
            _isReading = !_isReading;
        }
    }
}
//- (void)insertCoreData
//{
//    NSManagedObjectContext *context = [self managedObjectContext];
//    NSManagedObject *bookBrowser = [NSEntityDescription insertNewObjectForEntityForName:@"BookBrowser" inManagedObjectContext:context];
//    [bookBrowser setValue:[NSNumber numberWithInt: _browser.currentPage ] forKey:@"currentPage"];
//    [bookBrowser setValue:[NSNumber numberWithInt: _browser.totalPages ] forKey:@"totalPages"];
//     [bookBrowser setValue:[NSNumber numberWithFloat: _browser.fontSize ] forKey:@"fontSize"];
//    
//    NSManagedObject *Chapter = [NSEntityDescription insertNewObjectForEntityForName:@"Chapter" inManagedObjectContext:context];
////    Chapter setValue: forKey:@"allContentRange"
//}
//- (NSManagedObjectContext *)managedObjectContext
//{
//    if (_managerObjectContext != nil) {
//        return _managerObjectContext;
//    }
//    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
//    if (coordinator != nil) {
//        _managerObjectContext = [[NSManagedObjectContext alloc] init];
//        [_managerObjectContext setPersistentStoreCoordinator:coordinator];
//    }
//    return _managerObjectContext;
//}
//- (NSManagedObjectModel *)managedObjectModel
//{
//    if (_managedObjectModel != nil) {
//        return _managedObjectModel;
//    }
//    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"bookBrowser" withExtension:@"momd"];
//    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
//    return _managedObjectModel;
//}
//- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
//{
//    if (_persistentStoreCoordinator != nil) {
//        return _persistentStoreCoordinator;
//    }
//    NSURL *storeURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"bookBrowser.sqlite"];
//    
//    NSError *error = nil;
//    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
//    
//    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
//    return _persistentStoreCoordinator;
//}
//
//- (void)saveContext
//{
//    NSError *error = nil;
//    NSManagedObjectContext *managedObjectContext = self.managerObjectContext;
//    if(managedObjectContext != nil)
//    {
//        if([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
//        {
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
//        }
//    }
//}

@end
