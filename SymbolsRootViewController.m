#import "SymbolsRootViewController.h"

@implementation SymbolsRootViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
	searchController.searchBar.delegate = self;
	searchController.hidesNavigationBarDuringPresentation = YES;
	self.navigationItem.hidesSearchBarWhenScrolling = YES;
	self.navigationItem.searchController = searchController;

	self.symbols = [[CUICatalog defaultUICatalogForBundle:[NSBundle bundleWithPath:@"/System/Library/CoreServices/CoreGlyphs.bundle"]] allImageNames];
	self.listData = [self.symbols mutableCopy];
}

- (void)loadView {
	[super loadView];

	self.title = @"Symbols";
	self.navigationController.navigationBar.prefersLargeTitles = YES;
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"safari"] style:UIBarButtonItemStylePlain target:self action:@selector(github:)];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"info.circle"] style:UIBarButtonItemStylePlain target:self action:@selector(about:)];

	self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
}

- (void)github:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/MTACS/Symbols"] options:@{} completionHandler:nil];
}

- (void)about:(id)sender {
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Symbols 3" message:@"Version 3.0\n© MTAC\n\nUpdated by Janneske & RedenticDev\n\nWith help from ETHN & RuntimeOverflow" preferredStyle:UIAlertControllerStyleAlert];
	[alertController addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil]];
	[self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Seach Controller Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
	[searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	if (!searchText || [searchText isEqualToString:@""]) {
		self.listData = [self.symbols mutableCopy];
		self.navigationItem.searchController.active = NO;
	} else {
		NSMutableArray *results = [NSMutableArray new];
		for (NSString *symbol in self.symbols) {
			if ([symbol containsString:[searchBar.text lowercaseString]]) {
				[results addObject:symbol];
			}
		}
		self.listData = results;
	}
	[self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	self.listData = [self.symbols mutableCopy];
	[self.tableView reloadData];
}

#pragma mark - Table View Data Source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 65.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
		
		UIImageView *symbolView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 48, 48)];
		symbolView.tag = 1;
		symbolView.contentMode = UIViewContentModeScaleAspectFit;
		[cell.contentView addSubview:symbolView];

		UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(78, 20, cell.contentView.bounds.size.width - 78, 20)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        titleLabel.tag = 2;
        [cell.contentView addSubview:titleLabel];
	}

	UIImageView *symbolView = (UIImageView *)[cell.contentView viewWithTag:1];
	UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:2];
	symbolView.image = [UIImage systemImageNamed:self.listData[indexPath.row]];
	titleLabel.text = self.listData[indexPath.row];

	return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Symbols" message:[NSString stringWithFormat:@"Choose an export format for \"%@\"", self.listData[indexPath.row]] preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction *text = [UIAlertAction actionWithTitle:@"Text" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        pasteboard.string = self.listData[indexPath.row];
		UIAlertController *copiedAlertController = [UIAlertController alertControllerWithTitle:@"Copied!" message:pasteboard.string preferredStyle:UIAlertControllerStyleAlert];
		[self presentViewController:copiedAlertController animated:YES completion:nil];
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    		[copiedAlertController dismissViewControllerAnimated:YES completion:nil];
		});
    }];
	UIAlertAction *image = [UIAlertAction actionWithTitle:@"Image" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
		pasteboard.image = [UIImage systemImageNamed:self.listData[indexPath.row]];
		UIAlertController *copiedAlertController = [UIAlertController alertControllerWithTitle:@"Copied!" message:self.listData[indexPath.row] preferredStyle:UIAlertControllerStyleAlert];
		[self presentViewController:copiedAlertController animated:YES completion:nil];
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
			[copiedAlertController dismissViewControllerAnimated:YES completion:nil];
		});
	}];
	UIAlertAction *objc = [UIAlertAction actionWithTitle:@"Objective-C" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        pasteboard.string = [NSString stringWithFormat:@"[UIImage systemImageNamed:@\"%@\"]", self.listData[indexPath.row]];
		UIAlertController *copiedAlertController = [UIAlertController alertControllerWithTitle:@"Copied!" message:pasteboard.string preferredStyle:UIAlertControllerStyleAlert];
		[self presentViewController:copiedAlertController animated:YES completion:nil];
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    		[copiedAlertController dismissViewControllerAnimated:YES completion:nil];
		});

    }];
	UIAlertAction *swift = [UIAlertAction actionWithTitle:@"Swift" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        pasteboard.string = [NSString stringWithFormat:@"UIImage(systemName:\"%@\")", self.listData[indexPath.row]];
		UIAlertController *copiedAlertController = [UIAlertController alertControllerWithTitle:@"Copied!" message:pasteboard.string preferredStyle:UIAlertControllerStyleAlert];
		[self presentViewController:copiedAlertController animated:YES completion:nil];
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    		[copiedAlertController dismissViewControllerAnimated:YES completion:nil];
		});
    }];

	[alertController addAction:text];
	[alertController addAction:image];
	[alertController addAction:objc];
	[alertController addAction:swift];
	[alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];

    [self presentViewController:alertController animated:YES completion:nil];
} 

@end
