# PROIECT ETL

### Constributors

1. **Balan-Rares-Ciprian**

2. **Cipleu Iulia Olivia**

3. **Cojocaru Adelin**

4. **Eminovici-Robert-Ernö**

5. **Lazar Alexandru**

6. **Mocan Diana Cristina**

# Explicatii

## Project Structure

```
.
├── cerinta.md
├── csvs ----------------> Data sources
│   ├── absences.csv
│   ├── Activity.csv
│   ├── DataAttendace.csv
│   └── Summary.csv
├── initials ------------> From outlook
│   └── DataAttendace.xls
├── main.sql ------------> Main script containing sql / plsql 
├── README.md
├── scripts -------------> Python scripts to generate needed data for tables
│   ├── generate_absences.py
│   ├── generate_attendance.py
│   ├── generate_names.py
│   └── generate_pontaje.py
└── sqls ----------------> Python generated scripts to insert data
    ├── din_insert_absences.sql
    ├── din_insert_angajati.sql
    ├── din_insert_attendance.sql
    └── din_insert_pontaje.sql
```

## Structură tabele

| Tabel                | Scop                                                                 |
|----------------------|----------------------------------------------------------------------|
| `Departamente`       | Listează departamentele din organizație                             |
| `Angajati`           | Informații despre angajați (nume, email, departament)               |
| `Proiecte`           | Proiectele existente, cu nume și descriere                          |
| `Zile_Libere`        | Zilele oficiale libere din calendar                                 |
| `Pontaje`            | Orele lucrate de angajați, **per zi**, proiect și zi liberă    |
| `Absente`            | Absențele angajaților (examene, colocvii etc.) și perioadele aferente |
| `Participanti_Reuniune` | Participarea la întâlniri/traininguri (cu durată și rol)

## Cerinta 1 (explicată in cerinta.md, )

- **Tip:** Procedură PL/SQL
- **Input:** `ID_Angajat`, `Data` (`DATE`)
- **Scop:** Afișează o analiză detaliată a activității unui angajat într-o zi anume.
- **Rezultat:** Se afișează în consola Oracle (`DBMS_OUTPUT`) următoarele informații:
  - Nume angajat
  - Ore lucrate în ziua respectivă (din `Pontaje`)
  - Dacă a fost o zi liberă (din `Zile_Libere`)
  - Tipul de absență, dacă există (din `Absente`)
  - Proiectul la care a lucrat
  - Informații despre întâlniri/traininguri (din `Participanti_Reuniune`)

## Cerința 2: Raport lunar agregat (`raport_lunar_angajati`)

- **Tip:** `VIEW` SQL
- **Scop:** Oferă o imagine de ansamblu asupra activității lunare a fiecărui angajat.
- **Granularitate:** un rând per angajat per lună (`YYYY-MM`)
- **Date extrase:**
  - `Total_Ore_Lucrate` – totalul orelor lucrate în luna respectivă (din tabela `Pontaje`)
  - `Proiecte` – listă cu numele proiectelor implicate în luna respectivă (distincte)
  - `Absente` – lista tipurilor de absențe și intervalele acestora, ex: `Examen (10.07–12.07)`
  - `Traininguri` – lista sesiunilor de training/meeting la care angajatul a avut rolul de `Presenter`, împreună cu data sesiunii

> Exemplu rezultat pentru luna `2025-07`:

| ID_Angajat | Nume            | Luna     | Total_Ore_Lucrate | Proiecte | Absente             | Traininguri         |
|------------|------------------|----------|--------------------|-----------|----------------------|----------------------|
| 1          | Lazar Alexandru  | 2025-07  | 152                | Academy   | Examen (22.07–22.07) | GitHub Basics [01.07] |
