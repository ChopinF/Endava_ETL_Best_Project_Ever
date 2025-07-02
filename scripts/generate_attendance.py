import pandas as pd
from datetime import datetime
# HOW TO USE : python3 generate_attendance.py> DataAttendace.csv

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


# asta e pentru prima parte
for index, row in df_attendace.iterrows():
    first_join = row["First Join"]
    last_leave = row["Last Leave"]

    fmt = "%m/%d/%y, %I:%M:%S %p"

    try:
        join_dt = datetime.strptime(first_join, fmt)
        leave_dt = datetime.strptime(last_leave, fmt)
        duration = leave_dt - join_dt  # timedelta
        duration_str = str(duration).split(".")[0]
    except Exception as e:
        print(f"Eroare la rândul {index}: {e}")
        continue

    dynamic_insert = f"""INSERT INTO Participanti_Reuniune
    (Name, First_Join, Last_Leave, InMeeting_Duration, Duration_Stay, Email, Participant_ID, Role)
    VALUES (
        '{row["Name"]}',
        TO_TIMESTAMP('{join_dt.strftime("%Y-%m-%d %H:%M:%S")}', 'YYYY-MM-DD HH24:MI:SS'),
        TO_TIMESTAMP('{leave_dt.strftime("%Y-%m-%d %H:%M:%S")}', 'YYYY-MM-DD HH24:MI:SS'),
        '{row["In-Meeting Duration"]}',
        INTERVAL '{duration_str}' DAY TO SECOND,
        '{row["Email"]}',
        '{row["Participant ID (UPN)"]}',
        '{row["Role"]}'
    );"""

    print(dynamic_insert)
