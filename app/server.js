const http = require("http");

const METADATA_BASE = "http://169.254.169.254/latest/meta-data/";

async function getMetadata(path) {
  return new Promise((resolve, reject) => {
    http.get(METADATA_BASE + path, (res) => {
      let data = "";
      res.on("data", chunk => data += chunk);
      res.on("end", () => resolve(data));
    }).on("error", reject);
  });
}

const server = http.createServer(async (req, res) => {
  if (req.url === "/health") {
  res.writeHead(200, { "Content-Type": "application/json" });
  return res.end(JSON.stringify({ status: "ok" }));
}

  if (req.url === "/") {
    try {
      const instanceId = await getMetadata("instance-id");
      const az = await getMetadata("placement/availability-zone");

      const response = {
        instance_id: instanceId,
        availability_zone: az,
        status: "healthy"
      };

      res.writeHead(200, { "Content-Type": "application/json" });
      res.end(JSON.stringify(response, null, 2));
    } catch (err) {
      res.writeHead(500);
      res.end("Error fetching metadata");
    }
  } else {
    res.writeHead(404);
    res.end("Not Found");
  }
});

server.listen(3000, () => {
  console.log("Server running on port 3000");
});