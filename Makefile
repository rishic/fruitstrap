IOS_CC = xcrun -sdk iphoneos clang
IOS_MIN_OS = 5.1
IOS_SDK = 6.1

fruitstrap: fruitstrap.c
	clang -o fruitstrap -framework CoreFoundation -framework MobileDevice -F/System/Library/PrivateFrameworks fruitstrap.c

install: fruitstrap
	sudo mkdir -p /usr/local/bin
	sudo cp fruitstrap /usr/local/bin/fruitstrap

uninstall: fruitstrap
	sudo rm -f /usr/local/bin/fruitstrap

CERT="iPhone Developer"

all: demo.app fruitstrap

demo.app: demo Info.plist
	mkdir -p demo.app
	cp demo demo.app/
	cp Info.plist ResourceRules.plist demo.app/
	codesign -f -s $(CERT) --entitlements Entitlements.plist demo.app

demo: demo.c
	$(IOS_CC) -isysroot `xcode-select -print-path`/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS$(IOS_SDK).sdk -mios-version-min=$(IOS_MIN_OS) -arch armv7 -framework CoreFoundation -o demo demo.c

install_demo: all
	./fruitstrap -b demo.app

debug_demo: all
	./fruitstrap -d -b demo.app

clean:
	rm -rf *.app demo fruitstrap
