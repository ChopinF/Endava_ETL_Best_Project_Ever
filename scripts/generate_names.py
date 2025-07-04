import pandas as pd

df_attendace: pd.DataFrame = pd.read_csv("./csvs/DataAttendace.csv")
# print(df_attendace.head())
# print(df_attendace.info())
# print(df_attendace.columns)
labels = [
    "Name",
    "First Join",
    "Last Leave",
    "In-Meeting Duration",
    "Email",
    "Participant ID (UPN)",
    "Role",
]

unique_names = df_attendace[["Name", "Email"]].drop_duplicates()
for index, row in unique_names.iterrows():
    name = row["Name"]
    email = row["Email"]

    id_departament = 1  # toti suntem la un singur departament
    dynamic_insert = f"""INSERT INTO Angajati 
    (Nume, Email, ID_Departament_FK )
    VALUES (
        '{name}',
        '{email}',
        '{id_departament}',
    );"""

    print(dynamic_insert)
