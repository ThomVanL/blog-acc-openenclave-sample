#!/bin/sh
set -e

# Azure Confidential Computing & OpenEnclave Sample
#
# See blog post: https://thomasvanlaere.com/posts/2020/06/azure-confidential-computing/
#
# This script will install components in order to
# run a very simple OpenEnclave sample. The sample was written for OpenEnclave 0.9.0
# and will install some other dependencies from when my blog post was written (June 2020).

echo "APT Repositories: configuring.."
echo 'deb [arch=amd64] https://download.01.org/intel-sgx/sgx_repo/ubuntu bionic main' | sudo tee /etc/apt/sources.list.d/intel-sgx.list
wget -qO - https://download.01.org/intel-sgx/sgx_repo/ubuntu/intel-sgx-deb.key | sudo apt-key add - > /dev/null 2>&1

echo "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-7 main" | sudo tee /etc/apt/sources.list.d/llvm-toolchain-bionic-7.list
wget -qO - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add - > /dev/null 2>&1

echo "deb [arch=amd64] https://packages.microsoft.com/ubuntu/18.04/prod bionic main" | sudo tee /etc/apt/sources.list.d/msprod.list
wget -qO - https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add - > /dev/null 2>&1

apt-get update -qq >/dev/null
echo "APT Repositories: configured!"

if [ -z '$(dmesg | grep -i intel_sgx)' ]; then
    echo "SGX driver: installing.."
    apt-get -qq -y install dkms >/dev/null

    # List of other SGX drivers versions: https://01.org/intel-software-guard-extensions/downloads
    wget https://download.01.org/intel-sgx/sgx-dcap/1.4/linux/distro/ubuntuServer18.04/sgx_linux_x64_driver_1.21.bin -O sgx_linux_x64_driver.bin
    chmod +x sgx_linux_x64_driver.bin
    ./sgx_linux_x64_driver.bin
    echo "SGX driver: installed!"
else
    echo "SGX driver: already installed!"
fi

echo "OpenEnclave 0.9.0 (24 april 2020) and dependencies: installing.."
apt-get -qq -y install clang-7 libssl-dev gdb libsgx-enclave-common libsgx-enclave-common-dev libprotobuf10 libsgx-dcap-ql libsgx-dcap-ql-dev az-dcap-client=1.4 open-enclave=0.9.0 >/dev/null
echo "OpenEnclave 0.9.0 (24 april 2020) and dependencies: installed!"

echo "CMAKE: installing version 3.17.2!"
wget https://github.com/Kitware/CMake/releases/download/v3.17.2/cmake-3.17.2-Linux-x86_64.sh
chmod u+x cmake-3.17.2-Linux-x86_64.sh
mkdir /opt/cmake
sh -c "DEBIAN_FRONTEND=noninteractive ./cmake-3.17.2-Linux-x86_64.sh --prefix=/opt/cmake --skip-license"
ln -s /opt/cmake/bin/ccmake /usr/local/bin/ccmake
ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake
ln -s /opt/cmake/bin/cpack /usr/local/bin/cpack
ln -s /opt/cmake/bin/ctest /usr/local/bin/ctest
echo "CMAKE: installed!"
