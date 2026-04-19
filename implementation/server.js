const express = require('express');
const mysql = require('mysql2');
const dotenv = require('dotenv');
const cors = require('cors');

dotenv.config();
const app = express();
app.use(cors());
app.use(express.json());

app.use((req, res, next) => {
    console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);
    next();
});

app.use(express.static(__dirname));

const db = mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASS,
    database: process.env.DB_NAME
});

db.connect((err) => {
    if (err) {
        console.error('Database connection failed: ' + err.stack);
        return;
    }
    console.log('Connected to the car_rental database.');
});

app.get('/vehicles', (req, res) => {
    db.query('SELECT * FROM Vehicles', (err, results) => {
        if (err) return res.status(500).json(err);
        res.json(results);
    });
});

app.post('/register', (req, res) => {
    const { full_name, email, password, role, phone_number, license_number } = req.body;
    const sql = "INSERT INTO Users (full_name, email, password, role, phone_number, license_number) VALUES (?, ?, ?, ?, ?, ?)";
    const values = [full_name, email, password, role || 'Customer', phone_number, license_number];
    db.query(sql, values, (err, result) => {
        if (err) return res.status(500).json(err);
        res.status(201).json({ message: "User registered successfully!", userId: result.insertId });
    });
});
app.post('/bookings', (req, res) => {
    const { user_id, vehicle_id, pickup_location_id, dropoff_location_id, pickup_date, return_date } = req.body;

    // 1. Basic Validation
    if (!user_id || !vehicle_id || !pickup_location_id || !dropoff_location_id || !pickup_date || !return_date) {
        return res.status(400).json({ message: "Missing required fields" });
    }

    const pickupMs = new Date(pickup_date).getTime();
    const returnMs = new Date(return_date).getTime();
    
    if (isNaN(pickupMs) || isNaN(returnMs)) {
        return res.status(400).json({ message: "Invalid date format" });
    }
    if (returnMs <= pickupMs) {
        return res.status(400).json({ message: "Return date must be after pickup date" });
    }

    // 2. Overlap Check (Is the car already busy?)
    const checkOverlap = `SELECT * FROM Bookings WHERE vehicle_id = ? AND status != 'Cancelled' AND NOT (return_date <= ? OR pickup_date >= ?)`;

    db.query(checkOverlap, [vehicle_id, pickup_date, return_date], (err, overlapResults) => {
        if (err) return res.status(500).json({ message: "Overlap check failed", error: err });
        if (overlapResults.length > 0) return res.status(400).json({ message: "Vehicle already booked for these dates!" });

        // 3. Get Vehicle Rate to calculate the Invoice
        db.query("SELECT daily_rate FROM Vehicles WHERE vehicle_id = ?", [vehicle_id], (err, vehicleResults) => {
            if (err) return res.status(500).json({ message: "Vehicle lookup failed", error: err });
            if (vehicleResults.length === 0) return res.status(404).json({ message: "Vehicle not found" });

            const dailyRate = vehicleResults[0].daily_rate;
            const diffDays = Math.ceil((returnMs - pickupMs) / (1000 * 60 * 60 * 24)) || 1; // Ensure at least 1 day
            const calculatedTotal = diffDays * dailyRate;

            // 4. Insert the Booking
            const bookingSql = `INSERT INTO Bookings (user_id, vehicle_id, pickup_location_id, dropoff_location_id, pickup_date, return_date, status) VALUES (?, ?, ?, ?, ?, ?, 'Pending')`;
            const bookingValues = [user_id, vehicle_id, pickup_location_id, dropoff_location_id, pickup_date, return_date];

            db.query(bookingSql, bookingValues, (err, result) => {
                if (err) return res.status(500).json({ message: "Booking insert failed", error: err });

                const newBookingId = result.insertId;

                // 5. AUTO-GENERATE INVOICE (The new part!)
                const invoiceSql = `INSERT INTO Invoices (booking_id, base_amount, security_deposit, payment_status) VALUES (?, ?, ?, 'Unpaid')`;
                const securityDeposit = 500.00; // You can adjust this value

                db.query(invoiceSql, [newBookingId, calculatedTotal, securityDeposit], (invErr) => {
                    if (invErr) {
                        console.error("Invoice generation failed:", invErr);
                        // We still return success for the booking, but warn about the invoice
                        return res.status(201).json({ 
                            message: "Booking successful, but invoice failed to generate.", 
                            bookingId: newBookingId 
                        });
                    }

                    // Success! Everything created.
                    res.status(201).json({ 
                        message: "Booking successful and Invoice generated!", 
                        bookingId: newBookingId, 
                        total_price: calculatedTotal, 
                        days: diffDays 
                    });
                });
            });
        });
    });
});
// --- LOGIN ROUTE ---
app.post('/login', (req, res) => {
    const { email, password } = req.body;

    if (!email || !password) {
        return res.status(400).json({ message: "Email and password are required" });
    }

    const sql = "SELECT user_id, full_name, role FROM Users WHERE email = ? AND password = ?";
    
    db.query(sql, [email, password], (err, results) => {
        if (err) return res.status(500).json({ message: "Database error", error: err });

        if (results.length === 0) {
            return res.status(401).json({ message: "Invalid email or password" });
        }

        const user = results[0];
        res.status(200).json({
            message: "Login successful!",
            user: {
                id: user.user_id,
                name: user.full_name,
                role: user.role
            }
        });
    });
});

// --- VIEW USER BOOKINGS (Using View) ---
app.get('/my-bookings/:user_id', (req, res) => {
    const userId = req.params.user_id;
    
    // Simple query because the 'JOIN' logic is hidden inside the view
    const sql = "SELECT * FROM CustomerBookingSummary WHERE user_id = ? ORDER BY pickup_date DESC";

    db.query(sql, [userId], (err, results) => {
        if (err) {
            console.error("Error fetching bookings from view:", err);
            return res.status(500).json({ message: "Error fetching trips" });
        }
        res.json(results);
    });
});

// --- UPDATE USER PROFILE ---
// GET USER PROFILE
app.get('/user/:user_id', (req, res) => {
    const userId = req.params.user_id;
    const sql = "SELECT full_name, email, phone_number, license_number FROM Users WHERE user_id = ?";
    db.query(sql, [userId], (err, results) => {
        if (err) return res.status(500).json(err);
        res.json(results[0]);
    });
});

// UPDATE USER PROFILE
app.put('/user/:id', (req, res) => {
    const userId = req.params.id;
    const { full_name, phone_number, license_number } = req.body;
    const sql = "UPDATE Users SET full_name = ?, phone_number = ?, license_number = ? WHERE user_id = ?";
    db.query(sql, [full_name, phone_number, license_number, userId], (err, result) => {
        if (err) return res.status(500).json(err);
        res.json({ message: "Profile updated!" });
    });
});

// --- STAFF/ADMIN: VIEW ALL BOOKINGS ---
app.get('/all-bookings', (req, res) => {
    const sql = `
        SELECT 
            b.booking_id, 
            u.full_name AS customer_name, 
            u.license_number,
            v.make, 
            v.model, 
            b.pickup_date, 
            b.return_date, 
            b.status 
        FROM Bookings b
        JOIN Users u ON b.user_id = u.user_id
        JOIN Vehicles v ON b.vehicle_id = v.vehicle_id
        ORDER BY b.pickup_date DESC`;

    db.query(sql, (err, results) => {
        if (err) return res.status(500).json({ message: "Error fetching all bookings", error: err });
        res.json(results);
    });
});

app.get('/invoices/:user_id', (req, res) => {
    const userId = req.params.user_id;
    const sql = `
        SELECT i.*, v.make, v.model 
        FROM Invoices i
        JOIN Bookings b ON i.booking_id = b.booking_id
        JOIN Vehicles v ON b.vehicle_id = v.vehicle_id
        WHERE b.user_id = ?`;

    db.query(sql, [userId], (err, results) => {
        if (err) return res.status(500).json(err);
        res.json(results);
    });
});

// --- CUSTOMER FLEET ROUTE (Uses View + Filtering/Sorting) ---
app.get('/fleet', (req, res) => {
    const { sort, color } = req.query;
    
    // We select from your VIEW 'AvailableFleet' instead of the table
    let sql = "SELECT * FROM AvailableFleet";
    let queryParams = [];
    let conditions = [];

    // 1. Filter by Color
    if (color && color !== 'all') {
        conditions.push("color = ?");
        queryParams.push(color);
    }

    if (conditions.length > 0) {
        sql += " WHERE " + conditions.join(" AND ");
    }

    // 2. Sort by Price
    if (sort === 'low') {
        sql += " ORDER BY daily_rate ASC";
    } else if (sort === 'high') {
        sql += " ORDER BY daily_rate DESC";
    }

    db.query(sql, queryParams, (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results);
    });
});

const multer = require('multer');
const path = require('path');
const fs = require('fs');

// Ensure 'uploads' folder exists
const uploadDir = './uploads';
if (!fs.existsSync(uploadDir)){
    fs.mkdirSync(uploadDir);
}

// Configure Storage
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, 'uploads/'); // The folder where files will stay
    },
    filename: (req, file, cb) => {
        // Rename: userId-timestamp.extension (e.g., 5-1712345678.jpg)
        const userId = req.body.user_id || 'unknown';
        cb(null, `${userId}-${Date.now()}${path.extname(file.originalname)}`);
    }
});

const upload = multer({ storage: storage });

// Add this so you can access the images via URL
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));


app.post('/documents', upload.single('documentFile'), (req, res) => {
    const { user_id, document_type } = req.body;
    const file_path = req.file ? req.file.path : null; // This is the real folder path

    if (!file_path) return res.status(400).json({ message: "No file uploaded" });

    const sql = "INSERT INTO Documents (user_id, document_type, file_path, verification_status) VALUES (?, ?, ?, 'Pending')";
    
    db.query(sql, [user_id, document_type, file_path], (err, result) => {
        if (err) return res.status(500).json(err);
        res.json({ message: "File uploaded successfully!", path: file_path });
    });
});


// --- GET ALL LOCATIONS FOR DROPDOWNS ---
app.get('/locations', (req, res) => {
    const sql = "SELECT location_id, branch_name FROM Locations";
    db.query(sql, (err, results) => {
        if (err) {
            console.error("Error fetching locations:", err);
            return res.status(500).json(err);
        }
        res.json(results);
    });
});

app.use((req, res) => {
    res.status(404).json({ message: `Route not found: ${req.method} ${req.url}` });
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
    console.log(`DriveFlow Server running on port ${PORT}`);
});