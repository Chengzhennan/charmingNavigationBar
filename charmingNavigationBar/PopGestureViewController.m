//
//  PopGestureViewController.m
//  charmingNavigationBar
//
//  Created by Mac on 2017/4/7.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "PopGestureViewController.h"

#import "ViewControllerWithBar.h"
#import "ViewControllerWithoutBar.h"
#import "ViewControllerWithScrollView.h"


@interface PopGestureViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PopGestureViewController

- (void)viewDidLoad {
    [super viewDidLoad];

   
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        
        ViewControllerWithBar *barVC = [[ViewControllerWithBar alloc]init];
        [self.navigationController pushViewController:barVC animated:YES];
        
        
    }
    else if (indexPath.row == 1)
    {
        
        ViewControllerWithoutBar *noBarVC = [[ViewControllerWithoutBar alloc]init];
        [self.navigationController pushViewController:noBarVC animated:YES];
        
    
    }
    else
    {
        ViewControllerWithScrollView *scrollVC = [[ViewControllerWithScrollView alloc]init];
        [self.navigationController pushViewController:scrollVC animated:YES];
        
    
    }


}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 3;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    
    NSString *text = @"";

    if (cell == nil)
    {
      cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    
    if (indexPath.row == 0)
    {
        text =  @"push a controller With Bar";
        
    }
    else if(indexPath.row == 1)
    {
        
        text =  @"push a controller Without Bar";
        
    }
    else
    {
        
        text =  @"push a controller Without scrollView";
        
    }
    cell.textLabel.text = text;
    


    return  cell;
}


@end
