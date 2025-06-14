# Supply-Chain-Domain
# 🚗 Mint Classics Inventory Optimization – SQL Project

## 📘 Project Overview

**Mint Classics**, a retailer of classic model cars, is exploring the possibility of closing one of its warehouses to reduce operational costs. As a data analyst, the goal was to support this decision with data-driven insights by analyzing inventory, sales, warehouse performance, and customer satisfaction metrics using **MySQL Workbench**.

---

## 🧩 Business Scenario

Mint Classics operates multiple warehouses and needs to ensure:
- Timely shipment of customer orders (within 24 hours).
- Effective use of warehouse space.
- Elimination of non-performing products.
- Minimal impact on revenue and customer experience if a warehouse is closed.

---

## ❓ Problem Statement

> Can one of the warehouses be closed while maintaining service quality and minimizing excess inventory?

To answer this, the following key questions were explored:
1. **Which warehouse is underutilized and least profitable?**
2. **Are there products with high excess stock and low/negative profit?**
3. **Can we reorganize existing warehouses to absorb the products from the one being closed?**
4. **How quickly are orders being fulfilled, and are there any customer service concerns?**

---

## 🔍 Insights & Analysis

- **Warehouse D** was identified as the best candidate for closure based on low product volume, fewer customers served, and lowest revenue contribution.
- **Warehouse B** had several products with high excess stock and low profitability, making it suitable to absorb useful items from D after reorganization.
- Calculated **fulfillment days** to assess service efficiency.
- Identified **slow-moving products** and those **not sold in 6+ months**.
- Used `buyPrice` and `priceEach` to calculate **profit margins**.

---

## 🛠️ Technologies Used

- **MySQL Workbench**
- SQL (JOINs, CTEs, Aggregations, Stored Procedures)
- Data model with tables like `products`, `orderdetails`, `warehouses`, `orders`, etc.

---

## 📂 Files Included

- `mint_classics_analysis.sql` – All queries used with business question comments.
- `Mint_Classics_Report.docx` – Final report with insights and recommendations.
- `Buisness_Scenario.pdf`  – Pdf file containg the problem statement.

---

## ✅ Final Recommendation

- **Shut down Warehouse D.**
- **Clear non-profitable, excess inventory** in Warehouse B.
- **Transfer relevant stock from D to reorganized B.**
- **Maintain customer service levels by monitoring fulfillment times.**

This strategic action plan helps Mint Classics optimize warehouse operations without compromising on customer satisfaction.

---

## 👤 Submitted By

**Aadith**  
_Main SQL Project | Data Analytics_
