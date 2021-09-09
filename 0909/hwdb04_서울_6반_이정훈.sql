use world; 

-- 1. 도시명 kabul 이 속한 국가의 이름은?
desc country; 
select code, country.name
from city inner join country
on city.countrycode = country.code
where city.name = 'Kabul';

-- 2. 국가의 공식 언어 사용율이 100%인 국가의 정보를 출력하시오. 국가 이름으로 오름차순 정렬한다.(8 건) 
desc country; 
select c.name, cl.language, cl.percentage
from countrylanguage cl inner join country c
on cl.countrycode = c.code
where cl.percentage = 100
order by c.name;

-- 3. 도시명 amsterdam 에서 사용되는 주요 언어와 amsterdam 이 속한 국가는?
select ci.name, cl.language ,c.name
from city ci inner join country c
on ci.countrycode = c.code
inner join countrylanguage cl
on ci.countrycode = c.code
where ci.name = 'Amsterdam' and cl.percentage = (
								select max(percentage)
                                from countrylanguage cl
                                where cl.countrycode = ci.countrycode 
                                group by countrycode
);

-- 4. 국가명이 united 로 시작하는 국가의 정보와 수도의 이름, 인구를 함께 출력하시오. 단 수도 정보가 없다면 출력하지 않는다. (3 건)
select c.name,c. capital, ci.name 수도, ci.population 수도인구
from country c inner join city ci
on c.capital = ci.id
where c.name like 'united%';
show charset;
-- 5. 국가명이 united 로 시작하는 국가의 정보와 수도의 이름, 인구를 함께 출력하시오. 단 수도 정보가 없다면 수도 없음이라고 출력한다. (4 건)
select c.name, c.capital, ifnull(ci.name,cast('수도없음' as char character set utf8)) 수도, ifnull(ci.population,cast('수도없음' as char character set utf8)) 수도인구
from country c left join city ci
on c.capital = ci.id
where c.name like 'united%';

-- 6. 국가 코드 che 의 공식 언어 중 가장 사용률이 높은 언어보다 사용율이 높은 공식언어를 사용하는 국가는 몇 곳인가?
select count(distinct countrycode)
from countrylanguage
where percentage > (
					select max(percentage)
					from countrylanguage 
					where countrycode='che' and isofficial='T'
                    );

-- 7. 국가명 south korea 의 공식 언어는?
select language
from country c inner join countrylanguage cl
on c.code  = cl.countrycode
where c.name = 'south korea' and cl.isofficial = 'T';

-- 8. 국가 이름이 bo 로 시작하는 국가에 속한 도시의 개수를 출력하시오. (3 건)
select c.name, c.code, count(*) 도시개수
from country c inner join city
on c.code = city.countrycode
where c.name like 'bo%'
group by c.code;

-- 9. 국가 이름이 bo 로 시작하는 국가에 속한 도시의 개수를 출력하시오. 도시가 없을 경우는 단독 이라고 표시한다.(4 건)
select c.name, c.code, if(count(*)=1,
			cast('단독' as char character set utf8),count(*)) 도시개수
from country c left join city
on c.code = city.countrycode
where c.name like 'bo%'
group by c.code;

-- 10. 인구가 가장 많은 도시는 어디인가?
select countrycode, name , population
from city
where population = (
					select max(population)
                    from city);
                    
-- 11. 가장 인구가 적은 도시의 이름, 인구수, 국가를 출력하시오.
select c.name, countrycode, city.name , city.population
from city inner join country c
on city.countrycode = c.code
where city.population = (
					select min(population)
                    from city);
                    
-- 12. KOR 의 seoul 보다 인구가 많은 도시들을 출력하시오.
select countrycode, name , population
from city
where population > (
					select population
                    from city
                    where name = 'seoul');

-- 13. San Miguel 이라는 도시에 사는 사람들이 사용하는 공식 언어는?
select cl.countrycode, cl.language
from city inner join countrylanguage cl
on city.countrycode = cl.countrycode
where city.name = "San Miguel" and cl.isofficial='T';
-- 14. 국가 코드와 해당 국가의 최대 인구수를 출력하시오. 국가 코드로 정렬한다.(232 건) 
select countrycode, max(population)
from city
group by countrycode
order by countrycode;

-- 15. 국가별로 가장 인구가 많은 도시의 정보를 출력하시오. 국가 코드로 정렬한다.(232 건)
select countrycode, name, population
from city
where (countrycode,population) in (
									select countrycode, max(population)
									from city
									group by countrycode
									order by countrycode);

-- 16. 국가 이름과 함께 국가별로 가장 인구가 많은 도시의 정보를 출력하시오.(239 건)
select ci.countrycode, c.name, ci.name, ci.population
from city ci inner join country c
on ci.countrycode = c.code
where (ci.countrycode,ci.population) in (
									select countrycode, max(population)
									from city
									group by countrycode
									order by countrycode);
-- 17. 위 쿼리의 내용이 자주 사용된다. 재사용을 위해 위 쿼리의 내용을 summary 라는 이름의 view 로 생성하시오.
create view summary as
select ci.countrycode, c.name co_name, ci.name ci_name, ci.population
from city ci inner join country c
on ci.countrycode = c.code
where (ci.countrycode,ci.population) in (
									select countrycode, max(population)
									from city
									group by countrycode
									order by countrycode);
-- 18. summary 에서 KOR 의 대표도시를 조회하시오.
select *
from summary
where countrycode = 'KOR';