//
//  QJInfoNewViewController.m
//  Nimingban
//
//  Created by QinJ on 2017/7/5.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import "QJInfoNewViewController.h"
#import "QJNMBListModel.h"
#import "QJBigImageShowView.h"
#import "LWActiveIncator.h"
#import "QJNMBInfoCell.h"
#import "QJFootTipView.h"
#import "QJHTTPOperation.h"
#import "QJNMBInfoJumpInputView.h"
#import "QJTableView.h"
#import "QJReplyViewController.h"

@interface QJInfoNewViewController ()<UITableViewDelegate,UITableViewDataSource,QJNMBInfoCellDelagate,UITextFieldDelegate,QJNMBInfoJumpInputViewDelagate,QJReplyViewControllerDelagate>

//tabbar
@property (nonatomic, strong) QJNMBInfoJumpInputView *cusInputView;
//内容
@property (weak, nonatomic) IBOutlet UIView *tableViewBgView;
@property (weak, nonatomic) IBOutlet QJTableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) QJFootTipView *footView;
//数据
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger upPageIndex;//上拉page记录
@property (nonatomic, assign) NSInteger dowmPageIndex;//下拉page记录
@property (weak, nonatomic) IBOutlet UITextField *textF;
//背景
@property (nonatomic, strong) UIView *blackBgView;


@end

@implementation QJInfoNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setContent];
    
    [self updateResource];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)setContent {
    //标题
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"like"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain target:self action:@selector(likeAction)];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"jump"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain target:self action:@selector(jumpAction)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"post"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain target:self action:@selector(replyAction)];
    self.navigationItem.rightBarButtonItems = @[item2,item1,item];
    
    self.pageIndex = 1;
    self.upPageIndex = self.pageIndex;
    self.dowmPageIndex = self.pageIndex;
    //textfield
    self.textF.delegate = self;
    self.textF.inputAccessoryView = self.cusInputView;
    [self.textF addTarget:self action:@selector(textFChange) forControlEvents:UIControlEventAllEditingEvents];
    //tableview
    self.tableView.status = QJTableViewRefreshStatusRefresh;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 5 * 42;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([QJNMBInfoCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([QJNMBInfoCell class])];
    //tabbar
    /*
    self.pageLabel.text = [NSString stringWithFormat:@"1 / %ld", self.model.totalPages ? self.model.totalPages : 1];
    if (self.model.totalPages > 1) {
        self.tabbarHeightLine.constant = 49;
    }
     */
}

//订阅动作
- (void)likeAction {
    NSDictionary *params = @{
                             @"tid":self.model.idC
                             };
    [QJHTTPOperation getRequestWithURL:@"/addFeed" params:params success:^(id responseObject) {
        NSString *tip = (NSString *)responseObject;
        if ([tip containsString:@"成功"]) {
            [QJToast showWithTip:@"订阅成功"];
        }
        else {
            [QJToast showWithTip:@"订阅失败,或许已经订阅过了?"];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)replyAction {
    QJReplyViewController *vc = [QJReplyViewController new];
    vc.delegate = self;
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpAction {
    [self.textF becomeFirstResponder];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (self.tableView.isDragging) {
        if (self.tableView.status == QJTableViewRefreshStatusNormal || self.tableView.status == QJTableViewRefreshStatusNoNeedRefresh) {
            //根据下拉的距离判断这时候控件是否超过范围而需要刷新
            CGFloat normolPulingOffset = -80;
            if (self.tableView.contentOffset.y <= normolPulingOffset) {
                self.tableView.status = QJTableViewRefreshStatusPull;
            }
        }
    }else{
        //手松开puling->refreshing
        if (self.tableView.status == QJTableViewRefreshStatusPull) {
            //            NSLog(@"切换到Refreshing");
            self.tableView.status = QJTableViewRefreshStatusDownMore;
        }
    }
}

#pragma mark -QJReplyViewControllerDelagate
- (void)shouldRefreshUI {
    //末页刷新
    [self refreshLastUI];
}

- (void)refreshLastUI {
    self.tableView.status = QJTableViewRefreshStatusRefresh;
    self.pageIndex = self.model.totalPages;
    self.upPageIndex = self.pageIndex;
    self.dowmPageIndex = self.pageIndex;
    self.textF.text = @"";
    [self updateResource];
}

#pragma mark -QJNMBInfoJumpInputViewDelagate
- (void)didClickBtnWithTag:(NSInteger)tag {
    if (tag == 1) {
        if (self.textF.text.length == 0) {
            return;
        }
        self.tableView.status = QJTableViewRefreshStatusRefresh;
        self.pageIndex = [self.textF.text integerValue];
        self.upPageIndex = self.pageIndex;
        self.dowmPageIndex = self.pageIndex;
        self.textF.text = @"";
        [self updateResource];
    }
    else if (tag == 2) {
        //首页
        self.tableView.status = QJTableViewRefreshStatusRefresh;
        self.pageIndex = 1;
        self.upPageIndex = self.pageIndex;
        self.dowmPageIndex = self.pageIndex;
        self.textF.text = @"";
        [self updateResource];
    }
    else if (tag == 3) {
        //末页
        [self refreshLastUI];
    }
    [self closeBgView];
}

#pragma mark -QJNMBInfoCellDelagate
- (void)clickImageViewWIthImage:(UIImage *)image bigImageUrl:(NSString *)bigUrl {
    [QJBigImageShowView showBrowerWithThumb:image bigImageUrl:bigUrl withContrller:self];
}

- (void)didClickUserNoWithNumber:(NSString *)number {
    QJReplyViewController *vc = [QJReplyViewController new];
    vc.delegate = self;
    vc.model = self.model;
    if (![number isEqualToString:[NSString stringWithFormat:@"No.%@",self.model.idC]]) {
        vc.number = number;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.cusInputView.jumpTextF.placeholder = [NSString stringWithFormat:@"%ld",self.pageIndex];
    UIWindow *windows = [UIApplication sharedApplication].keyWindow;
    [windows addSubview:self.blackBgView];
    [UIView animateWithDuration:0.25f animations:^{
        self.blackBgView.alpha = 1;
    }];
}

- (void)textFChange {
    self.cusInputView.jumpTextF.text = self.textF.text;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *totalPages = [NSString stringWithFormat:@"%ld",self.model.totalPages];
    NSString *textString = [NSString stringWithFormat:@"%@%@",self.textF.text,string];
    if ([textString integerValue] == 0) {
        return NO;
    }
    if ([textString integerValue] > [totalPages integerValue]) {
        return NO;
    }
    return YES;
}

#pragma mark -请求数据
- (void)updateResource {
    NSDictionary *params = @{
                             @"id":self.model.idC,
                             @"page":@(self.pageIndex)
                             };
    [QJHTTPOperation getRequestWithURL:@"/thread" params:params success:^(id responseObject) {
        NSMutableArray *datas = [NSMutableArray new];
        NSMutableArray *tempDatas = [NSMutableArray new];
        NSDictionary *dict = (NSDictionary *)responseObject;
        QJNMBListModel *subModel = [QJNMBListModel modelWithDict:dict isList:NO];
        self.model = subModel;
        //tableview状态判断
        if (self.tableView.status == QJTableViewRefreshStatusRefresh) {
            [self.datas removeAllObjects];
        }
        else if (self.tableView.status == QJTableViewRefreshStatusDownMore) {
            tempDatas = [self.datas mutableCopy];
            [self.datas removeAllObjects];
        }
        //是否需要加入串内容的cell
        if (self.pageIndex == 1) {
            [datas addObject:self.model];
        }
        //如果存在回复
        if (self.model.replyArr.count) {
            [datas addObjectsFromArray:subModel.replyArr];
        }
        //如果是下拉刷新,重新加回缓存数据
        if (self.tableView.status == QJTableViewRefreshStatusDownMore) {
            [datas addObjectsFromArray:tempDatas];
        }
        
        [self.datas addObjectsFromArray:datas];
        [self.tableView reloadData];
        if (self.tableView.status == QJTableViewRefreshStatusRefresh && self.datas.count) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        if (self.tableView.status == QJTableViewRefreshStatusDownMore && self.datas.count) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.datas.count - tempDatas.count inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        if (self.pageIndex >= self.model.totalPages) {
            self.tableView.tableFooterView = self.footView;
            self.tableView.status = QJTableViewRefreshStatusNoNeedRefresh;
        }
        else {
            self.tableView.tableFooterView = [UIView new];
            self.tableView.status = QJTableViewRefreshStatusNormal;
        }
        self.cusInputView.totalLabel.text = [NSString stringWithFormat:@"/ %ld",self.model.totalPages];
    } failure:^(NSError *error) {
        self.tableView.status = QJTableViewRefreshStatusNormal;
    }];
}

#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //预加载
    CGFloat current = scrollView.contentOffset.y + scrollView.frame.size.height;
    CGFloat total = scrollView.contentSize.height;
    CGFloat ratio = current / total;
    
    CGFloat needRead = 19 * 0.7 + (self.datas.count - 19);
    CGFloat totalItem = self.datas.count;
    CGFloat newThreshold = needRead / totalItem;
    
    if (self.datas.count && ratio >= newThreshold && self.tableView.status == QJTableViewRefreshStatusNormal) {
        self.pageIndex = self.upPageIndex;
        self.pageIndex++;
        self.tableView.status = QJTableViewRefreshStatusUpMore;
        [self updateResource];
        self.upPageIndex = self.pageIndex;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.tableView.status == QJTableViewRefreshStatusDownMore) {
        self.pageIndex = self.dowmPageIndex;
        self.pageIndex--;
        if (self.pageIndex < 1) {
            self.pageIndex = 1;
        }
        [self updateResource];
        self.dowmPageIndex = self.pageIndex;
    }
}

#pragma mark -tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QJNMBInfoCellMode mode = [self.datas[indexPath.row] isKindOfClass:[QJNMBListModel class]] ? QJNMBInfoCellModeHead : QJNMBInfoCellModeReply;
    QJNMBInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QJNMBInfoCell class])];
    if (!cell.delegate) {
        cell.delegate = self;
    }
    [cell refreshUI:self.datas[indexPath.row] type:mode];
    return cell;
}

#pragma mark -getter
- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray new];
    }
    return _datas;
}

- (QJFootTipView *)footView {
    if (!_footView) {
        _footView = [QJFootTipView new];
        _footView.tipLabel.text = @"已到达最后的评论";
    }
    return _footView;
}

- (UIView *)blackBgView {
    if (!_blackBgView) {
        _blackBgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _blackBgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        _blackBgView.alpha = 0;
        _blackBgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeBgView)];
        [_blackBgView addGestureRecognizer:tap];
    }
    return _blackBgView;
}

- (void)closeBgView {
    [UIView animateWithDuration:0.25f animations:^{
        [self.textF resignFirstResponder];
        self.blackBgView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.blackBgView removeFromSuperview];
    }];
}

- (QJNMBInfoJumpInputView *)cusInputView {
    if (!_cusInputView) {
        _cusInputView = [[NSBundle mainBundle] loadNibNamed:@"QJNMBInfoJumpInputView" owner:nil options:nil][0];
        _cusInputView.frame = CGRectMake(0, 0, UIScreenWidth(), 55);
        _cusInputView.totalLabel.text = [NSString stringWithFormat:@"/ %ld",self.model.totalPages];
        _cusInputView.jumpTextF.placeholder = @"1";
        _cusInputView.delegate = self;
    }
    return _cusInputView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
