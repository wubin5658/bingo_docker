<#
.SYNOPSIS
拉取指定仓库的指定标签的最新 Docker 镜像。
This script pulls the specified tag of a Docker image from the specified repository.

.DESCRIPTION
该脚本使用 Docker Hub 的 API 获取并拉取指定标签的 Docker 镜像。
The script fetches and pulls a specified Docker image tag using Docker Hub's API.
需要修改 PowerShell 的执行策略如果脚本因安全设置被限制运行。
It requires modifying PowerShell's execution policy if the script is restricted from running due to security settings.

.PARAMETER Repo
指定要拉取镜像的 Docker 仓库名称。
Specifies the Docker repository to pull from.

.PARAMETER Tag
指定要拉取的镜像标签。
Specifies the Docker image tag to pull.

.EXAMPLE
.\pull_latest_tag_image.ps1 -Repo "wubin5658/bingo_alpha" -Tag "latest"
使用指定的仓库和标签执行脚本。
Executes the script with a specified repository and tag.

.NOTES
确保您的网络连接可以访问 Docker Hub。
Ensure your network connection can access Docker Hub.
如果遇到脚本执行策略错误，您可能需要更改您的 PowerShell 执行策略。
If you encounter a script execution policy error, you might need to change your PowerShell execution policy.
下面是几种修改执行策略的方法：
Here are a few methods to modify the execution policy:

1. 为当前会话临时更改：
   Temporarily for the session:
   Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process

2. 为当前用户永久更改：
   Permanently for the current user:
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

3. 为所有用户永久更改（需要管理员权限）：
   Permanently for all users (requires admin rights):
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine

选择一个适合您安全需求的执行策略。一般推荐使用 'RemoteSigned'。
Choose an execution policy that suits your security needs. 'RemoteSigned' is generally recommended for safety.
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$Repo,

    [Parameter(Mandatory=$true)]
    [string]$Tag
)

# 获取授权令牌以访问 Docker Hub 的 API
# Obtain an authorization token to access the Docker Hub API
$tokenResponse = Invoke-RestMethod -Uri "https://auth.docker.io/token?service=registry.docker.io&scope=repository:${Repo}:pull" -Method Get
$token = $tokenResponse.token

# 使用令牌拉取指定标签的镜像
# Use the token to pull the specified tag of the image
$image = "${Repo}:${Tag}"
Write-Host "Pulling the image: ${image}"
docker pull $image
