# Azure Confidential Compute - Open Enclave Sample

This is the sample that was used in [my blog post](https://thomasvanlaere.com/posts/2020/06/azure-confidential-computing/) on Azure Confidential Compute. I based this sample on the existing [Open Enclave](https://openenclave.io/sdk/) samples to try to get a better understanding of how Intel SGX and Open Enclave work. It basically performs the addition of two numbers inside of an enclave, nothing fancy.

I highly recommend that you follow along the blog post since it assumes that you have Visual Studio Code's Remote Development extension installed and configured.

The sample can be improved upon since the numbers which are used to perform the addition are unencrypted in the host part of our application. You can imagine that you might want to use some sort of encrypted version of numberA and numberB and decrypt them within the enclave to perform the addition securely.

## Deploy an Azure Confidential Compute VM

The [Azure Linux Custom Script Extension Version 2](https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-linux) will attempt to download and execute the "```setup.sh```" script, which is included in "```azure```" directory, during the deployment.

The "```setup.sh```" script perform the following tasks:

- Configure APT Repositories
- Download the Intel SGX driver
- Install OpenEnclave 0.9.0 and its dependencies
  - Released 24 april 2020
- Install CMake 3.17.2

Click the button to deploy a DCsv2-series VM, equiped with Intel SGX technology.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FThomVanL%2Facc-openenclave-sample%2Fmaster%2Fazure%2Fazuredeploy.json)

## Connecting via VS Code

Visual Studio Code has quite a few wonderful extensions, one of them will allow us to use our SGX machine's capabilities as if we were using it as a local dev box! Open up your extensions in VS Code, search for "```ms-vscode-remote.vscode-remote-extensionpack```" and go ahead and install it.

Once installed you can connect to your SGX virtual machine by opening the command palette (ctrl/⌘-shift-P), typing "```Remote-SSH: Connect to Host```" and selecting "```+ Add new host```". You will be prompted to enter the SSH command, which you can retrieve from your Azure deployment output via the Azure Portal, it should be along the lines of "```ssh <username>@<public_ip>```". Once you have gotten confirmation that the host has been added, run "```Remote-SSH: Connect to Host```" once more and select the public IP from the list. A new VS Code window will pop up and ask you for your password. You should now be connected to your SGX VM.

Copy the "```SecretCalc```" directory to the VM and open the folder with VS Code (while still being remotely connected to your SGX VM), go ahead and install the recommended extensions. You should be able to launch (F5) the application with or without the extensions, although installing them should allow you to use the debugger.
