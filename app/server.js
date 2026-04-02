const http = require("http");

// Get IMDSv2 token
function getToken() {
  return new Promise((resolve, reject) => {
    const req = http.request({
      method: "PUT",
      host: "169.254.169.254",
      path: "/latest/api/token",
      headers: {
        "X-aws-ec2-metadata-token-ttl-seconds": "21600"
      },
      timeout: 2000
    }, res => {
      let data = "";
      res.on("data", chunk => data += chunk);
      res.on("end", () => resolve(data));
    });

    req.on("error", reject);
    req.on("timeout", () => {
      req.destroy();
      reject(new Error("Token timeout"));
    });

    req.end();
  });
}

// Get metadata using token
function getMetadata(path, token) {
  return new Promise((resolve, reject) => {
    const req = http.get({
      host: "169.254.169.254",
      path: `/latest/meta-data/${path}`,
      headers: {
        "X-aws-ec2-metadata-token": token
      },
      timeout: 2000
    }, res => {
      let data = "";
      res.on("data", chunk => data += chunk);
      res.on("end", () => resolve(data));
    });

    req.on("error", reject);
    req.on("timeout", () => {
      req.destroy();
      reject(new Error("Metadata timeout"));
    });
  });
}

// Create server
const server = http.createServer(async (req, res) => {
  // Health check
  if (req.url.startsWith("/health")) {
    res.writeHead(200, { "Content-Type": "application/json" });
    return res.end(JSON.stringify({ status: "ok" }));
  }

  // Root route
  if (req.url === "/" || req.url.startsWith("/?")) {
    try {
      const token = await getToken(); // 

      const instanceId = await getMetadata("instance-id", token);
      const az = await getMetadata("placement/availability-zone", token);

      const response = {
        instance_id: instanceId,
        availability_zone: az,
        status: "healthy"
      };

      res.writeHead(200, { "Content-Type": "application/json" });
      res.end(JSON.stringify(response, null, 2));

    } catch (err) {
      // IMPORTANT: don’t return 500 (breaks ALB)
      res.writeHead(200);
      res.end("Metadata error: " + err.message);
    }
  } else {
    res.writeHead(404);
    res.end("Not Found");
  }
});

// Start server
server.listen(3000, "0.0.0.0", () => {
  console.log("Server running on port 3000");
});