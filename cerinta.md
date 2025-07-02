### Inputs

1. DB-ul nostru de timesheet, pe care l-am făcut pentru RDBMS; dacă nu are entry-uri la nivel de zi (e.g. dacă ai tabele care stochează doar "în săptămâna X a lucrat Z ore") atunci ar trebui s-o modifici mai întâi ca să aibă (e.g. să stocheze "în ziua Y a lucrat Z ore").

2. un tabel / DB de leave/absences, similar cu cel pentru timesheets (look at Endava's own in Oracle Fusion as an example)

3. cel puțin două CSV-uri de attendance de pe folderul de OneDrive pe care ni l-a pus în mail (e attendance-ul de la sesiunile de ETL)

4. un ??? (eu lucrez cu un Excel file?) cu informații despre exam-related absences, cam cum e pe pagina ceea internă pe care spun oamenii când o să fie absenți pentru facultate. La ăsta, era cerință să fie oamenii pe rânduri și data pe coloană, and then each cell conține câte ore ai fost plecat ziua aia

### Outputs

1. O ceva formă de query (eu cred că fac o procedură?) pentru "Employee at Date": îi specifici un angajat și o dată, și el îți spune un breakdown de ce a făcut angajatul în ziua aia, e.g. 4 ore la birou, 2 ore exam leave, 1.5 ore sesiunea de ETL, 1.5 ore sesiunea de Git. Din câte știu nu există un format exact pentru output.

2. O ceva formă de raport lunar (I might make a view / materialized view?) care să indice cumva ce a făcut fiecare angajat în luna aia. For instance o variantă ar fi un bulleted list la fiecare angajat în care să zică "a lucrat X ore, a participat la training session-ul de A și de B, a avut concediu între L și M, etc.". Nici aici nu e un format super-clar definit, din câte știu.
