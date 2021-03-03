#import "SymbolsRootViewController.h"
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

BOOL isFourteenDevice() {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"14.0")) {
        return YES;
    }
    return NO;
}

@interface SymbolsRootViewController ()
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) UISearchBar *searchBar;
@end

@implementation SymbolsRootViewController

- (void)viewDidLoad {

	[super viewDidLoad];

	self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    self.searchBar.delegate = self;
	[self.searchBar setBackgroundColor:[UIColor clearColor]];
	[self.searchBar setBarTintColor:[UIColor clearColor]];
	self.tableView.tableHeaderView = self.searchBar;

}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	NSLog(@"SYMBOLS DEBUG");
	showSearchResults = false;
	self.searchResults = nil;
	[self.tableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {

	if (searchText == NULL || [searchText isEqualToString:@""]) {

		showSearchResults = false;
		self.searchResults = nil;
		[self.tableView reloadData];
		[searchBar endEditing:YES];
		[searchBar resignFirstResponder];

	}

	NSLog(@"SYMBOLS DEBUG: %@", searchText);

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {

	self.searchResults = nil;
	NSMutableArray *results = [NSMutableArray new];
	for (NSString *symbol in [self loadSymbols]) {
		if ([[symbol lowercaseString] containsString:[searchBar.text lowercaseString]]) {
			[results addObject:symbol];
		}
	}
	self.searchResults = results;
	showSearchResults = true;
	[self.tableView reloadData];

}

- (void)loadView {

	[super loadView];
	((UITableView *)[self tableView]).keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

	self.title = @"Symbols";
	UIButton *githubButton = [UIButton buttonWithType:UIButtonTypeCustom];
	githubButton.bounds = CGRectMake(0, 0, 30, 30);
	[githubButton addTarget:self action:@selector(github:) forControlEvents:UIControlEventTouchUpInside];
	[githubButton setImage:[UIImage systemImageNamed:@"safari" withConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:26]] forState:UIControlStateNormal];
	UIButton *infoButton = 	[UIButton buttonWithType:UIButtonTypeCustom];
	infoButton.bounds = CGRectMake(0, 0, 30, 30);
	[infoButton addTarget:self action:@selector(about:) forControlEvents:UIControlEventTouchUpInside];
	[infoButton setImage:[UIImage systemImageNamed:@"info.circle" withConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:26]] forState:UIControlStateNormal];
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:githubButton];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
	self.navigationController.navigationBar.prefersLargeTitles = YES;
	// githubButton.tintColor = [UIColor labelColor]; // Personally liked the blue buttons...
	// infoButton.tintColor = [UIColor labelColor];

}

- (void)about:(id)sender {

	if (isFourteenDevice()) {
		UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Symbols 2" message:@"Version 2.0\n© MTAC\n\nUpdated by Janneske\nWith help from ETHN & RuntimeOverflow" preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil];
		[alertController addAction:ok];
		[[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertController animated:YES completion:nil];
	} else {
		UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Symbols" message:@"Version 2.0\n\n© MTAC\n\nUpdated by Janneske\nWith help from ETHN & RuntimeOverflow" preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil];
		[alertController addAction:ok];
		[[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertController animated:YES completion:nil];
	}
}

- (void)github:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/MTACS/Symbols"]];
}

#pragma mark - Table View Data Source

- (NSArray *)loadSymbols {
	if (showSearchResults) {
		return self.searchResults;
	} else {
		if (isFourteenDevice()) {
            NSMutableDictionary *symbols = [NSMutableDictionary dictionaryWithContentsOfFile:@"/Applications/Symbols.app/Symbols14.plist"];
            return [symbols objectForKey:@"items"];
        } else {
            NSMutableDictionary *symbols = [NSMutableDictionary dictionaryWithContentsOfFile:@"/Applications/Symbols.app/Symbols13.plist"];
            return [symbols objectForKey:@"items"];
        }
	}
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 65.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[self loadSymbols] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		
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
	symbolView.image = [UIImage systemImageNamed:[[self loadSymbols] objectAtIndex:indexPath.row]];
	titleLabel.text = [[self loadSymbols] objectAtIndex:indexPath.row];

	return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Symbol" message:[NSString stringWithFormat:@"\nChoose an export format for\n%@", [[self loadSymbols] objectAtIndex:indexPath.row]] preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction* text = [UIAlertAction actionWithTitle:@"Text" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        pasteboard.string = [[self loadSymbols] objectAtIndex:indexPath.row];
		UIAlertController *copiedAlertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@\n\nCopied!", pasteboard.string] message:@"" preferredStyle:UIAlertControllerStyleAlert];
		[self presentViewController:copiedAlertController animated:YES completion:nil];
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    		[copiedAlertController dismissViewControllerAnimated:true completion:nil];
	});

    }];
	UIAlertAction* objc = [UIAlertAction actionWithTitle:@"Objective-C" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        pasteboard.string = [NSString stringWithFormat:@"[UIImage systemImageNamed:@\"%@\"]", [[self loadSymbols] objectAtIndex:indexPath.row]];
		UIAlertController *copiedAlertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@\n\nCopied!", pasteboard.string] message:@"" preferredStyle:UIAlertControllerStyleAlert];
		[self presentViewController:copiedAlertController animated:YES completion:nil];
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    		[copiedAlertController dismissViewControllerAnimated:true completion:nil];
	});

    }];
	UIAlertAction* swift = [UIAlertAction actionWithTitle:@"Swift" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        pasteboard.string = [NSString stringWithFormat:@"UIImage(systemName:\"%@\")", [[self loadSymbols] objectAtIndex:indexPath.row]];
		UIAlertController *copiedAlertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@\n\nCopied!", pasteboard.string] message:@"" preferredStyle:UIAlertControllerStyleAlert];
		[self presentViewController:copiedAlertController animated:YES completion:nil];
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    		[copiedAlertController dismissViewControllerAnimated:true completion:nil];
	});

    }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil];
	[alertController addAction:text];
	[alertController addAction:objc];
	[alertController addAction:swift];
	[alertController addAction:ok];
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertController animated:YES completion:nil];

	
	/* [tableView deselectRowAtIndexPath:indexPath animated:YES];
	UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Symbols" message:@"Choose an export format" preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction* text = [UIAlertAction actionWithTitle:@"Text" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        pasteboard.string = [[self loadSymbols] objectAtIndex:indexPath.row];

    }];
	UIAlertAction* objc = [UIAlertAction actionWithTitle:@"Objective-C" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        pasteboard.string = [NSString stringWithFormat:@"[UIImage systemImageNamed:@\"%@\"]", [[self loadSymbols] objectAtIndex:indexPath.row]];

    }];
	UIAlertAction* swift = [UIAlertAction actionWithTitle:@"Swift" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        pasteboard.string = [NSString stringWithFormat:@"UIImage(systemName:\"%@\")", [[self loadSymbols] objectAtIndex:indexPath.row]];

    }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDestructive handler:nil];
	[alertController addAction:text];
	[alertController addAction:objc];
	[alertController addAction:swift];
	[alertController addAction:ok];
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertController animated:YES completion:nil]; */

} 

@end
