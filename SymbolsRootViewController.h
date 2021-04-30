#import <UIKit/UIKit.h>

@interface SymbolsRootViewController : UITableViewController <UISearchBarDelegate>
@property (nonatomic, strong) NSArray *symbols;
@property (nonatomic, strong) NSMutableArray *listData;
@end

@interface CUICatalog : NSObject
+ (instancetype)defaultUICatalogForBundle:(NSBundle *)bundle;
- (NSArray *)allImageNames;
@end
