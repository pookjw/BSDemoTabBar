//
//  UITabBar+BSCategory.m
//  DemoTabBar
//
//  Created by Jinwoo Kim on 4/12/23.
//

#import "UITabBar+BSCategory.h"
#import <objc/message.h>
#import <objc/runtime.h>

static void *UITabBar_BSCategory_itemSpacing_associationKey;

static void (*original_UITabBar_BSCategory_layoutSubviews)(UITabBar *self, SEL cmd);

static void custom_UITabBar_BSCategory_layoutSubviews(UITabBar *self, SEL cmd) {
    original_UITabBar_BSCategory_layoutSubviews(self, cmd);
    
    NSArray<UITabBarItem *> * _Nullable items = self.items;
    if (items == nil) return;
    NSUInteger itemsCount = items.count;
    if (items.count == 0) return;
    
    NSArray<__kindof UIView *> *subviews = self.subviews;
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject isKindOfClass:NSClassFromString(@"UITabBarButton")];
    }];
    NSArray<__kindof UIView *> *tabBarButtons = [subviews filteredArrayUsingPredicate:predicate];
    NSUInteger tabBarButtonsCount = tabBarButtons.count;
    if (tabBarButtonsCount == 0) return;
    
    CGFloat bsCategory_itemSpacing = self.bsCategory_itemSpacing;
    CGFloat itemWidth = (self.bounds.size.width - self.safeAreaInsets.left - self.safeAreaInsets.right - bsCategory_itemSpacing * (tabBarButtonsCount - 1)) / itemsCount;
    CGFloat itemHeight = (self.bounds.size.height - self.safeAreaInsets.top - self.safeAreaInsets.bottom);
    
    [tabBarButtons enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake((itemWidth + bsCategory_itemSpacing) * idx, 0.f, itemWidth, itemHeight);
    }];
}

@implementation UITabBar (BSCategory)

+ (void)load {
    UITabBar_BSCategory_itemSpacing_associationKey = malloc(sizeof(void));
    
    Method layoutSubviewsMethod = class_getInstanceMethod(self, @selector(layoutSubviews));
    original_UITabBar_BSCategory_layoutSubviews = (void (*)(UITabBar *, SEL))method_getImplementation(layoutSubviewsMethod);
    method_setImplementation(layoutSubviewsMethod, (IMP)custom_UITabBar_BSCategory_layoutSubviews);
}

- (CGFloat)bsCategory_itemSpacing {
    NSNumber *result = (NSNumber *)objc_getAssociatedObject(self, UITabBar_BSCategory_itemSpacing_associationKey);
    return result.floatValue;
}

- (void)setBsCategory_itemSpacing:(CGFloat)bsCategory_itemSpacing {
    objc_setAssociatedObject(self, UITabBar_BSCategory_itemSpacing_associationKey, [NSNumber numberWithFloat:bsCategory_itemSpacing], OBJC_ASSOCIATION_COPY);
}

@end
