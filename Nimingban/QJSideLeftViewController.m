//
//  QJSideLeftViewController.m
//  Nimingban
//
//  Created by QinJ on 2017/6/28.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import "QJSideLeftViewController.h"
#import "ViewController.h"
#import "QJHTTPOperation.h"
#import "QJLeftBigFModel.h"
#import "QJSideLeftViewCell.h"
#import "QJLeftSubFModel.h"
#import "QJSideContainerController.h"
#import "QJSideLeftHeadView.h"
#import "QJSettingViewController.h"

@interface QJSideLeftViewController ()<UITableViewDelegate,UITableViewDataSource,QJSideLeftHeadViewDelagate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<QJLeftBigFModel *> *datas;
@property (nonatomic, strong) NSArray<NSString *> *settings;
@property (nonatomic, strong) NSArray<NSString *> *dailys;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@end

@implementation QJSideLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setContent];
    [self updateResource];
}

- (void)setContent {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([QJSideLeftViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([QJSideLeftViewCell class])];
}

- (void)updateResource {
    [QJHTTPOperation getRequestWithURL:@"/getForumList" params:nil success:^(id responseObject) {
        NSArray *array = (NSArray *)responseObject;
        for (NSDictionary *dict in array) {
            QJLeftBigFModel *model = [QJLeftBigFModel modelWithDict:dict];
            [self.datas addObject:model];
        }
        //保存一个全局的版块id对应表,关键是时间线用
        [self saveAllForum];
        [self.tableView reloadData];
        //加载时间线的数据
        [self.mainVC updateResourceWithNewId:@"-1" title:@"时间线" type:ViewControllerTypeTimeLine];
    } failure:^(NSError *error) {
        
    }];
}

- (void)saveAllForum {
    NSMutableDictionary *forum = [NSMutableDictionary new];
    for (QJLeftBigFModel *model in self.datas) {
        if (model.forumsArr.count) {
            for (QJLeftSubFModel *subModel in model.forumsArr) {
                [forum setValue:subModel.name forKey:subModel.idF];
            }
        }
    }
    [[QJGlobalInfo sharedInstance] putAttribute:@"ForumName" value:forum];
}

#pragma mark -QJSideLeftHeadViewDelagate
- (void)didClickHeadViewWithModel:(QJLeftBigFModel *)model {
    NSInteger section = [self.datas indexOfObject:model] + 1;
    NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:section];
    [self.tableView reloadSections:indexset withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark -tableview
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    QJSideLeftHeadView *headView  = [[NSBundle mainBundle] loadNibNamed:@"QJSideLeftHeadView" owner:nil options:nil][0];
    headView.frame = CGRectMake(0, 0, UIScreenWidth(), 40);
    if (section && section != self.datas.count + 1) {
        [headView refreshUI:self.datas[section - 1] subTitle:nil];
        headView.delegate = self;
    } else {
        [headView refreshUI:nil subTitle:section == 0 ? @"我的设置" : @"常用串"];
    }
    return headView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datas.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    /*if (section == self.datas.count + 1) {
        return self.dailys.count;
    }
    else */if (section) {
        return self.datas[section - 1].isShow ? self.datas[section - 1].forumsArr.count : 0;
    }
    else {
        return self.settings.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QJSideLeftViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QJSideLeftViewCell class])];
    /*if (indexPath.section == self.datas.count + 1) {
        cell.titleNameLabel.text = self.dailys[indexPath.row];
    }
    else */if (indexPath.section) {
        cell.titleNameLabel.text = self.datas[indexPath.section - 1].forumsArr[indexPath.row].name;
    }
    else {
        cell.titleNameLabel.text = self.settings[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.fatherVC hideSideView];
    if (indexPath.section) {
        if ([self.datas[indexPath.section - 1].forumsArr[indexPath.row].name isEqualToString:@"时间线"]) {
            [self.mainVC updateResourceWithNewId:@"-1" title:@"时间线" type:ViewControllerTypeTimeLine];
        }
        else {
            [self.mainVC updateResourceWithNewId:self.datas[indexPath.section - 1].forumsArr[indexPath.row].idF title:self.datas[indexPath.section - 1].forumsArr[indexPath.row].name type:ViewControllerTypeNormal];
        }
    }
    else {
        if (indexPath.row == 2) {
            [self.mainVC updateResourceWithNewId:@"" title:@"订阅" type:ViewControllerTypeLike];
        }
        else if (indexPath.row == 3) {
            QJSettingViewController *vc = [QJSettingViewController new];
            [self.mainVC.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark -getter
- (NSMutableArray<QJLeftBigFModel *> *)datas {
    if (!_datas) {
        _datas = [NSMutableArray new];
    }
    return _datas;
}

- (NSArray<NSString *> *)settings {
    if (!_settings) {
        _settings = @[@"我的帖子",@"我的回复",@"订阅",@"设置"];
    }
    return _settings;
}

- (NSArray<NSString *> *)dailys {
    if (!_dailys) {
        _dailys = @[@"丧尸图鉴",@"壁纸楼",@"豆知识",@"淡定红茶",@"胸器福利",@"黑妹",@"总有一天",@"这是芦苇",@"赵日天",@"二次元女友",@"什么鬼",@"荒野探索",@"面包车女孩",@"AC大逃杀新版"];
    }
    return _dailys;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
