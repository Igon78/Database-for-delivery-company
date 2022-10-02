--1
SELECT pr.imie, TO_CHAR(zam.data_nadania+1, 'DAY') AS "DZIEN DOSTAWY", po.numer_rejestracyjny
FROM PACZKI pa, zamowienia zam, kurierzy ku, pracownicy pr, pojazdy po
WHERE pa.zam_id=zam.zam_id AND zam.ku_id=ku.ku_id AND pr.pr_id=ku.pr_id AND
ku.po_id=po.po_id AND pa.pa_id=60;

--2
SELECT SUBSTR(nazwa,1,3) || '_' || TO_CHAR(mg_id) AS "Miasto", 
ROUND("POWIERZCHNIA(M^2)"*"WYSOKOSC(M)",0) AS "Objêtoœæ"
FROM magazyny
WHERE "POWIERZCHNIA(M^2)"*"WYSOKOSC(M)">=160000;

--3
SELECT rodzaj_platnosci, ROUND(AVG(wartosc_towaru),2), MAX(wartosc_towaru), SUM(wartosc_towaru)
FROM ZAMOWIENIA
GROUP BY rodzaj_platnosci
ORDER BY AVG(wartosc_towaru) DESC;

--4
SELECT fi.nazwa, od."E-MAIL"
FROM odbiorcy od, firmy fi
WHERE od.fi_id=fi.fi_id AND od.fi_id NOT IN (SELECT NVL(fi_id,0) FROM nadawcy)
ORDER BY  fi.nazwa;

--5
SELECT czy_szklane, na.imie AS "na imie", na.nazwisko as "na nazwisko", na.nr_telefonu,
ku.imie as "ku imie", ku.nazwisko as "ku nazwisko", mg.imie as "mg imie", mg.nazwisko as "mg nazwisko"
FROM (SELECT zam.zam_id, mg_id, ku_id, na_id, czy_szklane
        FROM zamowienia zam,paczki pa
        WHERE pa.zam_id=zam.zam_id) zam
JOIN (SELECT na.na_id, op.imie, op.nazwisko, na.nr_telefonu 
        FROM nadawcy na, osoby_prywatne op
        WHERE na.op_id = op.op_id) na ON (na.na_id=zam.na_id)
JOIN (SELECT ku_id, imie, nazwisko 
        FROM kurierzy ku, pracownicy pr
        WHERE ku.pr_id = pr.pr_id) ku ON (ku.ku_id=zam.ku_id)
JOIN (SELECT mg.mg_id, imie, nazwisko
        FROM magazyny mg, magazynierzy ma, pracownicy pr
        WHERE ma.mg_id=mg.mg_id AND pr.pr_id=ma.pr_id 
        AND ma_id1 IS NULL) mg ON (mg.mg_id=zam.mg_id)
WHERE zam.zam_id=80;

--6
SELECT mg_id, nazwa
FROM magazyny mg
WHERE NOT EXISTS (SELECT 'X' 
                    FROM magazynierzy 
                    WHERE mg_id =mg.mg_id AND ma_id1 IS NULL);
                    
--7
SELECT mg.nazwa, COUNT(zam.zam_id) as "ILOSC", ROUND(AVG(wartosc_towaru),2) AS "SREDNIA MAGAZYNU",
(SELECT ROUND(AVG(wartosc_towaru),2) FROM zamowienia) as "SREDNIA OGÓ£EM"
FROM magazyny mg, zamowienia zam
WHERE zam.mg_id=mg.mg_id
GROUP BY mg.nazwa
ORDER BY "ILOSC" DESC,"SREDNIA MAGAZYNU" DESC;

--8
SELECT pr_id,imie,nazwisko, MAX(czas_zakonczenia) AS "DZIEN", MAX(TO_CHAR(czas_zakonczenia, 'HH24')) AS "GODZINA"
FROM zmiany zm, "PRACOWNICY-ZMIANY" pz,pracownicy pr
WHERE zm.zm_id =zmiany_zm_id AND pr.pr_id=pracownicy_pr_id
GROUP BY pr_id,imie,nazwisko;

--PERSPEKTYWY
--1
CREATE VIEW ZAD_1
AS (SELECT pr.imie, TO_CHAR(zam.data_nadania+1, 'DAY') AS "DZIEN DOSTAWY", po.numer_rejestracyjny
FROM PACZKI pa, zamowienia zam, kurierzy ku, pracownicy pr, pojazdy po
WHERE pa.zam_id=zam.zam_id AND zam.ku_id=ku.ku_id AND pr.pr_id=ku.pr_id AND
ku.po_id=po.po_id AND pa.pa_id=60);

--2
CREATE VIEW ZAD_2
AS (SELECT SUBSTR(nazwa,1,3) || '_' || TO_CHAR(mg_id) AS "Miasto", 
ROUND("POWIERZCHNIA(M^2)"*"WYSOKOSC(M)",0) AS "Objêtoœæ"
FROM magazyny
WHERE "POWIERZCHNIA(M^2)"*"WYSOKOSC(M)">=160000);

--3
CREATE VIEW ZAD_3(platnosc,srednia,maksimum,suma)
AS SELECT rodzaj_platnosci, ROUND(AVG(wartosc_towaru),2), MAX(wartosc_towaru), SUM(wartosc_towaru)
FROM ZAMOWIENIA
GROUP BY rodzaj_platnosci
ORDER BY AVG(wartosc_towaru) DESC;

--4
CREATE VIEW ZAD_4
AS SELECT fi.nazwa, od."E-MAIL"
FROM odbiorcy od, firmy fi
WHERE od.fi_id=fi.fi_id AND od.fi_id NOT IN (SELECT NVL(fi_id,0) FROM nadawcy)
ORDER BY  fi.nazwa;

--5
CREATE VIEW ZAD_5
AS SELECT czy_szklane, na.imie AS "na imie", na.nazwisko as "na nazwisko", na.nr_telefonu,
ku.imie as "ku imie", ku.nazwisko as "ku nazwisko", mg.imie as "mg imie", mg.nazwisko as "mg nazwisko"
FROM (SELECT zam.zam_id, mg_id, ku_id, na_id, czy_szklane
        FROM zamowienia zam,paczki pa
        WHERE pa.zam_id=zam.zam_id) zam
JOIN (SELECT na.na_id, op.imie, op.nazwisko, na.nr_telefonu 
        FROM nadawcy na, osoby_prywatne op
        WHERE na.op_id = op.op_id) na ON (na.na_id=zam.na_id)
JOIN (SELECT ku_id, imie, nazwisko 
        FROM kurierzy ku, pracownicy pr
        WHERE ku.pr_id = pr.pr_id) ku ON (ku.ku_id=zam.ku_id)
JOIN (SELECT mg.mg_id, imie, nazwisko
        FROM magazyny mg, magazynierzy ma, pracownicy pr
        WHERE ma.mg_id=mg.mg_id AND pr.pr_id=ma.pr_id 
        AND ma_id1 IS NULL) mg ON (mg.mg_id=zam.mg_id)
WHERE zam.zam_id=80;

--6
CREATE VIEW ZAD_6
AS SELECT mg_id, nazwa
FROM magazyny mg
WHERE NOT EXISTS (SELECT 'X' 
                    FROM magazynierzy 
                    WHERE mg_id =mg.mg_id AND ma_id1 IS NULL);
                    
--7
CREATE VIEW ZAD_7
AS SELECT mg.nazwa, COUNT(zam.zam_id) as "ILOSC", ROUND(AVG(wartosc_towaru),2) AS "SREDNIA MAGAZYNU",
(SELECT ROUND(AVG(wartosc_towaru),2) FROM zamowienia) as "SREDNIA OGÓ£EM"
FROM magazyny mg, zamowienia zam
WHERE zam.mg_id=mg.mg_id
GROUP BY mg.nazwa
ORDER BY "ILOSC" DESC,"SREDNIA MAGAZYNU" DESC;

CREATE VIEW ZAD_8
AS SELECT pr_id,imie,nazwisko, MAX(czas_zakonczenia) AS "DZIEN", MAX(TO_CHAR(czas_zakonczenia, 'HH24')) AS "GODZINA"
FROM zmiany zm, "PRACOWNICY-ZMIANY" pz,pracownicy pr
WHERE zm.zm_id =zmiany_zm_id AND pr.pr_id=pracownicy_pr_id
GROUP BY pr_id,imie,nazwisko;