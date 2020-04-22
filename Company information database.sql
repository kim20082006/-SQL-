CONNECT system/oracle;
CREATE USER dbcom IDENTIFIED BY password DEFAULT TABLESPACE users;
GRANT ALL PRIVILEGES TO dbcom;
CONNECT dbcom/password;
BEGIN
EXECUTE IMMEDIATE 'DROP ROLE db_user';
EXECUTE IMMEDIATE 'DROP ROLE db_admin';
EXECUTE IMMEDIATE 'DROP USER jack';
EXECUTE IMMEDIATE 'DROP USER jane';
EXECUTE IMMEDIATE 'DROP USER max';
EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM project';
EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM source';
EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM budget';
EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM employee';
EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM customer';
EXECUTE IMMEDIATE 'DROP SEQUENCE employee_id_seq';
EXECUTE IMMEDIATE 'DROP INDEX employee_ix';
EXECUTE IMMEDIATE 'DROP PROCEDURE insert_budget';
EXECUTE IMMEDIATE 'DROP PROCEDURE update_source_data';
EXECUTE IMMEDIATE 'DROP PROCEDURE drop_table';
EXECUTE IMMEDIATE 'DROP FUNCTION gross_profit';
EXECUTE IMMEDIATE 'DROP FUNCTION retained_profit_total';
EXECUTE IMMEDIATE 'DROP TRIGGER delete_project_trigger';
EXECUTE IMMEDIATE 'DROP TABLE SOURCE';
EXECUTE IMMEDIATE 'DROP TABLE PROJECT';
EXECUTE IMMEDIATE 'DROP TABLE BUDGET';
EXECUTE IMMEDIATE 'DROP TABLE EMPLOYEE';
EXECUTE IMMEDIATE 'DROP TABLE CUSTOMER';
EXCEPTION 
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE(' ');
END;
/
pause;

CREATE TABLE BUDGET
(
budget_id NUMBER NOT NULL PRIMARY KEY,
data VARCHAR2(20),
cost NUMBER,
earn NUMBER,
flexiblecost NUMBER
);

CREATE TABLE EMPLOYEE
(
employee_id NUMBER NOT NULL PRIMARY KEY,
employee_first_name VARCHAR2(20),
employee_last_name VARCHAR2(20),
employee_phone_number NUMBER,
gender VARCHAR2(20)
);

CREATE INDEX employee_ix
ON employee (employee_last_name,gender);
CREATE SEQUENCE employee_seq
	START WITH 1 INCREMENT BY 1
	NOMAXVALUE NOCYCLE CACHE 1000;

CREATE TABLE CUSTOMER
(
customer_id NUMBER NOT NULL PRIMARY KEY,
customer_name VARCHAR2(20),
customer_business VARCHAR2(20),
customer_phone_number NUMBER,
region VARCHAR2(20)
);

CREATE TABLE PROJECT
(
project_id NUMBER NOT NULL PRIMARY KEY CHECK (project_id>=0),
project_name VARCHAR2(30) NOT NULL,
budget_id NUMBER NOT NULL,
employee_id NUMBER NOT NULL,
customer_id NUMBER NOT NULL,
CONSTRAINT budget_fk_id
	FOREIGN KEY (budget_id) REFERENCES budget (budget_id),
CONSTRAINT employee_fk_id
	FOREIGN KEY (employee_id) REFERENCES employee (employee_id),
CONSTRAINT customer_fk_id
	FOREIGN KEY (customer_id) REFERENCES customer (customer_id)
);


CREATE TABLE SOURCE
(
project_id NUMBER NOT NULL,
website_name VARCHAR2(20) NOT NULL PRIMARY KEY,
data VARCHAR2(20),
author VARCHAR2(20),
URL VARCHAR2(20),
CONSTRAINT project_fk_id
	FOREIGN KEY (project_id) REFERENCES project (project_id)
);
pause;

CREATE ROLE db_user;
CREATE ROLE db_admin;

GRANT CREATE SESSION TO db_user;
GRANT CREATE PUBLIC SYNONYM TO db_user;
GRANT SELECT ON project TO db_user;
GRANT SELECT ON source TO db_user;
GRANT SELECT ON budget TO db_user;
GRANT SELECT ON employee TO db_user;
GRANT SELECT ON customer TO db_user;

GRANT db_user TO db_admin WITH ADMIN OPTION;
GRANT SELECT,INSERT,UPDATE,DELETE ON project TO db_admin;
GRANT SELECT,INSERT,UPDATE,DELETE ON source TO db_admin;
GRANT SELECT,INSERT,UPDATE,DELETE ON budget TO db_admin;
GRANT SELECT,INSERT,UPDATE,DELETE ON employee TO db_admin;
GRANT SELECT,INSERT,UPDATE,DELETE ON customer TO db_admin;
pause;

CREATE USER jack IDENTIFIED BY password
DEFAULT TABLESPACE users;
CREATE USER jane IDENTIFIED BY password
DEFAULT TABLESPACE users;
CREATE USER max IDENTIFIED BY password
DEFAULT TABLESPACE users;

GRANT db_user TO jack,jane;
GRANT db_admin TO max;

CONNECT jack/password;
CREATE PUBLIC SYNONYM project FOR dbcom.project;
CREATE PUBLIC SYNONYM source FOR dbcom.source;
CREATE PUBLIC SYNONYM budget FOR dbcom.budget;
CREATE PUBLIC SYNONYM employee FOR dbcom.employee;
CREATE PUBLIC SYNONYM customer FOR dbcom.customer;

pause;

CONNECT dbcom/password;

CREATE OR REPLACE PROCEDURE insert_budget
(
budget_id NUMBER,
data VARCHAR2,
cost NUMBER,
earn NUMBER,
flexiblecost NUMBER
)
AS
BEGIN
	INSERT INTO budget
	VALUES(budget_id,data,cost,earn,flexiblecost);
COMMIT;
END;
/


CALL insert_budget(1001,'AmazonMonthly',40000,100000,4000);
CALL insert_budget(1002,'FacebookMonthly',35000,80000,5000);
CALL insert_budget(1003,'AlibabaMonthly',30000,70000,4020);
CALL insert_budget(1004,'RedbookMonthly',3000,7000,320);
CALL insert_budget(1005,'JingdongMonthly',10000,3000,1100);
CALL insert_budget(1006,'SiemensMonthly',5000,8500,540);
CALL insert_budget(1007,'PindodoMonthly',3000,7000,350);
CALL insert_budget(1008,'MobaiMonthly',1000,1500,100);

insert into employee (employee_id,employee_first_name,employee_last_name,employee_phone_number,gender)
values(1,'John','Smith',2172083499,'M');
insert into employee (employee_id,employee_first_name,employee_last_name,employee_phone_number,gender)
values(2,'Michael','Smith',2172087485,'F');
insert into employee (employee_id,employee_first_name,employee_last_name,employee_phone_number,gender)
values(3,'Maria','Garcia',2172088493,'F');
insert into employee (employee_id,employee_first_name,employee_last_name,employee_phone_number,gender)
values(4,'David','Rodriguez',2172083843,'M');
insert into employee (employee_id,employee_first_name,employee_last_name,employee_phone_number,gender)
values(5,'James','Johnson',2172084892,'M');
insert into employee (employee_id,employee_first_name,employee_last_name,employee_phone_number,gender)
values(6,'Juan','Carlos',2172088439,'M');
insert into employee (employee_id,employee_first_name,employee_last_name,employee_phone_number,gender)
values(7,'Mike','Jones',2172088931,'M');
insert into employee (employee_id,employee_first_name,employee_last_name,employee_phone_number,gender)
values(8,'Mike','Johnson',2172087453,'M');


insert into customer (customer_id,customer_name,customer_business,customer_phone_number,region)
values(1,'Amazon','e-commerce',8882804331,'US');
insert into customer (customer_id,customer_name,customer_business,customer_phone_number,region)
values(2,'Facebook','OnlineSocialMedia',6505434800,'US');
insert into customer (customer_id,customer_name,customer_business,customer_phone_number,region)
values(3,'Alibaba','e-commerce',8885017745,'CN');
insert into customer (customer_id,customer_name,customer_business,customer_phone_number,region)
values(4,'Redbook','e-commerce',02164224530,'CN');
insert into customer (customer_id,customer_name,customer_business,customer_phone_number,region)
values(5,'Jingdong','e-commerce',1089116155,'CN');
insert into customer (customer_id,customer_name,customer_business,customer_phone_number,region)
values(6,'Siemens','ElectricCompany',8007436367,'GER');
insert into customer (customer_id,customer_name,customer_business,customer_phone_number,region)
values(7,'Pinduoduo','e-commerce', 02161897088,'CN');
insert into customer (customer_id,customer_name,customer_business,customer_phone_number,region)
values(8,'Mobai','e-commerce',08081017141,'CN');

insert into project (project_id,project_name,budget_id,employee_id,customer_id)
values(1,'AmazonReviewChekingServce',1001,3,1);
insert into project (project_id,project_name,budget_id,employee_id,customer_id)
values(2,'FacebookNewChekingServce',1002,2,2);
insert into project (project_id,project_name,budget_id,employee_id,customer_id)
values(3,'AlibabaNewsChekingServce',1003,2,3);
insert into project (project_id,project_name,budget_id,employee_id,customer_id)
values(4,'RedbookNewsChekingServce',1004,1,4);
insert into project (project_id,project_name,budget_id,employee_id,customer_id)
values(5,'JingdongNewsChekingServce',1005,5,5);
insert into project (project_id,project_name,budget_id,employee_id,customer_id)
values(6,'SiemensNewsChekingServce',1006,4,6);
insert into project (project_id,project_name,budget_id,employee_id,customer_id)
values(7,'PinduoduoNewsChekingServce',1006,1,6);
insert into project (project_id,project_name,budget_id,employee_id,customer_id)
values(8,'MobaiNewsChekingServce',1008,6,8);

insert into source (project_id,website_name,data,author,URL)
values(1,'amazon','BadReviews',' ','amazon.com');
insert into source (project_id,website_name,data,author,URL)
values(2,'CNN','DataTrouble','Charles ','CNN.com');
insert into source (project_id,website_name,data,author,URL)
values(3,'TaoBao','BadReviews',' ','www.taobao.com');
insert into source (project_id,website_name,data,author,URL)
values(4,'XiaoHongShu','BadReviews',' ','www.xiaohongshu.com');
insert into source (project_id,website_name,data,author,URL)
values(5,'JingDong','BadReviews',' ','www.jingdong.com');
insert into source (project_id,website_name,data,author,URL)
values(6,'Sina','ServiceProblemNews',' ','www.sina.com');
insert into source (project_id,website_name,data,author,URL)
values(7,'PinDuoDuo','BadReviews',' ','www.pinduoduo.com');
insert into source (project_id,website_name,data,author,URL)
values(8,'ChinaNews','TortNews','IT home','news.china.com');

pause;

CREATE OR REPLACE PROCEDURE update_source_data
(
project_id_param NUMBER,
newdata VARCHAR2
)
AS
BEGIN
	UPDATE source
	SET data = newdata
	WHERE project_id = project_id_param;
COMMIT;
END;
/

CALL update_source_data(2,'BadNews');

pause;

CREATE OR REPLACE PROCEDURE drop_table
(
table_name VARCHAR2
)
AS
BEGIN
 EXECUTE IMMEDIATE 'DROP TABLE ' || table_name;
EXCEPTION
 WHEN OTHERS THEN
	NULL;
END;
/

pause;

CREATE OR REPLACE FUNCTION gross_profit
(
	budget_num  NUMBER
)
RETURN NUMBER
AS
	gross_profit_result NUMBER;
BEGIN
	SELECT (earn-cost) AS gross_profit_due INTO gross_profit_result FROM budget WHERE budget_num = budget_id;
RETURN gross_profit_result;
END;
/

SELECT budget_id,gross_profit(budget_id) AS gross_profit_result FROM budget WHERE budget_id = 1001;

pause;

CREATE OR REPLACE FUNCTION retained_profit_total
(
	budget_num  NUMBER
)
RETURN NUMBER
AS
	retained_profit_total NUMBER;
BEGIN
	SELECT SUM(earn-cost-flexiblecost) AS retained_profit_due INTO retained_profit_total FROM budget;
RETURN  retained_profit_total;
END;
/

SELECT distinct retained_profit_total(budget_id) AS retained_profit_total_result FROM budget;

pause;

CREATE OR REPLACE TRIGGER delete_project_trigger
BEFORE DELETE ON project
FOR EACH ROW
BEGIN 
DELETE from source WHERE project_id=:old.project_id;
END;
/

DELETE from project WHERE project_id=1;
select * from source;
select * from project;
