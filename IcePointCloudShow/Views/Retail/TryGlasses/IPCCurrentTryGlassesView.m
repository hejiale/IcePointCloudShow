//
//  IPCTryGlassesView.m
//  IcePointCloudShow
//
//  Created by gerry on 2017/8/24.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCCurrentTryGlassesView.h"

@interface IPCCurrentTryGlassesView()

@property (weak, nonatomic) IBOutlet UIView *imageContentView;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UIView *parameterContentView;
@property (weak, nonatomic) IBOutlet UIImageView *defaultGlassImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;

@property (copy, nonatomic) void(^ChooseBlock)();
@property (copy, nonatomic) void(^EditBlock)();
@property (copy, nonatomic) void(^ReloadBlock)();

@end

@implementation IPCCurrentTryGlassesView

- (instancetype)initWithFrame:(CGRect)frame ChooseParameter:(void (^)())choose EditParameter:(void (^)())edit Reload:(void (^)())reload
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCCurrentTryGlassesView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
        
        [self addBottomLine];
        self.ChooseBlock = choose;
        self.EditBlock = edit;
        self.ReloadBlock = reload;
    }
    return self;
}

- (void)setGlasses:(IPCGlasses *)glasses{
    _glasses = glasses;
    
    if (_glasses) {
        IPCGlassesImage * glassImage = [self.glasses imageWithType:IPCGlassesImageTypeThumb];
        if (glassImage.imageURL.length) {
            __block CGFloat scale = 0;
            if (glassImage.width > glassImage.height) {
                scale = glassImage.width/glassImage.height;
            }else{
                scale = glassImage.height/glassImage.width;
            }
            __block CGFloat width = self.productImageView.jk_width;
            __block CGFloat height = width/scale;
            self.imageHeight.constant = MIN(height, 100);
            
            [self.productImageView setImageWithURL:[NSURL URLWithString:glassImage.imageURL] placeholder:[UIImage imageNamed:@"default_placeHolder"]];
        }
        
        [self.priceLabel setText:[NSString stringWithFormat:@"￥%.f",_glasses.price]];
        [self.productNameLabel setText:_glasses.glassName];
        
        //Parameter View
        __block NSMutableArray<NSString *> * array = [[NSMutableArray alloc]init];
        if (_glasses.brand.length) {
            [array addObject:_glasses.brand];
        }
        if (_glasses.material.length) {
            [array addObject:_glasses.material];
        }
        if (_glasses.style.length) {
            [array addObject:_glasses.style];
        }
        if (_glasses.color.length) {
            [array addObject:_glasses.color];
        }
    
        [self.parameterContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
        __block CGFloat height = (self.parameterContentView.jk_height-20)/2;
        __block totalWidth = 0;
        
        if (array.count) {
            [array enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
            {
                UIFont * font = [UIFont systemFontOfSize:13];
                CGFloat width = [obj jk_sizeWithFont:font constrainedToHeight:height].width;
                
                UILabel * label = [[UILabel alloc]init];
                if (idx < 2) {
                    [label setFrame:CGRectMake(totalWidth, 0, width, height)];
                }else{
                    [label setFrame: CGRectMake((idx - 2)*totalWidth, height+10, width, height)];
                }
                [label setText:obj];
                [label setFont:font];
                [label setBackgroundColor:[UIColor clearColor]];
                [label setTextColor:[UIColor colorWithHexString:@"#666666"]];
                [self.parameterContentView addSubview:label];
                
                UIImageView * line = [[UIImageView alloc]init];
                [line setBackgroundColor:[UIColor lightGrayColor]];
                
                if (idx == 1) {
                    [line setFrame:CGRectMake(totalWidth-5, 5, 1, height-10)];
                }else if (idx == 3){
                    [line setFrame:CGRectMake(totalWidth-5, height+15, 1, height-10)];
                }
                [self.parameterContentView addSubview:line];
                
                if (idx == 1) {
                    totalWidth = 0;
                }else{
                    totalWidth += (width+10);
                }
            }];
        }
    }
}

- (void)setDefaultGlasses
{
    [self.defaultGlassImageView setHidden:NO];
}

#pragma mark //Clicked Events
- (void)reload
{
     self.glasses = [[IPCTryMatch instance] currentMatchItem].glass;
}



@end
