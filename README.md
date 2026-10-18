# Telecom ETL Pipeline using SSIS

A file-driven ETL pipeline for processing, validating, transforming, and loading telecom transaction data into SQL Server.

**Technologies:** SQL Server Integration Services (SSIS) · Microsoft SQL Server · T-SQL · CSV

---

## Overview

This project implements an ETL workflow for telecom transaction data using SSIS. It processes CSV files, transforms transaction fields, looks up subscriber information, and loads the results into SQL Server.

The pipeline supports multiple input files through a **Foreach Loop Container**, routes configured errors to dedicated tables, and archives files after successful processing.

---

## Key Features

* **Multi-file Processing:** Iterates through CSV files in a configured source directory.
* **Data Transformation:** Maps transaction fields and derives TAC and SNR values from IMEI.
* **Subscriber Lookup:** Matches IMSI values against reference data to retrieve subscriber IDs.
* **Data Loading:** Loads processed transactions into SQL Server.
* **Error Handling:** Routes configured source and destination errors to separate tables.
* **File Archiving:** Archives input files after successful processing.

---

## Technology Stack

| Technology / Component | Purpose |
| :--- | :--- |
| **SQL Server Integration Services (SSIS)** | ETL workflow orchestration |
| **Microsoft SQL Server** | Data storage and reference lookups |
| **CSV Flat File Source** | Reads incoming transaction files |
| **Foreach Loop Container** | Processes multiple input files |
| **Lookup Transformation** | Resolves subscriber IDs using IMSI |
| **Derived Column Transformation** | Creates and transforms output fields |
| **OLE DB Destination** | Loads data and error outputs into SQL Server |

---

## ETL Workflow

### 1. Control Flow
The Control Flow uses a Foreach Loop Container to iterate over CSV files. Each file is processed by a Data Flow task, followed by an archive step when processing succeeds.

### 2. Data Flow
The Data Flow reads transaction records, applies field transformations, performs subscriber lookups, derives TAC and SNR from IMEI, and loads the resulting records into SQL Server. Configured error outputs direct applicable source and destination errors to separate database tables.

<img width="703" height="547" alt="Screenshot 2026-10-18 153714" src="https://github.com/user-attachments/assets/a93da1ea-c119-4cad-acb3-3cc3e8704475" />

<img width="945" height="698" alt="Screenshot 2026-10-18 153744" src="https://github.com/user-attachments/assets/31a86fea-f1e9-4a89-9f9d-58f09b9fbbd7" />

---

## Data Transformation Rules

| Source Field | Transformation / Validation | Target Field |
| :--- | :--- | :--- |
| `ID` | Pass through | `Transaction_id` |
| `IMSI` | Pass through; required value | `IMSI` |
| `IMSI` | Subscriber lookup; use `-99999` if unavailable | `subscriber_id` |
| `IMEI` | Extract first 8 characters; use `-99999` if invalid | `TAC` |
| `IMEI` | Extract last 6 characters; use `-99999` if invalid | `SNR` |
| `IMEI` | Pass through | `IMEI` |
| `CELL` | Pass through; required value | `CELL` |
| `LAC` | Pass through; required value | `LAC` |
| `EVENT_TYPE` | Pass through | `EVENT_TYPE` |
| `EVENT_TS` | Validate timestamp; reject null or invalid values | `EVENT_TS` |

> **Note:** The task specification lists IMEI as 14 characters, while the sample contains 15 digits and the transformation rules refer to a 15-character length check. The intended validation rule should be confirmed against the actual package configuration.

---

## Database Design

The project uses the `SSIS_Telecom_DB` database.

| Table | Purpose |
| :--- | :--- |
| `dim_imsi_reference` | Stores IMSI reference data for subscriber lookups |
| `fact_transaction` | Stores processed telecom transactions |
| `err_source_output` | Stores records routed through the source error output |
| `error_destination_output` | Stores records routed through the destination error output |

---

## Error Handling

The package uses separate error paths for source-side and destination-side errors:
* **Source errors:** `err_source_output`
* **Destination errors:** `error_destination_output`

The captured errors depend on the SSIS components and error-output settings. Business-rule rejections, such as missing required fields, depend on the validation logic implemented in the package.

---


