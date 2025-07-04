--bun bun
SELECT owner, table_name
  FROM dba_tables;
  

create table Departamente (
    ID_Departament NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Nume_Departament VARCHAR2(50) NOT NULL    
);
select * from Departamente;
insert into Departamente (Nume_Departament) values ('clf');


CREATE TABLE Angajati (
    ID_Angajat NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Nume VARCHAR2(50) NOT NULL,
    Email VARCHAR2(100) NOT NULL UNIQUE,
    ID_Departament_FK NUMBER NOT NULL,
    CONSTRAINT FK_Angajati_Departament FOREIGN KEY (ID_Departament_FK) REFERENCES Departamente(ID_Departament),
    CONSTRAINT CHK_Email_Format CHECK (INSTR(Email, '@') > 0)
);
drop table Angajati;

select * from Angajati;

create table Proiecte (
    ID_Proiect NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Nume_Proiect VARCHAR2(100) NOT NULL UNIQUE,
    Descriere VARCHAR2(255) NOT NULL
);
-- insert into Proiecte(Nume_Proiect, Descriere) values('Academy', 'Endava Academy');
select * from Proiecte;

drop table Proiecte;

create table Zile_Libere (
    ID_Zile_Libere NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Data DATE NOT NULL
);

select * from Zile_Libere;
-- am adaugat aici 2 zile libeere , 1 iunie / 9 iunie
insert into Zile_Libere (Data)
values (TO_DATE('2025-06-01', 'YYYY-MM-DD'));

insert into Zile_Libere (Data)
values (TO_DATE('2025-06-09', 'YYYY-MM-DD'));

drop table Zile_Libere;

create table Pontaje (
    ID_Pontaj NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ID_Angajat_FK NUMBER NOT NULL,
    Data DATE NOT NULL,
    Ore_Lucrate NUMBER(2) NOT NULL CHECK (Ore_Lucrate >= 0 AND Ore_Lucrate <= 24),
    ID_Proiect_FK NUMBER,
    ID_Zi_Libera_FK NUMBER, -- poate fi null
    CONSTRAINT FK_Pontaje_Angajat FOREIGN KEY (ID_Angajat_FK) REFERENCES Angajati(ID_Angajat),
    CONSTRAINT FK_Pontaje_Proiect FOREIGN KEY (ID_Proiect_FK) REFERENCES Proiecte(ID_Proiect),
    CONSTRAINT FK_Pontaje_Zi_Libera FOREIGN KEY (ID_Zi_Libera_FK) REFERENCES Zile_Libere(ID_Zile_Libere),
    CONSTRAINT UQ_Pontaj_Per_Zi UNIQUE (ID_Angajat_FK, Data)
);

drop table Pontaje;

create table Absente(
    ID_Absenta NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ID_Angajat_FK NUMBER NOT NULL,
    Data_Start DATE NOT NULL,
    Data_Stop DATE NOT NULL,
    Summary VARCHAR2(50) NOT NULL, -- asta e tipul de absenta examen / colocviu .. 
    CONSTRAINT FK_Absente_Angajat FOREIGN KEY (ID_Angajat_FK) REFERENCES Angajati(ID_Angajat),
    CONSTRAINT CHK_Data_Absenta CHECK (Data_Stop >= Data_Start)
);

select * from Absente;

drop table Absente;
     
select * from Absente;

create table Participanti_Reuniune (
    ID_Participant_Reuniune NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    
    Name              VARCHAR2(200),
    First_Join        TIMESTAMP,
    Last_Leave        TIMESTAMP,
    InMeeting_Duration VARCHAR2(50),
    Duration_Stay     INTERVAL DAY TO SECOND,
    Email             VARCHAR2(200),
    Participant_ID    VARCHAR2(100),
    Role              VARCHAR2(100),
    
    ID_Angajat_FK     NUMBER, -- legatura cu angajat, daca emailul corespunde
    ID_Proiect_FK     NUMBER, -- daca participarea a fost in cadrul unui proiect
    
    CONSTRAINT FK_Participant_Angajat FOREIGN KEY (ID_Angajat_FK) REFERENCES Angajati(ID_Angajat),
    CONSTRAINT FK_Participant_Proiect FOREIGN KEY (ID_Proiect_FK) REFERENCES Proiecte(ID_Proiect)
);

drop table Participanti_Reuniune;



-- Deci pentru un angajat (id_angajat) si o zi (date) vrem sa vedem
-- 1. cate ore a lucrat ( din pontaje )
-- 2. daca a fost intr-o zi libera
-- 3. daca a avut o absenta
-- 4. daca a participat la vreo intalnire
-- 5. detalii despre proiect ( optional )
create or replace procedure show_employee_at_date(
    p_id_angajat in number,
    p_data in date
)
as
begin
    dbms_output.put_line('---------');
    DBMS_OUTPUT.PUT_LINE('Raport pentru angajatul ID: ' || p_id_angajat || ' la data: ' || TO_CHAR(p_data, 'YYYY-MM-DD'));
    for rec in (
        select 
            a.Nume,
            p.Ore_Lucrate,
            zl.Data AS Zi_Libera,
            ab.Summary AS Tip_Absenta,
            pr.Nume_Proiect,
            r.First_Join,
            r.Last_Leave,
            r.InMeeting_Duration
        from Angajati a
        left join Pontaje p on p.ID_Angajat_FK = a.ID_Angajat and p.Data = p_data
        left join Zile_Libere zl on p.ID_Zi_Libera_FK = zl.ID_Zile_Libere
        left join Absente ab on ab.ID_Angajat_FK = a.ID_Angajat and p_data between ab.Data_Start and ab.Data_Stop
        left join Proiecte pr on p.ID_Proiect_FK = pr.ID_Proiect
        left join Participanti_Reuniune r on r.ID_Angajat_FK = a.ID_Angajat and trunc(r.First_Join) = p_data
        where a.ID_Angajat = p_id_angajat
    ) loop
        DBMS_OUTPUT.PUT_LINE('Nume: ' || rec.Nume);
        DBMS_OUTPUT.PUT_LINE('Ore lucrate: ' || NVL(TO_CHAR(rec.Ore_Lucrate), '0'));
        DBMS_OUTPUT.PUT_LINE('Zi libera: ' || NVL(TO_CHAR(rec.Zi_Libera, 'YYYY-MM-DD'), 'NU'));
        DBMS_OUTPUT.PUT_LINE('Absenta: ' || NVL(rec.Tip_Absenta, 'NU'));-- daca e null atunci nu
        DBMS_OUTPUT.PUT_LINE('Proiect: ' || NVL(rec.Nume_Proiect, 'N/A'));
        DBMS_OUTPUT.PUT_LINE('Meeting: ' || NVL(rec.InMeeting_Duration, 'NU'));
        DBMS_OUTPUT.PUT_LINE('----------------------------');
    end loop;
end;
/
SET SERVEROUTPUT ON;
begin
  show_employee_at_date(1, TO_DATE('2025-07-01', 'YYYY-MM-DD'));
end;

-- Un raport lunar per angajat
-- un view / materialized view este ideal
-- pentru fiecare angajat , intr-o luna data , vrem sa :
-- 1. total ore lucrate
-- 2. lista proiectelor la care a lucrat
-- 3. perioada si tipul absentelor
-- 4. sesiunile de training / meeting-uri la care a participat
-- 5. zile libere (optional)

-- un view denormalizat per angajat / luna
-- to be better : materialized view
create or replace view raport_lunar_angajati as
select
    a.ID_Angajat,
    a.Nume,
    TO_CHAR(p.Data, 'YYYY-MM') AS Luna,
    sum(p.Ore_Lucrate) AS Total_Ore_Lucrate, -- total ore lucrate in luna
    listagg(distinct pr.Nume_Proiect, ', ') within group (order by pr.Nume_Proiect) as Proiecte, -- lista proiecte unice
    listagg(distinct ab.Summary || ' (' || TO_CHAR(ab.Data_Start, 'DD.MM') || '-' || TO_CHAR(ab.Data_Stop, 'DD.MM') || ')', '; ')
        within group (order by ab.Data_Start) as Absente, -- liste absente : tip si perioada
    
    -- lista traininguri / meeting-uri si practic daca are rol de cel care e participant -> Presenter   
    -- rolul de "Organizer" e doar la o singura persoana, prima
    listagg(distinct case 
            WHEN LOWER(r.Role) = 'presenter' THEN r.Name || ' [' || TO_CHAR(r.First_Join, 'DD.MM') || ']'
                ELSE NULL 
            END, '; ')
        WITHIN GROUP (ORDER BY r.First_Join) AS Traininguri
from Angajati a
left join Pontaje p on p.ID_Angajat_FK = a.ID_Angajat
left join Proiecte pr on p.ID_Proiect_FK = pr.ID_Proiect
left join Absente ab on ab.ID_Angajat_FK = a.ID_Angajat
    and TO_CHAR(ab.Data_Start, 'YYYY-MM') = TO_CHAR(p.Data, 'YYYY-MM')
left join Participanti_Reuniune r on r.ID_Angajat_FK = a.ID_Angajat
    and TO_CHAR(r.First_Join, 'YYYY-MM') = TO_CHAR(p.Data, 'YYYY-MM')
group by a.ID_Angajat, a.Nume, TO_CHAR(p.Data, 'YYYY-MM');
     
select * from raport_lunar_angajati
where Luna = '2025-07'; 



