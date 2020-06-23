A snippet from my [blog post](https://thomasvanlaere.com/posts/2020/06/azure-confidential-computing/) on Azure Confidential Compute.

### Installing Open Enclave on Linux
To install Open Enclave on Ubuntu 18.04 we will need to carefully follow the instructions that were provided by the Open Enclave team. SSH into the VM using your client of choice and we will start by configuring the Intel and Microsoft APT Repositories. If you wish to connect via the Cloud Shell's SSH functionality, you will need to add its IP to the NSG SSH rule.

```sh
echo 'deb [arch=amd64] https://download.01.org/intel-sgx/sgx_repo/ubuntu bionic main' | sudo tee /etc/apt/sources.list.d/intel-sgx.list
wget -qO - https://download.01.org/intel-sgx/sgx_repo/ubuntu/intel-sgx-deb.key | sudo apt-key add -

echo "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-7 main" | sudo tee /etc/apt/sources.list.d/llvm-toolchain-bionic-7.list
wget -qO - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -

echo "deb [arch=amd64] https://packages.microsoft.com/ubuntu/18.04/prod bionic main" | sudo tee /etc/apt/sources.list.d/msprod.list
wget -qO - https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
````

Remember that Azure attestation service that allows for remote attestation? Next, you will need to install the Intel SGX DCAP driver, followed by installing the Intel and Open Enclave packages and dependencies:

```sh
sudo apt update
sudo apt -y install dkms
wget https://download.01.org/intel-sgx/sgx-dcap/1.4/linux/distro/ubuntuServer18.04/sgx_linux_x64_driver_1.21.bin -O sgx_linux_x64_driver.bin
chmod +x sgx_linux_x64_driver.bin
sudo ./sgx_linux_x64_driver.bin

sudo apt -y install clang-7 libssl-dev gdb libsgx-enclave-common libsgx-enclave-common-dev libprotobuf10 libsgx-dcap-ql libsgx-dcap-ql-dev az-dcap-client open-enclave
```

Open Enclave, v0.9.0 at the time of writing, requires CMake version 3.12 or higher so I installed it like so:

```sh
wget https://github.com/Kitware/CMake/releases/download/v3.17.2/cmake-3.17.2-Linux-x86_64.sh
chmod u+x cmake-3.17.2-Linux-x86_64.sh
sudo mkdir /opt/cmake
sudo sh cmake-3.17.2-Linux-x86_64.sh --prefix=/opt/cmake --skip-license

sudo ln -s /opt/cmake/bin/ccmake /usr/local/bin/ccmake
sudo ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake
sudo ln -s /opt/cmake/bin/cpack /usr/local/bin/cpack
sudo ln -s /opt/cmake/bin/ctest /usr/local/bin/ctest
```

### VS Code setup
Visual Studio Code has quite a few wonderful extensions, one of them will allow us to use our SGX machine's capabilities as if we were using it as a local dev box! Open up your extensions in VS Code, search for "```ms-vscode-remote.vscode-remote-extensionpack```" and go ahead and install it.

Once installed you can connect to your SGX virtual machine by opening the command palette (ctrl/⌘-shift-P), typing "```Remote-SSH: Connect to Host```" and selecting "```+ Add new host```". You will be prompted to enter the SSH command, which you can retrieve from your Azure deployment output via the Azure Portal, it should be along the lines of "```ssh <username>@<public_ip>```". Once you have gotten confirmation that the host has been added, run "```Remote-SSH: Connect to Host```" once more and select the public IP from the list. A new VS Code window will pop up and ask you for your password. You should now be connected to your SXG VM.

We will still have to go through some additional ceremony to get everything working nicely. __Our remote environment__ currently does not have the required VS Code extensions installed, more specifically we need to install the following extensions:
- ms-vscode.cpptools (C/C++)
- twxs.cmake (Cmake)
- ms-vscode.cmake-tools (Cmake tools)
- webfreak.debug (Native Debug)

There is also an Open Enclave extension for VS Code (ms-iot.msiot-vscode-openenclave) which is currently sitting at version 1.0.10 in the Visual Studio marketplace and has no support for Intel SGX on Linux. Upon inspecting the Open Enclave Github repo's master branch, I noticed that the VS code extension was marked as version 2.0 and supports Intel SGX on Linux. However, unless I'm mistaken I cannot seem to get version 2.0 from the VS marketplace and thus I opted to look at the extension's source code and "manually add support".

I figured that even if I overlooked something in regards to the V2 extension, I'd get a more solid understanding of what it takes to set up a new Open Enclave project.