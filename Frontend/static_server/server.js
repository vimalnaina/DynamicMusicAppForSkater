const express = require("express");
const path = require("path");

const app = express();

// 提供静态文件
app.use(express.static(path.join(__dirname, "build/web")));

// 处理所有路由，返回 index.html
app.get("*", (req, res) => {
  res.sendFile(path.join(__dirname, "build/web", "index.html"));
});

// 启动服务器
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Flutter Web app is running on http://localhost:${PORT}`);
});
