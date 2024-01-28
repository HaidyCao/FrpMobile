# FrpMobile

## FRP Download
FRP for Android download [Google Play](https://play.google.com/store/apps/details?id=com.tools.frp). The app download from `Google Play` cannot choose FRP verison anymore.

FRP for Android download [Github](https://github.com/HaidyCao/frp/releases). The apk download form `Github` can choose or download frp version you need.

## FRP executable file build
`build-android.sh` is a bash script to build frp executable file for android.

### Dependents
`upx`. `upx`can make frpc frps smaller.

For `MacOS`, you can install `upx` from brewhome. `brew update && brew install upx`.

For `Linux`, you can install `upx` by `apt` or `yum`.

Or your system no `upx` command, the script will ignore

### Usage
    
    ANDROID_NDK_HOME=[your ndk home, ndk 23 or above] ./build-android.sh [frp tag]

    # or
    export ANDROID_NDK_HOME=/path/to/your/ndk/home
    ./build-android.sh [frp tag]

