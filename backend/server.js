const http = require("http");
const fs = require("fs");
const path = require("path");

const port = Number(process.env.PORT || 8080);
const dataDir = process.env.DATA_DIR || path.join(__dirname, "data");
const dataFile = path.join(dataDir, "doctor_mitra_state.json");

function now() {
  return new Date().toISOString();
}

function seedState() {
  return {
    currentUserId: null,
    maintenanceMode: false,
    users: [
      {
        id: "admin-1",
        role: "admin",
        name: "Doctor Mitra Admin",
        mobile: "",
        email: "admin@doctormitra.in",
        password: "admin123",
        district: "Patna",
        createdAt: now()
      },
      {
        id: "patient-1",
        role: "patient",
        name: "Rakesh Kumar",
        mobile: "9876543210",
        email: "",
        district: "Patna",
        createdAt: now()
      },
      {
        id: "doctor-user-1",
        role: "doctor",
        name: "Dr. Rajeev Kumar",
        mobile: "9000000001",
        email: "rajeev@doctormitra.in",
        password: "doctor123",
        district: "Patna",
        createdAt: now()
      }
    ],
    doctors: [
      {
        id: "doctor-1",
        userId: "doctor-user-1",
        name: "Dr. Rajeev Kumar",
        specialty: "General Physician",
        degree: "MBBS, MD (Medicine)",
        experience: 15,
        registrationNumber: "BRMC-10234",
        clinicName: "Aarogya Clinic",
        address: "Boring Road, Patna",
        district: "Patna",
        fee: 400,
        onlineFee: 250,
        rating: 4.7,
        reviews: 312,
        status: "approved",
        isOnlineAvailable: true,
        slots: ["09:00", "09:30", "10:00", "10:30", "17:00", "17:30"]
      }
    ],
    bookings: [
      {
        id: "booking-1",
        patientId: "patient-1",
        doctorId: "doctor-1",
        patientName: "Rakesh Kumar",
        patientMobile: "9876543210",
        type: "clinic",
        date: "19 May 2026",
        time: "09:00",
        symptoms: "Fever and body pain",
        fee: 400,
        status: "pending",
        createdAt: now()
      }
    ],
    hospitals: [
      {
        id: "hospital-1",
        name: "Patna City Hospital",
        district: "Patna",
        address: "Bailey Road, Patna",
        phone: "0612-2200001",
        type: "Multispeciality"
      }
    ],
    ambulances: [
      {
        id: "amb-1",
        name: "Bihar Emergency 102",
        district: "All Bihar",
        phone: "102",
        isAvailable: true
      }
    ],
    healthCards: [
      {
        id: "hc-1",
        userId: "patient-1",
        bloodGroup: "O+",
        allergies: "Dust, Penicillin",
        medications: "None",
        emergencyContact: "9876543211"
      }
    ],
    notifications: [],
    prescriptions: [],
    specialties: [
      "General Physician",
      "Gynecologist",
      "Cardiologist",
      "Dermatologist",
      "Neurologist",
      "Dentist"
    ],
    healthTips: [
      "Drink safe water and keep ORS at home.",
      "Book follow-ups early for chronic conditions.",
      "Use emergency number 102 for ambulance help."
    ]
  };
}

function ensureState() {
  fs.mkdirSync(dataDir, { recursive: true });
  if (!fs.existsSync(dataFile)) {
    fs.writeFileSync(dataFile, JSON.stringify(seedState(), null, 2));
  }
}

function readState() {
  ensureState();
  return JSON.parse(fs.readFileSync(dataFile, "utf8"));
}

function writeState(state) {
  fs.mkdirSync(dataDir, { recursive: true });
  fs.writeFileSync(dataFile, JSON.stringify(state, null, 2));
}

function readBody(req) {
  return new Promise((resolve, reject) => {
    let body = "";
    req.on("data", (chunk) => {
      body += chunk;
      if (body.length > 10_000_000) {
        reject(new Error("Payload too large"));
        req.destroy();
      }
    });
    req.on("end", () => resolve(body));
    req.on("error", reject);
  });
}

function send(res, status, payload) {
  res.writeHead(status, {
    "Content-Type": "application/json; charset=utf-8",
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "GET, PUT, POST, OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type, Authorization"
  });
  res.end(JSON.stringify(payload));
}

const server = http.createServer(async (req, res) => {
  if (req.method === "OPTIONS") {
    send(res, 204, {});
    return;
  }

  try {
    if (req.method === "GET" && req.url === "/health") {
      send(res, 200, { ok: true, service: "doctor-mitra-api", time: now() });
      return;
    }

    if (req.method === "GET" && req.url === "/api/state") {
      send(res, 200, readState());
      return;
    }

    if (req.method === "PUT" && req.url === "/api/state") {
      const body = await readBody(req);
      const state = JSON.parse(body || "{}");
      if (!Array.isArray(state.users) || !Array.isArray(state.doctors) || !Array.isArray(state.bookings)) {
        send(res, 400, { error: "Invalid Doctor Mitra state payload" });
        return;
      }
      state.updatedAt = now();
      writeState(state);
      send(res, 200, { ok: true, updatedAt: state.updatedAt });
      return;
    }

    if (req.method === "POST" && req.url === "/api/reset") {
      const state = seedState();
      writeState(state);
      send(res, 200, state);
      return;
    }

    send(res, 404, { error: "Not found" });
  } catch (error) {
    send(res, 500, { error: error.message || "Server error" });
  }
});

server.listen(port, () => {
  ensureState();
  console.log(`Doctor Mitra API running on port ${port}`);
});
