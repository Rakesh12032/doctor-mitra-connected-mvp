module.exports = async function handler(req, res) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Access-Control-Allow-Methods", "GET, OPTIONS");
  res.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization");

  if (req.method === "OPTIONS") {
    res.status(204).end();
    return;
  }

  res.status(200).json({
    ok: true,
    service: "doctor-mitra-api",
    storage: process.env.UPSTASH_REDIS_REST_URL ? "upstash-redis" : "memory-fallback",
    time: new Date().toISOString()
  });
};
