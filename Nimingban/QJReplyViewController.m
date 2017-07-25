//
//  QJReplyViewController.m
//  Nimingban
//
//  Created by QinJ on 2017/7/10.
//  Copyright © 2017年 kayanouriko. All rights reserved.
//

#import "QJReplyViewController.h"
#import "QJReplyViewCell.h"
#import "QJNMBListModel.h"
#import "QJHTTPOperation.h"

@interface QJReplyViewController ()<UITableViewDelegate,UITableViewDataSource,QJReplyViewCellDelagate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) NSMutableDictionary *datasDict;

@end

@implementation QJReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setContent];
}

- (void)setContent {
    //导航栏
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(replyAction)];
    self.navigationItem.rightBarButtonItem = item1;
    
    //如果有内容
    if (self.number) {
        [self.datasDict setValue:[NSString stringWithFormat:@">>%@\n",self.number] forKey:@"正文"];
        self.title = [NSString stringWithFormat:@"回应-No.%@",self.number];
    }
    else {
        self.title = @"回应-PO主";
    }
    
    //tableview
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 90;
    self.tableView.tableFooterView = [UIView new];
    
}

- (void)replyAction {
    [self.view endEditing:YES];
    QJPostModel *model = [QJPostModel new];
    model.idName = self.model.idC;
    model.title = isnull(self.datasDict, @"标题");
    model.email = isnull(self.datasDict, @"E-mail");
    model.name = isnull(self.datasDict, @"名称");
    model.content = isnull(self.datasDict, @"正文");
    if (model.content.length == 0) {
        [QJToast showWithTip:@"请输入内容"];
        return;
    }
    [QJHTTPOperation replyWithModel:model success:^(id responseObject) {
        [self.navigationController popViewControllerAnimated:YES];
        [QJToast showWithTip:@"回复成功!"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.26f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(shouldRefreshUI)]) {
                [self.delegate shouldRefreshUI];
            }
        });
    } failure:^(NSError *error) {
        [QJToast showWithTip:@"回复失败!"];
    }];
}

#pragma mark -QJReplyViewCellDelagate
- (void)changeValueWithKey:(NSString *)key value:(NSString *)value {
    [self.datasDict setValue:value forKey:key];
}

- (void)showSheetView {
    [self.view endEditing:YES];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择图片" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *imageAction = [UIAlertAction actionWithTitle:@"相册图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:imageAction];
    UIAlertAction *tyAction = [UIAlertAction actionWithTitle:@"涂鸦" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:tyAction];
    UIAlertAction *cannelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cannelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QJReplyViewCellType type = QJReplyViewCellTypeNormal;
    if ([self.datas[indexPath.row] isEqualToString:@"正文"]) {
        type = QJReplyViewCellTypeContent;
    }
    else if ([self.datas[indexPath.row] isEqualToString:@"附件上传"]) {
        type = QJReplyViewCellTypeUploadImage;
    }
    QJReplyViewCell *cell = [QJReplyViewCell creatCellWithtableView:tableView type:type];
    cell.delegate = self;
    cell.number = self.number;
    [cell refreshUI:self.datas[indexPath.row]];
    return cell;
}

#pragma mark -getter
- (NSArray *)datas {
    if (!_datas) {
        _datas = @[@"名称",@"E-mail",@"标题",@"正文",@"附件上传"];
    }
    return _datas;
}

- (NSMutableDictionary *)datasDict {
    if (nil == _datasDict) {
        _datasDict = [NSMutableDictionary new];
    }
    return _datasDict;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
