# 📌 Flutter CRUD App – Clean Architecture + Django REST API

This repository contains a **Flutter CRUD Application** using **Clean Architecture**, connected to a **Django REST Framework (DRF)** backend.

The project includes two Flutter implementations:

---

## 🚀 Project Versions

| Project Name | Networking Package | Description |
|--------------|--------------------|-------------|
| **project_http** | `http` | Basic CRUD + simple image upload |
| **project_dio** | `dio` | Advanced CRUD + multipart upload + interceptors |

Both versions work with the same Django backend API.

---

# ⚙️ Django Backend Setup (Full Flow)

Follow this step-by-step guide to set up the Django server for this project.

---

## 1️⃣ Create & Activate Virtual Environment

```bash
python3 -m venv env
source env/bin/activate
pip install django
pip install -r requirements.txt
