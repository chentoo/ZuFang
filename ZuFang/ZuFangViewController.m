//
//  ZuFangViewController.m
//  ZuFang
//
//  Created by Summer on 14/1/14.
//  Copyright (c) 2014 kodak. All rights reserved.
//

#import "ZuFangViewController.h"
#import "FangYuanGroupURL.h"
#import "MBProgressHUD.h"
#import "DetailViewController.h"
#import "ZuFangCell.h"
#import "FangYuanObject.h"

static NSInteger maxNumOfPages = 20;

@interface ZuFangViewController ()
{
    NSMutableArray *fangyuanArrays;
    MBProgressHUD *mbp;
}
@property (strong, nonatomic) IBOutlet UITableView *fangyuanTableView;
@property (strong, nonatomic) IBOutlet UITextField *keyWordsTextField;

@end

@implementation ZuFangViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    fangyuanArrays = [[NSMutableArray alloc] init];
    mbp = [[MBProgressHUD alloc] init];
    [self.view addSubview:mbp];
    self.fangyuanTableView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loadButtonPressed:(UIButton *)sender
{
    NSArray *keyWords = [self keyWords];

    if (keyWords)
    {
        [self fangyuanArrayFromKeyWords:keyWords array:^(NSMutableArray *array) {
            fangyuanArrays = array;
            [self.fangyuanTableView reloadData];
            self.fangyuanTableView.hidden = NO;

        }];
    }
    else
    {
        [self getFangYuanArray:^(NSMutableArray *array) {
            fangyuanArrays = array;
            [self.fangyuanTableView reloadData];
            self.fangyuanTableView.hidden = NO;

        }];
    }
    
}

- (void)getFangYuanArray:(void(^)(NSMutableArray *array))success
{

    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    mbp.labelText = @"正在读取豆瓣网页";
    mbp.detailsLabelText = [NSString stringWithFormat:@"第1页，共20页"];
    [mbp show:YES];
    dispatch_queue_t queue = dispatch_queue_create("loadFangYuan.ZuFang.chentoo", DISPATCH_QUEUE_CONCURRENT);

        for (NSInteger i = 0; i < maxNumOfPages; i ++)
        {
            dispatch_barrier_async(queue, ^{

                dispatch_async(dispatch_get_main_queue(), ^{
                    mbp.detailsLabelText = [NSString stringWithFormat:@"第%i页，共%i页", i+1, maxNumOfPages];
                    [mbp show:YES];
                });

                NSError *error;
                NSString *url = [NSString stringWithFormat:@"http://www.douban.com/group/shanghaizufang/discussion?start=%i",i*25];
                NSString *webString = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:&error];
                
//                NSLog(@"webString  -> %@",webString);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [resultArray addObjectsFromArray:[self resultArrayWithString:webString]];
                    if (i == maxNumOfPages - 1)
                    {
                        [mbp hide:YES];
                        success(resultArray);
                    }
                });
            });
        }
}

- (NSMutableArray *)resultArrayWithString:(NSString *)string
{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    NSString *rightString = string;
    
    while (rightString.length > 0)
    {
        //解析url
        NSRange leftRange = [rightString rangeOfString:@"http://www.douban.com/group/topic/"];
        if (leftRange.length <= 0)
        {
            break;
        }
        rightString = [rightString substringFromIndex:leftRange.location];
        
        NSRange rightRange = [rightString rangeOfString:@"\""];
        NSString *resultString = [rightString substringToIndex:rightRange.location];

        //解析标题
        leftRange = [rightString rangeOfString:@"title=\""];
        rightString = [rightString substringFromIndex:leftRange.location + leftRange.length];
        
        rightRange = [rightString rangeOfString:@"\""];
        NSString *titleString = [rightString substringToIndex:rightRange.location];
        
        rightString = [rightString substringFromIndex:rightRange.location ];
        
        //解析时间戳
        leftRange = [rightString rangeOfString:@"class=\"time\">"];
        rightString = [rightString substringFromIndex:leftRange.location + leftRange.length];
        
        rightRange = [rightString rangeOfString:@"<"];
        NSString *timeString = [rightString substringToIndex:rightRange.location];
        
        rightString = [rightString substringFromIndex:rightRange.location ];
        
        
        
        
        FangYuanObject *FYObject = [[FangYuanObject alloc] initWithTitle:titleString
                                                                     url:resultString
                                                                    time:timeString];
        
        [resultArray addObject:FYObject];
    }

    return resultArray;
}

- (NSArray *)keyWords
{
    NSString *keyWordsString = self.keyWordsTextField.text;
    if (keyWordsString.length <= 0) {
        return nil;
    }
    NSArray *keyWords = [keyWordsString componentsSeparatedByString:@" "];
    return keyWords;
}

- (void)fangyuanArrayFromKeyWords:(NSArray *)keyWords array:(void(^)(NSMutableArray *array))success
{
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    
    [self getFangYuanArray:^(NSMutableArray *array) {
        fangyuanArrays = array;
        
        [fangyuanArrays enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

            FangYuanObject *FYObject = (FangYuanObject *)obj;
            
            for (NSString *keyWord in keyWords)
            {
                if ([FYObject.title rangeOfString:keyWord].length > 0)
                {
                    [newArray addObject:FYObject];
                    break;
                }
            }
        }];
        
        NSLog(@"%@", newArray.description);

        success(newArray);
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 74.0f;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return fangyuanArrays.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *zufangTableIdentifier = @"zufangIdentifier";
    
    // 2. 注册自定义Cell的到TableView中，并设置cell标识符为paperCell
    static BOOL isRegNib = NO;
    if (!isRegNib) {
        [tableView registerNib:[UINib nibWithNibName:@"ZuFangCell" bundle:nil] forCellReuseIdentifier:zufangTableIdentifier];
        isRegNib = YES;
    }
    
    // 3. 从TableView中获取标识符为paperCell的Cell
    ZuFangCell *cell = [tableView dequeueReusableCellWithIdentifier:zufangTableIdentifier];
    
    // 4. 设置单元格属性
    [cell initCell:[fangyuanArrays objectAtIndex:indexPath.row]];

    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger i = indexPath.row;
    
    FangYuanObject *object = fangyuanArrays[i];
    NSString *url = [object url];
    
    DetailViewController *detailVC = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    detailVC.url = url;
//    [self presentViewController:detailVC animated:YES completion:^{
//        
//        [detailVC loadWebView:url];
//
//    }];
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
    
}

@end
