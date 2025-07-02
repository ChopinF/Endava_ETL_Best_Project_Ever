import pandas as pd
from datetime import datetime, timedelta

df_attendace: pd.DataFrame = pd.read_csv("./csvs/DataAttendace.csv")
unique_names = df_attendace[["Name", "Email"]].drop_duplicates()

start_date = datetime.strptime("2025-05-19", "%Y-%m-%d")
end_date = datetime.today()

zile_libere = {"2025-06-01", "2025-06-09"}

# parametrii constanti mereu
id_proiect = 1
ore_lucrate = 8

for _, row in unique_names.iterrows():
    email = row["Email"]
    name = row["Name"]
    current_date = start_date

    while current_date <= end_date:
        # dam skip la sambata / duminica
        if current_date.weekday() >= 5:
            current_date += timedelta(days=1)
            continue

        zi_str = current_date.strftime("%Y-%m-%d")
        oracle_date = f"TO_DATE('{zi_str}', 'YYYY-MM-DD')"

        is_zi_libera = zi_str in zile_libere
        id_zi_libera_fk = (
            f"(SELECT ID_Zile_Libere FROM Zile_Libere WHERE Data = {oracle_date})"
            if is_zi_libera
            else "NULL"
        )

        insert_stmt = f"""INSERT INTO Pontaje (
    ID_Angajat_FK, Data, Ore_Lucrate, ID_Proiect_FK, ID_Zi_Libera_FK
) VALUES (
    (SELECT ID_Angajat FROM Angajati WHERE LOWER(Nume) = LOWER('{name}')),
    {oracle_date},
    {ore_lucrate},
    {id_proiect},
    {id_zi_libera_fk}
);"""

        print(insert_stmt)
        current_date += timedelta(days=1)
