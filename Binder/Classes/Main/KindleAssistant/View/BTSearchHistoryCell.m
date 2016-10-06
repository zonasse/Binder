//
//  BTSearchHistoryCell.m
//  Bullet
//
//  Created by 钟奇龙 on 16/9/25.
//  Copyright © 2016年 com.developer.jaccob. All rights reserved.
//

#import "BTSearchHistoryCell.h"

@interface BTSearchHistoryCell ()

@property (nonatomic,strong) UILabel *searchNameLabel;
@end

@implementation BTSearchHistoryCell

- (void)setHistoryName:(NSString *)historyName
{
    _historyName = historyName;
    _searchNameLabel.text = historyName;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
       
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        //创建子视图
        UIImageView *searchIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, (self.contentView.height - 15) * 0.5, 18, 18)];
        searchIcon.image = [UIImage imageNamed:@"searchbar_textfield_search_icon"];
        
        _searchNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(searchIcon.frame) + 20, 0, 150, self.contentView.height)];
        _searchNameLabel.textColor = [UIColor lightGrayColor];
        _searchNameLabel.textAlignment = NSTextAlignmentLeft;
        
        UIButton *deleteButton = [[UIButton alloc ]initWithFrame: CGRectMake(UIScreenWidth - self.contentView.height, 0, self.contentView.height, self.contentView.height)];
        [deleteButton addTarget:self action:@selector(deleteHistory) forControlEvents:UIControlEventTouchUpInside];
        
        [deleteButton setImage:[UIImage imageNamed:@"radar_card_cancel"] forState:UIControlStateNormal];
        
        [self.contentView addSubview:searchIcon];
        [self.contentView addSubview:_searchNameLabel];
        [self.contentView addSubview:deleteButton];
        
        
        
    }
        return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView andIdentifier:(NSString *)identifier
{
    BTSearchHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (void)deleteHistory
{
    if ([self.delegate respondsToSelector:@selector(deleteHistoryCellWithTag:)]) {
        [self.delegate deleteHistoryCellWithTag:self.tag];
    }
}

@end
