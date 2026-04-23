const express = require('express');
const mysql = require('mysql2');
const dotenv = require('dotenv');
const cors = require('cors');
const path = require('path');
const multer = require('multer');
const fs = require('fs');

dotenv.config();
const app = express();
app.use(cors());
app.use(express.json());

// Logger
app.use((req, res, next) => {
    console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);
    next();
});

// ── STATIC FILES ──────────────────────────────────────────────
// Serve HTML files from the current folder
app.use(express.static(path.join(__dirname)));
// Serve uploaded files — THIS must come before any routes
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));


// ── DATABASE ──────────────────────────────────────────────────
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


// ── MULTER (File Upload) ──────────────────────────────────────
// Ensure uploads folder exists
const uploadDir = path.join(__dirname, 'uploads');
if (!fs.existsSync(uploadDir)) {
    fs.mkdirSync(uploadDir);
}

const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, uploadDir);
    },
    filename: (req, file, cb) => {
        const userId = req.body.user_id || 'unknown';
        cb(null, `${userId}-${Date.now()}${path.extname(file.originalname)}`);
    }
});

const upload = multer({ storage: storage });


// ── ROUTES ────────────────────────────────────────────────────

app.get('/vehicles', (req, res) => {
    db.query('SELECT * FROM Vehicles', (err, results) => {
        if (err) return res.status(500).json(err);
        res.json(results);
    });
});

app.post('/register', (req, res) => {
    const { full_name, email, password, role, phone_number } = req.body;
    const sql = "INSERT INTO Users (full_name, email, password, role, phone_number) VALUES (?, ?, ?, ?, ?)";
    const values = [full_name, email, password, role || 'Customer', phone_number];
    db.query(sql, values, (err, result) => {
        if (err) return res.status(500).json(err);
        res.status(201).json({ message: "User registered successfully!", userId: result.insertId });
    });
});

app.post('/bookings', (req, res) => {
    const { user_id, vehicle_id, pickup_location_id, dropoff_location_id, pickup_date, return_date } = req.body;

    if (!user_id || !vehicle_id || !pickup_location_id || !dropoff_location_id || !pickup_date || !return_date) {
        return res.status(400).json({ message: "Missing required fields" });
    }

    const pickupMs = new Date(pickup_date).getTime();
    const returnMs = new Date(return_date).getTime();

    if (isNaN(pickupMs) || isNaN(returnMs)) return res.status(400).json({ message: "Invalid date format" });
    if (returnMs <= pickupMs) return res.status(400).json({ message: "Return date must be after pickup date" });

    const checkOverlap = `SELECT * FROM Bookings WHERE vehicle_id = ? AND status != 'Cancelled' AND NOT (return_date <= ? OR pickup_date >= ?)`;

    db.query(checkOverlap, [vehicle_id, pickup_date, return_date], (err, overlapResults) => {
        if (err) return res.status(500).json({ message: "Overlap check failed", error: err });
        if (overlapResults.length > 0) return res.status(400).json({ message: "Vehicle already booked for these dates!" });

        db.query("SELECT daily_rate FROM Vehicles WHERE vehicle_id = ?", [vehicle_id], (err, vehicleResults) => {
            if (err) return res.status(500).json({ message: "Vehicle lookup failed", error: err });
            if (vehicleResults.length === 0) return res.status(404).json({ message: "Vehicle not found" });

            const dailyRate = vehicleResults[0].daily_rate;
            const diffDays = Math.ceil((returnMs - pickupMs) / (1000 * 60 * 60 * 24)) || 1;
            const calculatedTotal = diffDays * dailyRate;

            const bookingSql = `INSERT INTO Bookings (user_id, vehicle_id, pickup_location_id, dropoff_location_id, pickup_date, return_date, status) VALUES (?, ?, ?, ?, ?, ?, 'Pending')`;

            db.query(bookingSql, [user_id, vehicle_id, pickup_location_id, dropoff_location_id, pickup_date, return_date], (err, result) => {
                if (err) return res.status(500).json({ message: "Booking insert failed", error: err });

                const newBookingId = result.insertId;
                const invoiceSql = `INSERT INTO Invoices (booking_id, base_amount, security_deposit, payment_status) VALUES (?, ?, ?, 'Unpaid')`;

                db.query(invoiceSql, [newBookingId, calculatedTotal, 500.00], (invErr) => {
                    if (invErr) {
                        console.error("Invoice generation failed:", invErr);
                        return res.status(201).json({ message: "Booking successful, but invoice failed to generate.", bookingId: newBookingId });
                    }
                    res.status(201).json({ message: "Booking successful and Invoice generated!", bookingId: newBookingId, total_price: calculatedTotal, days: diffDays });
                });
            });
        });
    });
});

// --- LOGIN ---
app.post('/login', (req, res) => {
    const { email, password } = req.body;
    if (!email || !password) return res.status(400).json({ message: "Email and password are required" });

    const sql = "SELECT user_id, full_name, role FROM Users WHERE email = ? AND password = ?";
    db.query(sql, [email, password], (err, results) => {
        if (err) return res.status(500).json({ message: "Database error", error: err });
        if (results.length === 0) return res.status(401).json({ message: "Invalid email or password" });

        const user = results[0];
        res.status(200).json({
            message: "Login successful!",
            user: {
                user_id: user.user_id,
                full_name: user.full_name,
                role: user.role
            }
        });
    });
});

// --- MY BOOKINGS ---
app.get('/my-bookings/:user_id', (req, res) => {
    const sql = "SELECT * FROM CustomerBookingSummary WHERE user_id = ? ORDER BY pickup_date DESC";
    db.query(sql, [req.params.user_id], (err, results) => {
        if (err) return res.status(500).json({ message: "Error fetching trips" });
        res.json(results);
    });
});

// --- USER PROFILE ---
app.get('/user/:user_id', (req, res) => {
    const sql = "SELECT * FROM CustomerDetails WHERE user_id = ? ORDER BY document_id DESC LIMIT 1";
    db.query(sql, [req.params.user_id], (err, results) => {
        if (err) return res.status(500).json(err);
        if (results.length === 0) return res.status(404).json({ message: "User not found" });
        res.json(results[0]);
    });
});

// --- UPDATE PROFILE ---
app.put('/user/:id', (req, res) => {
    const { full_name, phone_number } = req.body;
    const sql = "UPDATE Users SET full_name = ?, phone_number = ? WHERE user_id = ?";
    db.query(sql, [full_name, phone_number, req.params.id], (err) => {
        if (err) return res.status(500).json(err);
        res.json({ message: "Profile updated successfully!" });
    });
});

// --- ALL BOOKINGS (Staff) ---
app.get('/all-bookings', (req, res) => {
    const sql = `
        SELECT b.booking_id, u.full_name AS customer_name,
            d.document_number AS license_number,
            v.make, v.model, b.pickup_date, b.return_date, b.status 
        FROM Bookings b
        JOIN Users u ON b.user_id = u.user_id
        JOIN Vehicles v ON b.vehicle_id = v.vehicle_id
        LEFT JOIN Documents d ON d.user_id = u.user_id
            AND d.document_type = 'Driving License'
            AND d.verification_status = 'Verified'
        ORDER BY b.pickup_date DESC
        `;
    db.query(sql, (err, results) => {
        if (err) return res.status(500).json({ message: "Error fetching all bookings", error: err });
        res.json(results);
    });
});

// --- CUSTOMER INVOICES ---
app.get('/invoices/:user_id', (req, res) => {
    const sql = `
        SELECT i.*, v.make, v.model 
        FROM Invoices i
        JOIN Bookings b ON i.booking_id = b.booking_id
        JOIN Vehicles v ON b.vehicle_id = v.vehicle_id
        WHERE b.user_id = ?`;
    db.query(sql, [req.params.user_id], (err, results) => {
        if (err) return res.status(500).json(err);
        res.json(results);
    });
});

// --- FLEET ---
app.get('/fleet', (req, res) => {
    const { sort, color } = req.query;
    let sql = "SELECT * FROM AvailableFleet";
    let queryParams = [];
    let conditions = [];

    if (color && color !== 'all') {
        conditions.push("color = ?");
        queryParams.push(color);
    }
    if (conditions.length > 0) sql += " WHERE " + conditions.join(" AND ");
    if (sort === 'low') sql += " ORDER BY daily_rate ASC";
    else if (sort === 'high') sql += " ORDER BY daily_rate DESC";

    db.query(sql, queryParams, (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results);
    });
});

// --- UPLOAD DOCUMENT ---
app.post('/documents', upload.single('documentFile'), (req, res) => {
    const { user_id, document_type, document_number, expiry_date } = req.body;

    if (!req.file) return res.status(400).json({ message: "No file uploaded." });

    const filePath = 'uploads/' + req.file.filename;

    const sql = "INSERT INTO Documents (user_id, document_type, document_number, expiry_date, file_path, verification_status) VALUES (?, ?, ?, ?, ?, 'Pending')";
    db.query(sql, [user_id, document_type, document_number || null, expiry_date, filePath], (err, result) => {
        if (err) return res.status(500).json(err);
        res.json({ message: "File uploaded successfully!", path: filePath });
    });
});

// --- LOCATIONS ---
app.get('/locations', (req, res) => {
    const sql = "SELECT location_id, branch_name, address FROM Locations";
    db.query(sql, (err, results) => {
        if (err) return res.status(500).json(err);
        res.json(results);
    });
});


// ════════════════════════════════════════════════════════════
// EMPLOYEE ROUTES
// ════════════════════════════════════════════════════════════

// 1. GET ALL DOCUMENTS
app.get('/employee/documents', (req, res) => {
    const sql = `
        SELECT 
            d.document_id,
            d.user_id,
            d.document_type,
            d.document_number,
            CONCAT('http://localhost:5000/', REPLACE(d.file_path, '\\\\', '/')) AS file_path,
            d.verification_status,
            d.expiry_date,
            u.full_name
        FROM Documents d
        JOIN Users u ON d.user_id = u.user_id
        ORDER BY 
            FIELD(d.verification_status, 'Pending', 'Verified', 'Rejected'),
            d.document_id DESC
    `;
    db.query(sql, (err, results) => {
        if (err) {
            console.error("Error fetching documents:", err);
            return res.status(500).json({ message: "Error fetching documents", error: err });
        }
        res.json(results);
    });
});

// 2. VERIFY / REJECT A DOCUMENT
app.put('/employee/documents/:id/verify', (req, res) => {
    const docId = req.params.id;
    const { status, employee_id } = req.body;

    if (!['Verified', 'Rejected'].includes(status)) {
        return res.status(400).json({ message: "Invalid status." });
    }
    if (!employee_id) {
        return res.status(400).json({ message: "employee_id is required." });
    }

    const sql = `UPDATE Documents SET verification_status = ?, verified_by = ?, verified_at = NOW() WHERE document_id = ?`;
    db.query(sql, [status, employee_id, docId], (err, result) => {
        if (err) return res.status(500).json({ message: "Failed to update document", error: err });
        if (result.affectedRows === 0) return res.status(404).json({ message: "Document not found." });
        res.json({ message: `Document ${status} successfully.` });
    });
});

// 3. GET ALL INVOICES
app.get('/employee/invoices', (req, res) => {
    const sql = `
        SELECT 
            i.invoice_id, i.booking_id, i.base_amount, i.late_fees,
            i.security_deposit, i.payment_status, i.issued_at,
            u.full_name, u.user_id,
            d.document_number AS license_number,
            (
                SELECT d2.verification_status 
                FROM Documents d2 
                WHERE d2.user_id = u.user_id 
                AND d2.document_type = 'Driving License'
                AND d2.verification_status = 'Verified'
                LIMIT 1
            ) AS license_verified
        FROM Invoices i
        JOIN Bookings b ON i.booking_id = b.booking_id
        JOIN Users u ON b.user_id = u.user_id
        LEFT JOIN Documents d ON d.user_id = u.user_id        
            AND d.document_type = 'Driving License'           
            AND d.verification_status = 'Verified'            
        ORDER BY FIELD(i.payment_status, 'Unpaid', 'Paid'), i.issued_at DESC
    `;
    db.query(sql, (err, results) => {
        if (err) return res.status(500).json({ message: "Error fetching invoices", error: err });
        res.json(results);
    });
});

// 4. MARK INVOICE AS PAID
app.put('/employee/invoices/:id/pay', (req, res) => {
    const invoiceId = req.params.id;

    const checkSql = `
        SELECT i.invoice_id, i.payment_status, u.user_id,
            (
                SELECT d.verification_status 
                FROM Documents d 
                WHERE d.user_id = u.user_id 
                  AND d.document_type = 'Driving License'
                  AND d.verification_status = 'Verified'
                LIMIT 1
            ) AS license_verified
        FROM Invoices i
        JOIN Bookings b ON i.booking_id = b.booking_id
        JOIN Users u ON b.user_id = u.user_id
        WHERE i.invoice_id = ?
    `;

    db.query(checkSql, [invoiceId], (err, results) => {
        if (err) return res.status(500).json({ message: "Database error", error: err });
        if (results.length === 0) return res.status(404).json({ message: "Invoice not found." });

        const invoice = results[0];
        if (invoice.payment_status === 'Paid') return res.status(400).json({ message: "Invoice already Paid." });
        if (invoice.license_verified !== 'Verified') {
            return res.status(403).json({ message: "Cannot mark as paid. Customer does not have a verified Driving License." });
        }

        db.query("UPDATE Invoices SET payment_status = 'Paid' WHERE invoice_id = ?", [invoiceId], (err2) => {
            if (err2) return res.status(500).json({ message: "Failed to update invoice", error: err2 });
            res.json({ message: "Invoice marked as Paid successfully." });
        });
    });
});

// 5. GET BOOKINGS FOR INSPECTION
app.get('/employee/inspections', (req, res) => {
    const sql = `
        SELECT 
            b.booking_id, b.status, b.pickup_date, b.return_date,
            b.vehicle_id, b.dropoff_location_id,
            u.full_name, u.user_id,
            v.make, v.model, v.year, v.license_plate, v.current_mileage,
            i.invoice_id
        FROM Bookings b
        JOIN Users u ON b.user_id = u.user_id
        JOIN Vehicles v ON b.vehicle_id = v.vehicle_id
        LEFT JOIN Invoices i ON i.booking_id = b.booking_id
        WHERE b.status IN ('Confirmed', 'Active')
        ORDER BY b.pickup_date ASC
    `;
    db.query(sql, (err, results) => {
        if (err) return res.status(500).json({ message: "Error fetching bookings", error: err });
        res.json(results);
    });
});

// 6. SUBMIT INSPECTION
app.post('/employee/inspections', (req, res) => {
    const { booking_id, employee_id, inspection_type, fuel_level, mileage_reading, damage_notes, vehicle_id, new_location_id, late_fees, invoice_id } = req.body;

    if (!booking_id || !employee_id || !inspection_type || !mileage_reading || !vehicle_id) {
        return res.status(400).json({ message: "Missing required fields." });
    }
    if (!['Check-Out', 'Check-In'].includes(inspection_type)) {
        return res.status(400).json({ message: "inspection_type must be 'Check-Out' or 'Check-In'." });
    }

    const inspSql = `INSERT INTO Inspections (booking_id, employee_id, inspection_type, fuel_level, mileage_reading, damage_notes) VALUES (?, ?, ?, ?, ?, ?)`;

    db.query(inspSql, [booking_id, employee_id, inspection_type, fuel_level, mileage_reading, damage_notes || ''], (err) => {
        if (err) return res.status(500).json({ message: "Failed to save inspection.", error: err });

        if (inspection_type === 'Check-Out') {
            db.query("UPDATE Vehicles SET status = 'Rented', current_mileage = ? WHERE vehicle_id = ?", [mileage_reading, vehicle_id], (err2) => {
                if (err2) return res.status(500).json({ message: "Failed to update vehicle.", error: err2 });
                db.query("UPDATE Bookings SET status = 'Active' WHERE booking_id = ?", [booking_id], (err3) => {
                    if (err3) return res.status(500).json({ message: "Failed to update booking.", error: err3 });
                    res.json({ message: "Check-Out complete. Vehicle marked as Rented." });
                });
            });

        } else {
            if (!new_location_id) return res.status(400).json({ message: "new_location_id is required for Check-In." });

            const actualReturn = new Date().toISOString().slice(0, 19).replace('T', ' ');

            db.query("UPDATE Vehicles SET status = 'Available', current_mileage = ?, current_location_id = ? WHERE vehicle_id = ?",
                [mileage_reading, new_location_id, vehicle_id], (err2) => {
                if (err2) return res.status(500).json({ message: "Failed to update vehicle.", error: err2 });

                db.query("UPDATE Bookings SET status = 'Completed', actual_return_date = ? WHERE booking_id = ?",
                    [actualReturn, booking_id], (err3) => {
                    if (err3) return res.status(500).json({ message: "Failed to update booking.", error: err3 });

                    const feesToAdd = parseFloat(late_fees) || 0;
                    if (feesToAdd > 0 && invoice_id) {
                        db.query("UPDATE Invoices SET late_fees = ? WHERE invoice_id = ?", [feesToAdd, invoice_id], (err4) => {
                            if (err4) console.error("Late fees update failed:", err4);
                            res.json({ message: `Check-In complete. Late fees PKR ${feesToAdd} added.` });
                        });
                    } else {
                        res.json({ message: "Check-In complete. Vehicle marked as Available." });
                    }
                });
            });
        }
    });
});


// ── 404 HANDLER (must be last) ────────────────────────────────
app.use((req, res) => {
    res.status(404).json({ message: `Route not found: ${req.method} ${req.url}` });
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
    console.log(`DriveFlow Server running on port ${PORT}`);
});