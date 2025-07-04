import pandas as pd
from datetime import datetime

df_absence: pd.DataFrame = pd.read_csv("./csvs/absences.csv")

# print(df_absence.head())
# print(df_absence.info())
# print(df_absence.columns)

labels = [
    "SUMMARY",
    "DTSTART",
    "DTEND",
    "DUE",
    "NOTES",
    "ATTENDEE",
    "LOCATION",
    "PRIORITY",
    "URL",
    "CALENDAR",
    "UID",
    "ORGANIZER",
    "CATEGORIES",
    "DURATION",
    "REPLACES RECURRENT EVENT FROM",
    "CREATED",
]

use_features = [
    "SUMMARY",  # in tabela e Summary
    "DTSTART",  # in tabela e Data_Start
    "DTEND",  # in tabela e Data_Stop
    "ATTENDEE",  # o sa trebuiasca sa generam mai intai sa se uite in tabela de Angajati sa faca rost de ID dupa nume
]


def format_date(date_str):
    formats = [
        "%Y-%m-%d",  # 2025-07-01
        "%Y%m%d",  # 20250701
        "%m/%d/%Y %I:%M %p",  # US: 02/06/2025 11:00 AM
        "%d/%m/%Y %I:%M %p",  # EU: 16/08/2025 12:00 AM
        "%d/%m/%Y",  # fara ora: 13/09/2025
        "%m/%d/%Y",  # fara ora: 09/13/2025
    ]
    for fmt in formats:
        try:
            dt = datetime.strptime(date_str.strip(), fmt)
            return dt.strftime("%Y-%m-%d")
        except Exception:
            continue
    print(f"Eroare la conversia datei: {date_str}")
    return None


for index, row in df_absence.iterrows():
    summary = row["SUMMARY"]
    attendee_name = row["ATTENDEE"]
    start_raw = row["DTSTART"]
    end_raw = row["DTEND"]

    start_date = format_date(start_raw)
    end_date = format_date(end_raw)

    if not start_date or not end_date:
        print(f"Date invalide la randul {index}")
        continue

    dynamic_insert = f"""INSERT INTO Absente 
    (ID_Angajat_FK, Data_Start, Data_Stop, Summary)
    VALUES (
        (SELECT ID_Angajat FROM Angajati WHERE LOWER(Nume) = LOWER('{attendee_name}')),
        TO_DATE('{start_date}', 'YYYY-MM-DD'),
        TO_DATE('{end_date}', 'YYYY-MM-DD'),
        '{summary}'
    );"""
    print(dynamic_insert)
