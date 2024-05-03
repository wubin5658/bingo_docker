<#
.SYNOPSIS
列出指定 Docker 仓库的所有标签。
Lists all tags for a specified Docker repository.

.DESCRIPTION
该脚本使用 Docker Hub API 列出一个指定仓库的所有可用标签。
The script uses the Docker Hub API to list all available tags for a specified repository.

.PARAMETER RepoName
指定 Docker 仓库的名称，默认为 "wubin5658/bingo_alpha"。
Specifies the name of the Docker repository, default is "wubin5658/bingo_alpha".

.EXAMPLE
.\list-docker-tags.ps1 -RepoName "wubin5658/bingo_alpha"
列出 "wubin5658/bingo_alpha" 仓库的所有标签。
Lists all tags for the "wubin5658/bingo_alpha" repository.

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
    [string]$RepoName = "wubin5658/bingo_alpha"
)

# 获取授权令牌以访问 Docker Hub 的 API
# Obtain an authorization token to access the Docker Hub API
$tokenResponse = Invoke-RestMethod -Uri "https://auth.docker.io/token?service=registry.docker.io&scope=repository:${RepoName}:pull" -Method Get
$token = $tokenResponse.token

# 使用令牌从 Docker Hub 的 API 获取标签列表
# Use the token to get the list of tags from the Docker Hub API
$headers = @{
    Authorization = "Bearer $token"
}
$tagListUrl = "https://registry-1.docker.io/v2/$RepoName/tags/list"
try {
    $tagListResponse = Invoke-RestMethod -Uri $tagListUrl -Method Get -Headers $headers
    Write-Host "Tags for repository '$RepoName':"
    $tagListResponse.tags | ForEach-Object { Write-Host $_ }
} catch {
    Write-Host "Failed to retrieve tags or no tags found for repository '$RepoName'. Error: $_"
}
