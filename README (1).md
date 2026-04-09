# PlatinumRx Data Analyst Assignment

## Project Overview
Complete solution for the PlatinumRx Data Analyst Assignment covering SQL, Spreadsheets, and Python proficiency.

---

## Folder Structure
```
Data_Analyst_Assignment/
├── SQL/
│   ├── 01_Hotel_Schema_Setup.sql   ← DB + tables + sample data for Hotel system
│   ├── 02_Hotel_Queries.sql        ← Answers to Hotel Part A (Q1–Q5)
│   ├── 03_Clinic_Schema_Setup.sql  ← DB + tables + sample data for Clinic system
│   └── 04_Clinic_Queries.sql       ← Answers to Clinic Part B (Q1–Q5)
├── Spreadsheets/
│   └── Ticket_Analysis.xlsx        ← 3-sheet workbook with data + formulas
├── Python/
│   ├── 01_Time_Converter.py        ← Minutes → "X hrs Y minutes"
│   └── 02_Remove_Duplicates.py     ← Remove duplicate chars from a string
└── README.md
```

---

## Phase 1 – SQL

### Tools Required
- MySQL 8+ (or any RDBMS supporting Window Functions)
- Alternatively: DB Fiddle / SQLiteOnline

### How to Run
1. Open MySQL Workbench or your preferred SQL client.
2. Run `01_Hotel_Schema_Setup.sql` first — this creates `hotel_db`, all tables, and inserts sample data.
3. Run `02_Hotel_Queries.sql` to execute the 5 Hotel queries.
4. Run `03_Clinic_Schema_Setup.sql` — creates `clinic_db`, all tables, and inserts sample data.
5. Run `04_Clinic_Queries.sql` to execute the 5 Clinic queries.

### Key Techniques Used
| Query | Technique |
|-------|-----------|
| Hotel Q1 – Last booked room | Correlated sub-query + `ROW_NUMBER()` |
| Hotel Q2 – Nov 2021 billing | `JOIN` + `SUM(qty × rate)` + `GROUP BY` |
| Hotel Q3 – Bills > 1000 | `GROUP BY bill_id` + `HAVING` |
| Hotel Q4 – Most/Least ordered item | CTE + `RANK()` window function |
| Hotel Q5 – 2nd highest bill | CTE + `DENSE_RANK()` window function |
| Clinic Q1 – Revenue by channel | `GROUP BY sales_channel` + `SUM` |
| Clinic Q2 – Top 10 customers | `SUM` + `ORDER BY DESC` + `LIMIT 10` |
| Clinic Q3 – Monthly P&L | Two CTEs joined → Profit = Revenue − Expense |
| Clinic Q4 – Most profitable per city | CTE + `RANK() OVER (PARTITION BY city)` |
| Clinic Q5 – 2nd least profitable per state | CTE + `RANK() OVER (PARTITION BY state ORDER BY profit ASC)` |

---

## Phase 2 – Spreadsheets

### File: `Ticket_Analysis.xlsx`

#### Sheets
| Sheet | Contents |
|-------|----------|
| `ticket` | 10 sample tickets with created_at, closed_at, outlet_id, cms_id |
| `feedbacks` | 10 feedback rows; columns D–F are formula-driven |
| `Outlet_Summary` | Pivot-style COUNTIFS summary per outlet |

#### Formula Explanations

**Q1 – Populate `ticket_created_at`**
```excel
=IFERROR(VLOOKUP(A2, ticket!$E:$B, 2, FALSE), "NOT FOUND")
```
- Looks up `cms_id` (column A of feedbacks) in column E of the ticket sheet.
- Returns the value 2 columns to the left = `created_at` (column B of ticket).

**Q2a – Same Day?**
```excel
=IF(D2<>"NOT FOUND", IF(LEFT(D2,10)=LEFT(VLOOKUP(A2,ticket!$E:$C,3,FALSE),10),"YES","NO"), "N/A")
```
- Compares the `YYYY-MM-DD` portion (first 10 characters) of `created_at` and `closed_at`.

**Q2b – Same Hour?**
```excel
=IF(E2="YES", IF(MID(D2,12,2)=MID(VLOOKUP(A2,ticket!$E:$C,3,FALSE),12,2),"YES","NO"), "NO")
```
- Only checks hour (`HH` = characters 12–13) when the same-day check is already YES.

**Outlet Summary (COUNTIFS)**
```excel
=COUNTIFS(feedbacks!$G:$G, outlet_id, feedbacks!$E:$E, "YES")
```

---

## Phase 3 – Python

### How to Run
```bash
python Python/01_Time_Converter.py
python Python/02_Remove_Duplicates.py
```

### Logic Summary

**Time Converter**
```python
hours          = total_minutes // 60   # integer division
remaining_mins = total_minutes  % 60   # modulus
```

**Remove Duplicates**
```python
result = ""
for char in input_string:
    if char not in result:
        result += char
```

---

## Assumptions
1. All timestamps are stored as text strings in format `YYYY-MM-DD HH:MM:SS`.
2. SQL queries target year 2021 (parameterizable by changing the YEAR() filter).
3. Sample data is illustrative; real data may require adjusting INSERT statements.
4. Window functions (`RANK`, `ROW_NUMBER`, `DENSE_RANK`) require MySQL 8+.
