#! /bin/bash

if [[ -z ${ANDROID_NDK_HOME} ]]; then
    echo "env ANDROID_NDK_HOME not found."
    exit 1
fi

TAG=${1}
if [[ -z ${TAG} ]]; then
    echo "need input frp build tag"
    exit 1
fi

git clone https://github.com/fatedier/frp.git
cd frp || exit 1
git checkout ${TAG}

echo "Build for arm64"

export CC=${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/darwin-x86_64/bin/aarch64-linux-android21-clang
env CGO_ENABLED=0 GOOS=android GOARCH=arm64 go build -trimpath -ldflags "-s -w" -tags frpc -o bin/arm64/frpc ./cmd/frpc
env CGO_ENABLED=0 GOOS=android GOARCH=arm64 go build -trimpath -ldflags "-s -w" -tags frps -o bin/arm64/frps ./cmd/frps

echo "Build for amd64"

export CC=${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/darwin-x86_64/bin/x86_64-linux-android21-clang
env CGO_ENABLED=0 GOOS=android GOARCH=amd64 go build -trimpath -ldflags "-s -w" -tags frpc -o bin/x86_64/frpc ./cmd/frpc
env CGO_ENABLED=0 GOOS=android GOARCH=amd64 go build -trimpath -ldflags "-s -w" -tags frps -o bin/x86_64/frps ./cmd/frps

echo "Build for arm"

export CC=${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/darwin-x86_64/bin/armv7a-linux-androideabi16-clang
env CGO_ENABLED=0 GOOS=android GOARCH=arm GOARM=7 go build -trimpath -ldflags "-s -w" -tags frpc -o bin/arm/frpc ./cmd/frpc
env CGO_ENABLED=0 GOOS=android GOARCH=arm GOARM=7 go build -trimpath -ldflags "-s -w" -tags frps -o bin/arm/frps ./cmd/frps

echo "Build for x86"

export CC=${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/darwin-x86_64/bin/i686-linux-android16-clang
env CGO_ENABLED=0 GOOS=android GOARCH=386 go build -trimpath -ldflags "-s -w" -tags frpc -o bin/x86/frpc ./cmd/frpc
env CGO_ENABLED=0 GOOS=android GOARCH=386 go build -trimpath -ldflags "-s -w" -tags frps -o bin/x86/frps ./cmd/frps

upx --best bin/arm64/frpc -o bin/arm64/frpc_upx || cp -v bin/arm64/frpc bin/arm64/frpc_upx
upx --best bin/arm64/frps -o bin/arm64/frps_upx || cp -v bin/arm64/frps bin/arm64/frps_upx

upx --best bin/arm/frpc -o bin/arm/frpc_upx || cp -v bin/arm/frpc bin/arm/frpc_upx
upx --best bin/arm/frps -o bin/arm/frps_upx || cp -v bin/arm/frps bin/arm/frps_upx

upx --best bin/x86/frpc -o bin/x86/frpc_upx || cp -v bin/x86/frpc bin/x86/frpc_upx
upx --best bin/x86/frps -o bin/x86/frps_upx || cp -v bin/x86/frps bin/x86/frps_upx

upx --best bin/x86_64/frpc -o bin/x86_64/frpc_upx || cp -v bin/x86_64/frpc bin/x86_64/frpc_upx
upx --best bin/x86_64/frps -o bin/x86_64/frps_upx || cp -v bin/x86_64/frps bin/x86_64/frps_upx

mkdir bin/upx
mkdir bin/upx/arm64
cp -v bin/arm64/frpc_upx bin/upx/arm64_frpc
cp -v bin/arm64/frps_upx bin/upx/arm64_frps

mkdir bin/upx/arm
cp -v bin/arm/frpc_upx bin/upx/arm_frpc
cp -v bin/arm/frps_upx bin/upx/arm_frps

mkdir bin/upx/x86
cp -v bin/x86/frpc_upx bin/upx/x86_frpc
cp -v bin/x86/frps_upx bin/upx/x86_frps

mkdir bin/upx/x86_64
cp -v bin/x86_64/frpc_upx bin/upx/x86_64_frpc
cp -v bin/x86_64/frps_upx bin/upx/x86_64_frps

mkdir bin/so
mkdir bin/so/arm64-v8a
cp -v bin/arm64/frpc_upx bin/so/arm64-v8a/libfrpc.so
cp -v bin/arm64/frps_upx bin/so/arm64-v8a/libfrps.so

mkdir bin/so/armeabi-v7a
cp -v bin/arm/frpc_upx bin/so/armeabi-v7a/libfrpc.so
cp -v bin/arm/frps_upx bin/so/armeabi-v7a/libfrps.so

mkdir bin/so/x86
cp -v bin/x86/frpc_upx bin/so/x86/libfrpc.so
cp -v bin/x86/frps_upx bin/so/x86/libfrps.so

mkdir bin/so/x86_64
cp -v bin/x86_64/frpc_upx bin/so/x86_64/libfrpc.so
cp -v bin/x86_64/frps_upx bin/so/x86_64/libfrps.so