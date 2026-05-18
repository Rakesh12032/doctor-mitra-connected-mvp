const STATE_KEY = "doctor_mitra_state_v1";
let memoryState = null;

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
    bookings: [],
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

async function redis() {
  if (!process.env.UPSTASH_REDIS_REST_URL || !process.env.UPSTASH_REDIS_REST_TOKEN) {
    return null;
  }
  const { Redis } = await import("@upstash/redis");
  return Redis.fromEnv();
}

async function readState() {
  const client = await redis();
  if (!client) {
    memoryState ||= seedState();
    return memoryState;
  }

  const state = await client.get(STATE_KEY);
  if (state) return state;

  const seeded = seedState();
  await client.set(STATE_KEY, seeded);
  return seeded;
}

async function writeState(state) {
  const client = await redis();
  state.updatedAt = now();

  if (!client) {
    memoryState = state;
    return;
  }

  await client.set(STATE_KEY, state);
}

module.exports = async function handler(req, res) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Access-Control-Allow-Methods", "GET, PUT, POST, OPTIONS");
  res.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization");

  if (req.method === "OPTIONS") {
    res.status(204).end();
    return;
  }

  try {
    if (req.method === "GET") {
      res.status(200).json(await readState());
      return;
    }

    if (req.method === "PUT") {
      const state = typeof req.body === "string" ? JSON.parse(req.body || "{}") : req.body;
      if (!Array.isArray(state.users) || !Array.isArray(state.doctors) || !Array.isArray(state.bookings)) {
        res.status(400).json({ error: "Invalid Doctor Mitra state payload" });
        return;
      }
      await writeState(state);
      res.status(200).json({ ok: true, updatedAt: state.updatedAt });
      return;
    }

    if (req.method === "POST") {
      const seeded = seedState();
      await writeState(seeded);
      res.status(200).json(seeded);
      return;
    }

    res.status(405).json({ error: "Method not allowed" });
  } catch (error) {
    res.status(500).json({ error: error.message || "Server error" });
  }
};
