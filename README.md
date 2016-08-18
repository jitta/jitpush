# jitpush
![...](https://www.dropbox.com/s/ykfwzr74jwhdzx7/jitpush.gif?raw=1)
##### Getting Started
1. Initial React-Native project
2. Adding this script in package.json `"build:ios": "node node_modules/react-native/local-cli/cli.js bundle --entry-file='index.ios.js' --bundle-output='./ios/_YOUR_DIRECTORY_/main.jsbundle' --dev=false --platform='ios' --assets-dest='./ios'"` for pack a new jsbundle file.
3. run `npm install jitpush --save`
4. Create JSON payload file and add to project
	PAYLOAD_FILE  
```json	
{
	"version": "1.0.0",
	"minContainerVersion": "1.0",
		"url": {
			"url": "NA",
			"isRelative": true
		}
	}
```
5. run `npm run-script build:ios` to compress default jsbundle file
6. Open Xcode Project right click on your project's Libraries folder ➜ Add Files to "Your Project Name" 
7. Go to node_modules ➜ jitpush➜  JitPush-IOS ➜ select `JitPush.xcodeproj`
8. In General tab, look for Linked Frameworks and Libraries. Click on the + button at the bottom and add `libJitPush.a` from the list.
9. Go to Build Settings tab and search for Header Search Paths. In the list, add `$(SRCROOT)/../node_modules/jitpush/JitPush-iOS` and select `recursive`.
10. Import `JitPush.h` to appdelegate

##### Usage
  - Implement `JitPushDelegate` 
  - See example in [sample code](https://github.com/Thunderbird7/JitPush_Example)
  - Awesome!
