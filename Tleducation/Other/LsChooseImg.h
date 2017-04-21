//
//  LsChooseImg.h
//  lushangjituan
//
//  Created by Chaos on 16/8/29.
//  Copyright © 2016年 gansu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LsChooseImg : UITableView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) NSMutableArray<UIImage *>*data;
@property (assign,nonatomic) BOOL isFull;/**< 照片是否已选满 6张*/
typedef void(^chooseImgBlock)(NSInteger nn);
@property (strong,nonatomic) chooseImgBlock block_addImg;
@property (strong,nonatomic) chooseImgBlock block_lockImg;
@property (strong,nonatomic) chooseImgBlock block_removeImg;

@end

@interface LsChooseImgTableCell : UITableViewCell

@property (nonatomic,weak) IBOutlet  UIButton *remBtn;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;



typedef void(^removeCellIndex)(NSIndexPath *indexPath);
@property (strong,nonatomic) removeCellIndex block;
@end
