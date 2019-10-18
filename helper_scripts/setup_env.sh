#! /bin/bash
# Install kernel devel, numactl numactl-devel

DPDK_MAJOR_VERSION=18
DPDK_MINOR_VERSION=11
DPDK_PATCH_VERSION=2

DPDK_TAR=dpdk-"$DPDK_MAJOR_VERSION"."$DPDK_MINOR_VERSION"."$DPDK_PATCH_VERSION".tar
DPDK_TAR_XZ="$DPDK_TAR".xz
DPDK_TAR_GZIP="$DPDK_TAR".gz

CUR_ROOT=`pwd`

DOWNLOAD_DIR=$CUR_ROOT

echo "Downloading dpdk library..."
wget https://fast.dpdk.org/rel/"$DPDK_TAR_XZ"
mv $DPDK_TAR_XZ $DOWNLOAD_DIR/$DPDK_TAR_XZ

pushd $CUR_ROOT
pushd $DOWNLOAD_DIR

unxz "$DPDK_TAR_XZ"
tar -xvf $DPDK_TAR

#Delete the tar
rm -f $DPDK_TAR

DPDK_DIR=$(ls | grep "dpdk")
pushd $DPDK_DIR

#Create dpdk config file
cp config/defconfig_x86_64-native-linuxapp-gcc config/defconfig_x86_64-default-linuxapp-gcc
sed -i 's/native/default/g' config/defconfig_x86_64-default-linuxapp-gcc

echo "Compiling DPDK$DPDK_MAJOR_VERSION.$DPDK_MINOR_VERSION.$DPDK_PATCH_VERSION"
make install T=x86_64-default-linuxapp-gcc EXTRA_CFLAGS="-O3 -g -fPIC" > /dev/null
popd

mv $DPDK_DIR $DOWNLOAD_DIR/dpdk/

export RTE_TARGET=x86_64-default-linuxapp-gcc
export RTE_SDK=$DOWNLOAD_DIR/dpdk/
