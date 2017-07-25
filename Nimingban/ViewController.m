//
//  ViewController.m
//  Nimingban
//
//  Created by QinJ on 2017/6/26.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//
//  TODO:没有做页码统计,一般没人翻到最后一页的,添加跳页功能的时候再处理

#import "ViewController.h"
#import "QJNMBListMainPoCell.h"
#import "QJNMBListReplyCell.h"
#import "QJNMBListModel.h"
#import "QJHTTPOperation.h"
#import "QJEnum.h"
#import "QJBigImageShowView.h"
#import "QJSideContainerController.h"
//详情
#import "QJInfoNewViewController.h"

#import "LWActiveIncator.h"
#import "QJFootTipView.h"

#import "QJImageBrowserViewController.h"

static const CGFloat kSectionSpace = 10.f;

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,QJNMBListMainPoCellDelagate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<QJNMBListModel *> *datas;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) QJFreshStatus state;
@property (nonatomic, strong) NSString *idf;
@property (nonatomic, strong) UIRefreshControl *refreshC;
@property (nonatomic, assign) ViewControllerType type;
@property (nonatomic, strong) QJFootTipView *footView;
@property (nonatomic, strong) UIBarButtonItem *item;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [LWActiveIncator showInView:self.view isFullScreen:YES];
    [self setContent];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.fatherVC.canDragSide = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.fatherVC.canDragSide = NO;
}

- (void)setContent {
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStyleDone target:self action:@selector(showSideMenu)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.pageIndex = 1;
    self.state = QJFreshStatusNone;
    //tableview
    [self.view addSubview:self.tableView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_tableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
}

- (void)showSideMenu {
    [self.fatherVC showSideView];
}

- (void)updateResourceWithNewId:(NSString *)idF title:(NSString *)title type:(ViewControllerType)type {
    if (self.datas.count) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }
    self.type = type;
    self.state = QJFreshStatusRefresh;
    self.title = title;
    self.idf = idF;
    self.pageIndex = 1;
    [LWActiveIncator showInView:self.view isFullScreen:YES];
    [self updateResource];
}

- (void)refreshStateChange {
    if ([self.refreshC isRefreshing]) {
        self.state = QJFreshStatusRefresh;
    }
}

- (void)updateResource {
    NSDictionary *params = nil;
    NSString *url = @"";
    if (self.type == ViewControllerTypeLike) {
        params = @{
                   @"page":@(self.pageIndex)
                   };
        url = @"/feed";
    }
    else if (self.type == ViewControllerTypeNormal){
        params = @{
                   @"id":self.idf,
                   @"page":@(self.pageIndex)
                   };
        url = @"/showf";
    }
    else if (self.type == ViewControllerTypeTimeLine){
        params = @{
                   @"page":@(self.pageIndex)
                   };
        url = @"/timeline";
    }
    
    [QJHTTPOperation getRequestWithURL:url params:params success:^(id responseObject) {
        if (self.state == QJFreshStatusRefresh) {
            [self.datas removeAllObjects];
        }
        NSArray *array = (NSArray *)responseObject;
        if (array.count) {
            for (NSDictionary *dict in array) {
                QJNMBListModel *model = [QJNMBListModel modelWithDict:dict isList:YES];
                [self.datas addObject:model];
            }
            [self.tableView reloadData];
        }
        self.state = array.count ? QJFreshStatusNone : QJFreshStatusNoNeed;
        self.tableView.tableFooterView = array.count ? [UIView new] : self.footView;
        if ([self.refreshC isRefreshing]) {
            [self.refreshC endRefreshing];
        }
        [LWActiveIncator hideInViwe:self.view];
    } failure:^(NSError *error) {
        self.pageIndex--;
        self.state = QJFreshStatusNone;
        [LWActiveIncator hideInViwe:self.view];
    }];
}

#pragma mark -QJNMBListMainPoCellDelagate
- (void)clickImageViewWIthImage:(UIImage *)image bigImageUrl:(NSString *)bigUrl {
    [QJBigImageShowView showBrowerWithThumb:image bigImageUrl:bigUrl withContrller:self];
}

#pragma mark -tableView协议
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == self.datas.count - 1 ? 0.1f :kSectionSpace;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas[section].replyArr.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QJNMBListModel *model = self.datas[indexPath.section];
    if (indexPath.row) {
        QJNMBListReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QJNMBListReplyCell class])];
        
        [cell refreshUI:model.replyArr[indexPath.row - 1]];
        return cell;
    } else {
        QJNMBListMainPoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QJNMBListMainPoCell class])];
        [cell refreshUI:model];
        if (!cell.delegate) {
            cell.delegate = self;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QJNMBListModel *model = self.datas[indexPath.section];
    QJInfoNewViewController *vc = [QJInfoNewViewController new];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.type == ViewControllerTypeLike ? YES : NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    QJNMBListModel *model = self.datas[indexPath.section];
    [self deleteLikeWithModel:model];
    [self.datas removeObject:model];
    [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]
             withRowAnimation:UITableViewRowAnimationFade];
}

- (void)deleteLikeWithModel:(QJNMBListModel *)model {
    NSDictionary *params = @{
                             @"tid":model.idC
                             };
    [QJHTTPOperation getRequestWithURL:@"/delFeed" params:params success:^(id responseObject) {
        [QJToast showWithTip:@"取消订阅成功"];
    } failure:^(NSError *error) {
        [QJToast showWithTip:@"取消订阅失败"];
    }];
}

#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //预加载
    CGFloat current = scrollView.contentOffset.y + scrollView.frame.size.height;
    CGFloat total = scrollView.contentSize.height;
    CGFloat ratio = current / total;
    
    CGFloat needRead = 19 * 0.7 + (self.pageIndex - 1) * 19;
    CGFloat totalItem = 19 * self.pageIndex;
    CGFloat newThreshold = needRead / totalItem;
    
    if (self.datas.count && ratio >= newThreshold && self.state == QJFreshStatusNone) {
        self.state = QJFreshStatusMore;
        self.pageIndex++;
        NSLog(@"Request page %ld from server.",self.pageIndex);
        [self updateResource];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.refreshC isRefreshing] && self.state == QJFreshStatusRefresh) {
        self.pageIndex = 1;
        [self updateResource];
    }
}

#pragma mark -getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 5 * 42;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([QJNMBListMainPoCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([QJNMBListMainPoCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([QJNMBListReplyCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([QJNMBListReplyCell class])];
        
        [_tableView addSubview:self.refreshC];
    }
    return _tableView;
}

- (NSMutableArray<QJNMBListModel *> *)datas {
    if (!_datas) {
        _datas = [NSMutableArray new];
    }
    return _datas;
}

- (UIRefreshControl *)refreshC {
    if (!_refreshC) {
        _refreshC = [UIRefreshControl new];
        [_refreshC addTarget:self action:@selector(refreshStateChange) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshC;
}

- (QJFootTipView *)footView {
    if (!_footView) {
        _footView = [QJFootTipView new];
    }
    return _footView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
