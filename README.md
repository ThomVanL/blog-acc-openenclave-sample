# Azure Confidential Compute - Open Enclave Sample
This is the sample that was used in [my blog post](https://thomasvanlaere.com/posts/2020/06/azure-confidential-computing/) on Azure Confidential Compute. I based this sample on the existing [Open Enclave](https://openenclave.io/sdk/) samples to try to get a better understanding of how Intel SGX and Open Enclave work. It basically performs the addition of two numbers inside of an enclave, nothing fancy.

I highly recommend that you follow along the blog post since it assumes that you have Visual Studio Code's Remote Development extension installed and configured.

The sample can be improved upon since the numbers which are used to perform the addition are unencrypted in the host part of our application. You can imagine that you might want to use some sort of encrypted version of numberA and numberB and decrypt them within the enclave to perform the addition securely.

## Deploy an Azure Confidential Compute VM
Click the button to deploy a DCsv2-series VM, equiped with Intel SGX technology.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FThomVanL%2Facc-openenclave-sample%2Fmaster%2Fazure%2Fazuredeploy.json)
