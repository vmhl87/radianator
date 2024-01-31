#import <UIKit/UIKit.h>

NSMutableString *degToRad(NSString *text) {
	NSMutableString *ret = [[NSMutableString alloc] init];
	[ret appendString:text];
	int radians = 0;
	for(int i=0; i<[text length]-1; i++) {
		unichar c = [text characterAtIndex:i];
		radians = radians*10 + c-'0';
	}
	radians = (radians*5)/9;
	int tens = radians/100,
		units = radians - tens*100;
	NSMutableString *radStr =
		[NSMutableString stringWithFormat:@"%d",tens];
	[radStr appendString:@"."];
	[radStr appendString:[NSString stringWithFormat:@"%d",units]];
	[radStr appendString:@"π"];
	return radStr;
}

bool isKelvin(NSString *text) {
	if([text length] < 1) return false;
	for(int i=0; i<[text length]-1; i++) {
		unichar c = [text characterAtIndex:i];
		if(c < '0' || c > '9') return false;
	}
	if([text characterAtIndex:[text length]-1] == 'K') return true;
	return false;
}

%hook UILabel

- (void)setText:(NSString *)text {
	if(isKelvin(text)) {
		%orig(degToRad(text));
	} else {
		%orig(text);
	}
}

- (void)setAttributedText:(NSAttributedString *)text {
	if(isKelvin([text string])) {
		NSMutableString *radStr = degToRad([text string]);
		NSMutableAttributedString *endStr = [text mutableCopy];
		[[endStr mutableString] setString:radStr];
		%orig(endStr);
	} else {
		%orig(text);
	}
}

%end

%hook WFTemperatureUnitObserver

- (int)temperatureUnit {
	return 3;
}

%end
