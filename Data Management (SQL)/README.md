---

# SEMBR-WTT Electric Bike Rental System  

This repository contains the design and implementation of a relational database system for **Southdowns Electric Mountain Bike Rental (SEMBR)**, in partnership with **Walk The Trails (WTT)**. The project addresses business requirements for bike rentals, maintenance, and partnerships, ensuring efficient operations, data integrity, and extensibility.

---

## 🚀 **Project Overview**

SEMBR rents electric mountain bikes for personal and business customers. They offer various hire durations (daily, weekly, monthly) and seasonal pricing. WTT is collaborating with SEMBR to offer bike rentals alongside self-guided bike tours.  

The project aims to:
- Minimize booking conflicts and enhance tracking.
- Manage bike inventory and service records.
- Provide detailed analytics on bike rentals and revenues.
- Facilitate seamless integration with WTT for tour bookings.

---

## 📝 **Features**

1. **Customer Management**  
   - Register customers, including ID verification for age compliance.  
   - Maintain customer contact and address details.

2. **Bike Inventory Management**  
   - Track bike availability, type, condition, and location.  
   - Manage service history and bike status (Available, Booked, In-Service).

3. **Booking System**  
   - Record and manage bike bookings with flexible rental durations.  
   - Calculate costs dynamically based on bike type, duration, and season.  

4. **Partnership Integration**  
   - Link bookings with WTT's holiday packages using unique WTT Reference IDs.  
   - Handle emergency repairs during tours, including bike replacements.

5. **Analytics & Reporting**  
   - Calculate total rentals and revenue by period, segregated by WTT and non-WTT bookings.  
   - Track the number of bikes on hire and their locations.

---

## 🛠️ **Database Schema**

### Key Tables
- **CustomerInformation**  
  Stores customer details and ID verification status.
  
- **Bike**  
  Manages bike inventory, condition, and current status.
  
- **Location**  
  Tracks bike pickup/dropoff points (Eastbourne and Winchester).
  
- **Staff**  
  Manages staff details across SEMBR and WTT.
  
- **Booking**  
  Records rental transactions with associated costs and durations.
  
- **Bike_Service_History**  
  Tracks service and repair history for each bike.
  
- **EmergencyRepairs**  
  Logs emergency repairs for WTT-related bookings.

### Relationships
- **CustomerInformation** ↔ **Booking**  
  Tracks rentals by customers.  
- **Bike** ↔ **Bike_Service_History**, **Booking**, **EmergencyRepairs**  
  Monitors usage and maintenance.  
- **Location** ↔ **Bike**, **Booking**  
  Tracks the current and historical locations of bikes.

---

## 📦 **Setup Instructions**

1. Clone the repository:  
   ```bash
   git clone https://github.com/AshrafNadir/Portfolio-Projects/tree/master/Data-Management(SQL).git
   cd Data-Management(SQL)
   ```

2. Import the database schema:  
   Use the SQL scripts in the `/Data-Management(SQL)` folder to create the database and tables.

3. Populate mock data:  
   Run the provided `SQLQueryLast.sql` to seed the database with example records.

4. Execute queries:  
   Test the business requirements and queries in your SQL environment.

---

## 🔍 **Validation Queries**

Here are some examples to validate key business requirements:

### 1. List bikes available for rent:
```sql
SELECT BikeID, BikeType, Overall_Condition, LocationID 
FROM Bike 
WHERE Bike_Status = 'Available';
```

### 2. Calculate total revenue for a given period:
```sql
SELECT 
    SUM(Total_Paid) AS TotalRevenue, 
    CASE 
        WHEN WTT_REF IS NULL THEN 'SEMBR' 
        ELSE 'WTT' 
    END AS Source 
FROM Booking 
WHERE Rental_Start BETWEEN '2023-01-01' AND '2023-12-31' 
GROUP BY CASE WHEN WTT_REF IS NULL THEN 'SEMBR' ELSE 'WTT' END;
```

### 3. Track bike locations:
```sql
SELECT BikeID, LocationID 
FROM Bike;
```

### 4. Emergency repair records for WTT bookings:
```sql
SELECT * 
FROM EmergencyRepairs 
WHERE WTT_REF IS NOT NULL;
```

---


## 🤝 **Contributing**

Contributions are welcome!  
Feel free to open issues or submit pull requests for improvements.

---
