#!/bin/bash

# 摘要
# 列出指定 Docker 仓库的所有标签。
# SYNOPSIS
# Lists all tags for a specified Docker repository.

# 描述
# 该脚本使用 Docker Hub API 列出一个指定仓库的所有可用标签。
# DESCRIPTION
# The script uses the Docker Hub API to list all available tags for a specified repository.

# 参数 RepoName
# 指定 Docker 仓库的名称，默认为 "wubin5658/bingo_alpha"。
# PARAMETER RepoName
# Specifies the name of the Docker repository, default is "wubin5658/bingo_alpha".

# 示例
# ./list-docker-tags.sh "wubin5658/bingo_alpha"
# 列出 "wubin5658/bingo_alpha" 仓库的所有标签。
# EXAMPLE
# ./list-docker-tags.sh "wubin5658/bingo_alpha"
# Lists all tags for the "wubin5658/bingo_alpha" repository.

# 注意
# 确保您的网络连接可以访问 Docker Hub。
# 如果遇到脚本执行权限错误，您可能需要调整您的执行权限。
# NOTES
# Ensure your network connection can access Docker Hub.
# If you encounter a script execution policy error, you might need to adjust your execution permissions.

# 默认仓库名称
# Default repository name
RepoName=${1:-"wubin5658/bingo_alpha"}

# 获取授权令牌以访问 Docker Hub 的 API
# Obtain an authorization token to access the Docker Hub API
TOKEN_RESPONSE=$(curl -s "https://auth.docker.io/token?service=registry.docker.io&scope=repository:${RepoName}:pull")
TOKEN=$(echo $TOKEN_RESPONSE | jq -r '.token')

# 使用令牌从 Docker Hub 的 API 获取标签列表
# Use the token to get the list of tags from the Docker Hub API
TAG_LIST_URL="https://registry-1.docker.io/v2/${RepoName}/tags/list"

# 尝试使用令牌检索标签
# Try to retrieve tags using the token
TAG_LIST_RESPONSE=$(curl -s -H "Authorization: Bearer ${TOKEN}" "${TAG_LIST_URL}")
if [ $? -eq 0 ]; then
    echo "Tags for repository '${RepoName}':"
    echo $TAG_LIST_RESPONSE | jq -r '.tags[]'
else
    echo "Failed to retrieve tags or no tags found for repository '${RepoName}'."
fi
