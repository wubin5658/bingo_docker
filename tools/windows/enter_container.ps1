param (
    # 必须参数：Docker 镜像名
    # Mandatory parameter: Docker image name
    [Parameter(Mandatory=$true)]
    [string]$DockerImage
)

# 检查是否存在名为 'bingo_dev' 的容器
# Check if a container named 'bingo_dev' already exists
$existingContainer = docker ps -a --filter "name=bingo_dev" --format "{{.Names}}"

if ("$existingContainer" -eq "bingo_dev") {
    # 如果容器已存在，记录警告并删除旧容器
    # If the container exists, log a warning and remove the old container
    Write-Warning "Warning: Container 'bingo_dev' already exists. It will be removed and recreated."
    docker rm -f bingo_dev
}

# 获取当前宿主机路径
# Get the current host path
$currentPath = Get-Location

# 创建并启动容器，绑定路径
# Create and start the container, bind the path
docker run -it -u bingo --name bingo_dev -v ${currentPath}:/bingo ${DockerImage}
