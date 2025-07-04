## Date de intrare (Inputs)

1. Baza de date pentru pontaj (timesheet):
  Se utilizează baza de date relațională creată anterior pentru gestionarea pontajului. Este esențial ca aceasta să conțină înregistrări detaliate la nivel de zi (ex. "pe data Y s-au lucrat Z ore"). Dacă datele sunt agregate doar săptămânal (ex. "în săptămâna X s-au lucrat Z ore"), schema trebuie ajustată pentru a permite detalii zilnice.

2. Tabel pentru absențe:
    O structură dedicată care reflectă informațiile despre concedii și alte tipuri de absențe, similară cu ceea ce există în Oracle Fusion (Endava).

3. Cel puțin două fișiere CSV cu attendance:
    Fișierele de prezență preluate de pe OneDrive (conform indicațiilor din e-mail), reprezentând participarea la sesiunile de ETL.

4. Fișier Excel cu absențe legate de examene:
    Acest fișier conține informații despre absențele cauzate de activități academice (ex. examene, colocvii), unde fiecare rând corespunde unui angajat, iar fiecare coloană unei date. Valorile din celule indică numărul de ore absentate în ziua respectivă.

## Rezultate așteptate (Outputs)

1. Raport punctual pentru un angajat la o dată specifică ("Employee at Date"):
    Se solicită o procedură (sau altă formă de interogare) care, dat un angajat și o anumită dată calendaristică, oferă o defalcare clară a activităților din acea zi. Exemplu: "4 ore la birou, 2 ore absență academică, 1.5 ore în sesiune ETL, 1.5 ore în sesiune Git".

2. Raport lunar pentru activitatea angajaților:
    Se dorește un raport la nivel de lună (ex. view sau materialized view) care să ofere o sinteză a activității fiecărui angajat. Formatul poate include o listă descriptivă per angajat, de tipul: "a lucrat X ore, a participat la sesiunile de training A și B, a avut concediu în perioada L–M" etc.
