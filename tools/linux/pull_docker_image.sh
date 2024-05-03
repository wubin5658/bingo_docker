#!/bin/bash

# SYNOPSIS
# 拉取指定仓库的指定标签的最新 Docker 镜像。
# This script pulls the specified tag of a Docker image from the specified repository.

# DESCRIPTION
# 该脚本使用 Docker Hub 的 API 获取并拉取指定标签的 Docker 镜像。
# The script fetches and pulls a specified Docker image tag using Docker Hub's API.

# PARAMETER Repo
# 指定要拉取镜像的 Docker 仓库名称。
# Specifies the Docker repository to pull from.

# PARAMETER Tag
# 指定要拉取的镜像标签。
# Specifies the Docker image tag to pull.

# EXAMPLE
# ./pull_latest_tag_image.sh -Repo "wubin5658/bingo_alpha" -Tag "latest"
# 使用指定的仓库和标签执行脚本。
# Executes the script with a specified repository and tag.

# USAGE
# Ensure your network connection can access Docker Hub.
# Modify execution permissions if needed: chmod +x pull_latest_tag_image.sh

# Check if required arguments are passed
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 -Repo <repository> -Tag <tag>"
    exit 1
fi

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -Repo) Repo="$2"; shift ;;
        -Tag) Tag="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Get an authorization token to access the Docker Hub API
TOKEN_RESPONSE=$(curl -s "https://auth.docker.io/token?service=registry.docker.io&scope=repository:${Repo}:pull")
TOKEN=$(echo $TOKEN_RESPONSE | jq -r '.token')

# Use the token to pull the specified tag of the image
IMAGE="${Repo}:${Tag}"
echo "Pulling the image: ${IMAGE}"
docker pull ${IMAGE}
