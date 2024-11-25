# docker ps 美化 弃用
function dockerps() {
  docker ps "$1" --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
}
