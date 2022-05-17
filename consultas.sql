/* Consultas.sql */

DROP VIEW IF EXISTS Bibliotecas;

/*Visão: biblioteca contendo todas as cópias digitais de produtos 
adquiridas pelos usuários da plataforma, acompanhado de seu tempo de uso.*/

create view Bibliotecas
as select steam_id, nickname, product_id, product_name, time_played
from Usr natural join Digital_Copy natural join Product;

select * 
from Bibliotecas;

/*1. Listar o apelido (nickname) dos usuários que ultrapassaram R$ 100 
somando todas as suas compras. [GROUP BY, HAVING, Subquery, 4 tabelas]*/

select nickname as top_buyers
from Usr
where steam_id IN (select buyer_steam_id
				  from Finished_Order natural join Digital_Copy natural join Product
				  group by buyer_steam_id
				  having sum(price)>100);
				  
/*2. O número de JOGOS (desconsiderar DLCs, softwares e afins) com a tag "First-Person" 
na biblioteca de cada usuário [GROUP BY, Subquery, Visão, 3 tabelas]*/

select nickname, count (*) as FPS_games_in_library
from Bibliotecas
where product_id IN (select product_id
					 from Categorization natural join Tag
					 where tag_name = 'First-Person')
group by steam_id, nickname;

/*3. Título dos jogos do gênero "Action" que possuem conteúdos extras 
(Downloadable Content) associados. [Subquery, 3 tabelas]*/

select product_name as action_games_with_dlc
from Product natural join Game
where product_id IN (select game_product_id
					 from Downloadable_Content) and game_genre = 'Action';
					
/*4. Apelido dos usuários que são amigos do usuário steam_id 1100000011 e que não possuem 
nenhum dos jogos que ele possui. [Not Exists, Visão, Subquery, 3 tabelas]*/

select distinct nickname --as friends_no_games_in_common
from ((select friend_steam_id
	  from Usr natural join Friendship
	  where steam_id = 1100000011
	  union
	  select steam_id
	  from Usr natural join Friendship
	  where friend_steam_id = 1100000011) as User_friends left join Usr on User_friends.friend_steam_id=Usr.steam_id) as EXT
	  where not exists(select product_id
					   from Bibliotecas 
					   where steam_id = 1100000011 and product_id in(select distinct product_id
																	 from Bibliotecas
																	 where steam_id = EXT.steam_id));
																	 
/*5 Listar o nome de todos os Jogos indie do gênero corrida (Racing) que são 
compatíveis com Windows. [Subquery, 4 tabelas]*/

select product_name as windows_indie_racing_games
from Product natural join Game
where game_genre = 'Racing' and product_id in(select product_id
											  from Categorization natural join Tag
											  where tag_name = 'Indie'
											  intersect
											  select product_id
											  from Categorization natural join Tag
											  where tag_name = 'Windows Compatible');
											  
/*6. Listar apenas as empresas que desenvolveram algum software (não incluir jogos, DLCs ou 
trilhas sonoras) compatível com Linux. [Subquery, 4 tabelas]*/

select cpny_name as linux_software_devs
from Company natural join Development natural join Software
where product_id in(select product_id
				   from Tag natural join Categorization natural join Software
				   where tag_name = 'Linux Compatible');

/*7. Listar as empresas desenvolvedoras cujos jogos ultrapassaram a marca de 100h de uso
somando todos os usuários cadastrados.[Subquery, GROUP BY, Having, Visão, 4 Tabelas]*/

select cpny_name as cpny_time_spent_over100h
from Company natural join Development natural join Game
where cpny_id in(select cpny_id
				 from Bibliotecas natural join Development natural join Company
				 group by cpny_id
				 having sum(time_played)>'100h');
				 
/*8. Listar as empresas distribuidoras, em ordem decrescente de faturamento 
(soma de todos os produtos vendidos) [GROUP BY, Visão, 4 tabelas]*/

select cpny_name, sum(price) as earnings
from Distribution natural join Company natural join Bibliotecas natural join Product
group by cpny_id, cpny_name
order by sum(price) desc;

/*9. Listar o valor da maior compra de cada usuário (que realizou ao menos uma compra
na plataforma) em ordem decrescente.[GROUP BY, 4 tabelas]*/

select nickname, max(purchases) as top_purchase from (select nickname, sum(price) as purchases
													  from Finished_Order natural join Digital_Copy natural join Product natural join Usr
													  group by buyer_steam_id, nickname, pchse_id
													  order by purchases desc) as purchases
group by nickname
order by top_purchase desc;

/*10. Listar os jogos de 2 ou mais jogadores em comum entre o usuário de id 1100000011 
e seus amigos, e o nickname do amigo que possui o jogo.

OBS: Código para atributo num_of_players(SMALLINT):
0 - Multijogador massivo (suporta mais que 9 jogadores)
1 - Um jogador
2 - Dois jogadores
(...)

[Subquery, 3 tabelas]*/

select distinct nickname as friends, product_name as multiplayer_games_in_common
from(select friend_steam_id
	from Usr natural join Friendship
	where steam_id = 1100000011
	union
	select steam_id
	from Usr natural join Friendship
	where friend_steam_id = 1100000011)as U left join Bibliotecas B on(U.friend_steam_id=B.steam_id)
where product_id in(select distinct product_id
				   from Bibliotecas natural join Game
				   where steam_id = 1100000011 and num_of_players <> 1) and
				   steam_id <> 1100000011;
