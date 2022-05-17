///////////////////////////////////////////////
///    TRABALHO FINAL FUNDAMENTOS DE B.D.   ///
///                                         ///
/// Acessando a Base através de um programa.///
/// Método de acesso: API - libpqxx         ///
/// Linguagem escolhida: C++                ///
///////////////////////////////////////////////

#include <iostream>
#include <pqxx/pqxx> // Biblioteca API

using namespace std;
using namespace pqxx;

// Prototypes
string truncate(string str, size_t width, bool show_ellipsis=true);
void printResult(result);
void Consulta_1(string);
void Consulta_2(string);
void Consulta_3(string);
void Consulta_4(string);
void Consulta_5(string);
void Consulta_6(string);
void Consulta_7(string);
void Consulta_8(string);
void Consulta_9(string);
void Consulta_0(string);

int main()
{
	string conn = "user=postgres hostaddr=127.0.0.1 password=123qwe dbname=trabalho_fbd"; //Dados para conexão ao BD
	char oper = ' ';

	while(oper != 's' && oper != 'S'){ //Loop menu
		try{
			connection C(conn);
			system("clear");

			cout << "-------------------------------------------------------------------------------\n";
			cout << setw(57) << right << "M E N U   D E   C O N S U L T A S\n";
			cout << "-------------------------------------------------------------------------------\n";
			cout << "1. Apelido dos usuários que ultrapassaram R$ 100 somando todas suas compras.\n\n";
			cout << "2. O número de jogos com uma determinada tag na biblioteca de cada usuário.\n\n";
			cout << "3. Titulo dos jogos de um determinado gênero que possuem DLCs.\n\n";
			cout << "4. Apelido dos amigos de um usuário que não possuem jogos em comum com ele.\n\n";
			cout << "5. Jogos de um determinado gênero e mais duas tags à sua escolha.\n\n";
			cout << "6. Empresas que desenvolveram softwares com a tag relacionada à sua busca.\n\n";
			cout << "7. Empresas desenvolvedoras cujos jogos ultrapassaram a marca de 100h de uso.\n\n";
			cout << "8. Empresas distribuidoras em ordem decrescente de faturamento.\n\n";
			cout << "9. Valor da maior compra de cada usuário que já realizou compras na plataforma.\n\n";
			cout << "0. Jogos de 2 ou mais jogadores em comum entre um usuário e seus amigos.\n\n";
			cout << "Selecione uma opção (0-9)(S:Sair): ";
		
			cin.get(oper);
			system("clear");

			switch(oper){
				case '1':
					Consulta_1(conn);
					break;
				case '2':
					Consulta_2(conn);
					break;
				case '3':
					Consulta_3(conn);
					break;
				case '4':
					Consulta_4(conn);
					break;
				case '5':
					Consulta_5(conn);
					break;
				case '6':
					Consulta_6(conn);
					break;
				case '7':
					Consulta_7(conn);
					break;
				case '8':
					Consulta_8(conn);
					break;
				case '9':
					Consulta_9(conn);
					break;
				case '0':
					Consulta_0(conn);
					break;
				case 'S':
				case 's':
					break;
			}
    } 
		catch(std::exception const &e){
			cerr << e.what() << '\n';
			return 1;
		}
	}
	return 0;
}

void Consulta_1(string conn){
	connection C(conn); // Conexão C, que utiliza os parâmetros da string conn. Objeto da classe 'connection', definida pela API.
	work W{C};          // Operação W, que utiliza a conexão como parâmetro. Objeto da classe 'work', definida pela API.

	cout << "1. Apelido dos usuários que ultrapassaram R$ 100 somando todas suas compras.\n";
	result R{W.exec( // Resultado R, um objeto da classe 'result'. Dentro do bloco, a string de operações sql é executada através do método 'exec', da classe work.
			"select nickname \
			from Usr \
			where steam_id in(select buyer_steam_id \
				from Finished_Order natural join Digital_Copy natural join Product \
				group by buyer_steam_id \
				having sum(price)>100)"
			)};
	printResult(R); // Chamada da função printResult, que recebe o resultado dos comandos sql, armazenado em R.
	cin.ignore();   // Limpa o buffer de input do usuário. 
}

void Consulta_2(string conn){
	connection C(conn);
	work W{C};
	string query_buffer; // Buffer para o input do usuário, que recebe uma Tag para consulta. 

	cout << "2. O número de jogos com uma determinada tag na biblioteca de cada usuário.\n";
	cout << "Informe a tag desejada para a busca: ";
	cin.ignore();
	getline(cin, query_buffer);

	query_buffer = "select nickname, count (*) \
									from Bibliotecas \
									where product_id in(select product_id \
											from Categorization natural join Tag \
											where tag_name = '" + query_buffer + "') \
									group by steam_id, nickname"; // O buffer é concatenado com as instruções da consulta em sql.
	result R{W.exec(query_buffer)};
	printResult(R);
}

void Consulta_3(string conn){
	connection C(conn);
	work W{C};
	string query_buffer;

	cout << "3. Titulo dos jogos de um determinado gênero que possuem DLCs.\n";
	cout << "Informe o gênero desejado para a busca: ";
	cin.ignore();
	getline(cin, query_buffer);

	query_buffer = "select product_name \
									from Product natural join Game \
									where product_id in (select game_product_id \
											from Downloadable_Content) and game_genre = '" + query_buffer + "'";
	result R{W.exec(query_buffer)};
	printResult(R);
}

void Consulta_4(string conn){
	connection C(conn);
	work W{C};
	string query_buffer;

	cout << "4. Apelido dos amigos de um usuário que não possuem jogos em comum com ele.\n";
	cout << "Informe o SteamID do usuário para a busca: ";
	cin.ignore();
	getline(cin, query_buffer);

	query_buffer = "select distinct nickname \
									from ((select friend_steam_id \
												from Usr natural join Friendship \
												where steam_id = "+query_buffer+" \
												union \
												select steam_id \
												from Usr natural join Friendship \
												where friend_steam_id = "+query_buffer+") as User_friends left join Usr on User_friends.friend_steam_id=Usr.steam_id) as EXT \
									where not exists(select product_id \
											from Bibliotecas \
											where steam_id = "+query_buffer+" and product_id in(select distinct product_id \
												from Bibliotecas \
												where steam_id = EXT.steam_id))";
	result R{W.exec(query_buffer)};
	printResult(R);
}

void Consulta_5(string conn){
	connection C(conn);
	work W{C};
	string query_buffer, genre, tag1, tag2;
		
	cout << "5. Jogos de um determinado gênero e mais duas tags à sua escolha.\n";
	cout << "Informe o gênero do jogo: ";
	cin.ignore();
	getline(cin, genre);

	cout << "Informe a tag #1: ";
	getline(cin, tag1);

	cout << "Informe a tag #2: ";
	getline(cin, tag2);

	query_buffer = "select product_name \
									from Product natural join Game \
									where game_genre = '"+ genre +"' and product_id in(select product_id \
											from Categorization natural join Tag \
											where tag_name = '"+ tag1 +"' \
											intersect \
											select product_id \
											from Categorization natural join Tag \
											where tag_name = '"+ tag2 +"')";
	result R{W.exec(query_buffer)};
	printResult(R);
}

void Consulta_6(string conn){
	connection C(conn);
	work W{C};
	string query_buffer;

	cout << "6. Empresas que desenvolveram softwares com a tag relacionada à sua busca.\n";
	cout << "Informe a tag desejada para a busca: ";
	cin.ignore();
	getline(cin, query_buffer);

	query_buffer = "select cpny_name \
									from Company natural join Development natural join Software \
									where product_id in (select product_id \
											from Tag natural join Categorization natural join Software \
											where tag_name = '"+ query_buffer +"')";
	result R{W.exec(query_buffer)};
	printResult(R);
}

void Consulta_7(string conn){
	connection C(conn);
	work W{C};
	string query_buffer;

	cout << "7. Empresas desenvolvedoras cujos jogos ultrapassaram a marca de 100h de uso.\n";
	query_buffer = "select cpny_name \
									from Company natural join Development natural join Game \
									where cpny_id in (select cpny_id \
											from Bibliotecas natural join Development natural join Company \
											group by cpny_id \
											having sum(time_played)>'100h')";
	result R{W.exec(query_buffer)};
	printResult(R);
	cin.ignore();
}

void Consulta_8(string conn){
	connection C(conn);
	work W{C};
	string query_buffer;

	cout << "8. Empresas distribuidoras em ordem decrescente de faturamento.\n";
	query_buffer = "select cpny_name, sum(price) \
									from Distribution natural join Company natural join Bibliotecas natural join Product \
									group by cpny_id, cpny_name \
									order by sum(price) desc";
	result R{W.exec(query_buffer)};
	printResult(R);
	cin.ignore();
}

void Consulta_9(string conn){
	connection C(conn);
	work W{C};
	string query_buffer;

	cout << "9. Valor da maior compra de cada usuário que já realizou compras na plataforma.\n";
	query_buffer = "select nickname, max(purchases) as top_purchase \
									from (select nickname, sum(price) as purchases \
											from Finished_Order natural join Digital_Copy natural join Product natural join Usr \
											group by buyer_steam_id, nickname, pchse_id \
											order by purchases desc) as purchases \
									group by nickname \
									order by top_purchase desc";
	result R{W.exec(query_buffer)};
	printResult(R);
	cin.ignore();
}

void Consulta_0(string conn){
	connection C(conn);
	work W{C};
	string query_buffer;

	cout << "0. Jogos de 2 ou mais jogadores em comum entre um usuário e seus amigos.\n";
	cout << "Informe o SteamID do usuário para a busca: ";
	cin.ignore();
	getline(cin, query_buffer);

	query_buffer = "select distinct nickname, product_name \
									from (select friend_steam_id \
											from Usr natural join Friendship \
											where steam_id = "+query_buffer+" \
											union \
											select steam_id \
											from Usr natural join Friendship \
											where friend_steam_id = "+query_buffer+")as U left join Bibliotecas B on (U.friend_steam_id=B.steam_id) \
									where product_id in (select distinct product_id \
											from Bibliotecas natural join Game \
											where steam_id = "+query_buffer+" and num_of_players <> 1) and \
									steam_id <>"+query_buffer;
	result R{W.exec(query_buffer)};
	printResult(R);
}

void printResult(result R){ // Função printResult, executa um laço sobre toda a matriz de resultados.
	std::cout << R.size() << " resultado(s) encontrado(s).\n";
	for (auto row = R.begin(); row != R.end(); row++)
	{
  	for (auto field = row.begin(); field != row.end(); field++)
    	std::cout << setw(20) << left << truncate(field->c_str(), 20) << "| ";
    	std::cout << std::endl;
	}
	cout << "\nPressione qualquer tecla para continuar...";
	cin.get();
}

std::string truncate(std::string str, size_t width, bool show_ellipsis) // Função de truncamento das strings que contém os resultados,
{                                                                       // para melhor visualização da tabela.
    if (str.length() > width)
        if (show_ellipsis)
            return str.substr(0, width-3) + "...";
        else
            return str.substr(0, width);
    return str;
}
