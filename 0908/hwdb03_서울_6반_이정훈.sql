use world;
select @@autocommit;
set autocommit = false;
-- 1. country 에서 전체 자료의 수와 독립 연도가 있는 자료의 수를 각각 출력하시오.
select count(*)"전체", count(IndepYear) "독립 연도 보유수" from country;

-- 2. country 에서 기대 수명의 합계, 평균, 최대, 최소를 출력하시오. 평균은 소수점 2 자리로 반올림한다. 
select sum(LifeExpectancy) "합계",
round(avg(LifeExpectancy),2) "평균",
max(LifeExpectancy) "최대",
min(LifeExpectancy) "최소"
from country;


-- 3. country 에서 continent 별 국가의 개수와 인구의 합을 구하시오. 국가 수로 정렬 처리한다.(7 건) 
select Continent, count(code) '국가 수', sum(Population) '인구 합'
from country
group by Continent
order by 2 desc;

-- 4. country 에서 대륙별 국가 표면적의 합을 구하시오. 면적의 합으로 내림차순 정렬하고 상위 3 건만 출력한다. 
select Continent, sum(SurfaceArea) '표면적 합'
from country
group by Continent
order by 2 desc
limit 3;

-- 5. country 에서 대륙별로 인구가 50,000,000 이상인 나라의 gnp 총 합을 구하시오. 합으로 오름차순 정렬한다.(5 건) 
select Continent, sum(GNP) 'gnp 합'
from country
where Population >= 50000000
group by Continent
order by 2 ;

-- 6. country 에서 대륙별로 인구가 50,000,000 이상인 나라의 gnp 총 합을 구하시오. 이때 gnp 의 합이 5,000,000 이상인 것만 구하시오. 
select Continent, sum(GNP) 'gnp 합'
from country
where Population >= 50000000
group by Continent
having sum(GNP) >=5000000;

-- 7. country 에서 연도별로 10 개 이상의 나라가 독립한 해는 언제인가? 
select IndepYear, count(*) "독립 국가 수"
from country
where IndepYear is not null
group by IndepYear 
having count(*) >= 10;

-- 8. country 에서 국가별로 gnp 와 함께 전세계 평균 gnp, 대륙 평균 gnp 를 출력하시오.(239 건) 
select Continent, name, gnp , avg(GNP) over()"전세계 평균 gnp", avg(gnp) over(partition by Continent) "대륙 평균 gnp"
from country;

-- 9. countrylanguage 에 countrycode='AAA', language='외계어', isOfficial='F', percentage=10 을 추가하시오. 값을 추가할 수 없는 이유를 생각하고 필요한 부분을 수정해서 다시 추가하시오. 

insert into countrylanguage values('AAA','외계어','F',10); -- 한글 안됨, 외래키 country 테이블의 code 에 'AAA' 가 존재하지 않음
insert into countrylanguage values('ABW','Alien','F',10);

-- 10. countrylanguage 에 countrycode='ABW', language='Dutch', isOfficial='F', percentage=10 을 추가하시오. # 값을 추가할 수 없는 이유를 생각하고 필요한 부분을 수정해서 다시 추가하시오.
insert into countrylanguage values('ABW','Dutch','F',10); -- primary key 'ABW' 'Dutch' 가 이미 존재함
insert into countrylanguage values('ABW','Dutch2','F',10);

-- 11. country 에 다음 자료를 추가하시오. # Code='TCode', Region='TRegion',Code2='TC' # 값을 추가할 수 없는 이유를 생각하고 필요한 부분을 수정해서 다시 추가하시오.
desc country;
insert into country(Code,region,Code2) values('TCode','Tregion','TC'); -- Code는 3글자
insert into country(Code,region,Code2) values('TCo','Tregion','TC');

-- 12. city 에서 id 가 2331 인 자료의 인구를 10% 증가시킨 후 조회하시오.
update city set population = population*1.1 where id=2331;
select id, name, population
from city
where id = 2331;

-- 13. country 에서 code 가 'USA'인 자료를 삭제하시오. # 삭제가 안되는 이유를 생각하고 성공하려면 어떤 절차가 필요한지 생각만 하시오. 
delete from country where code='USA'; -- countrylanguage 테이블의 countrycode와 연동중 외래키


-- 14. 이제 까지의 DML 작업을 모두 되돌리기 위해 rollback 처리하시오. 
rollback;
-- 15. ssafydb 라는 이름으로 새로운 schema 를 생성하시오.
create database ssafy_ws_6th;
use ssafy_ws_6th;
-- 16. 만약 user 라는 테이블이 존재한다면 삭제하시오. 
drop table if exists user;
-- 17. ssafydb  에 다음 조건을 만족하는 테이블을 생성하시오.
create table user(
	id varchar(50) primary key,
    name varchar(100) not null default '익명',
    pass varchar(100) not null
    
);
desc user;
-- 18. user 테이블에 다음의 자료를 추가하시오. 
# id: ssafy, pass: 1234, name:김싸피 
# id: hong, pass: 5678, name:홍싸피  
# id: test, pass: test, name:테스트 
insert into user(id,pass,name) values ('ssafy','1234','김싸피'),('hong','5678','홍싸피'),('test','test','테스트');

select * from user;
-- 19. id 가 test 인 계정의 pass 를 id@pass 형태로 변경하고 조회하시오. 
update user set pass = concat(id,'@',pass)
where id = 'test';
-- 20. id 가 test 인 계정의 자료를 삭제하고 조회하시오. 
delete from user where id = 'test';
-- 21. 현재까지의 내용을 영구 저장하기 위해서 commit 처리하시오. 
commit;