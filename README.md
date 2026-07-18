# SuperMARKT
O **SuperMARKT** é um sistema web completo e integrado para a gestão de inventário, controlo de prazos de validade por lotes, movimentações físicas de stock e faturação de vendas para supermercados. 
Desenvolvido para a cadeira de **Programação para a Web**, o projeto adota o padrão de arquitetura **MVC (Model-View-Controller)** com tecnologias nativas do ecossistema Java EE / Jakarta EE, sem recurso a frameworks externas pesadas, focando-se no domínio puro do protocolo HTTP e da persistência de dados relacional.
---
## Principais Funcionalidades
### Gestão de Inventário e Validades
* **Rastreio por Lotes (`stock_lote`)**: Os produtos são monitorizados individualmente por remessas, associando quantidades a datas de expiração específicas.
* **Alertas Visuais de Validade**: A listagem de stock local sinaliza automaticamente (com indicadores visuais coloridos) os produtos perto do prazo de expiração para remoção segura.
* **Registo de Quebras (Perdas)**: Fluxo dedicado para registar quebras de stock justificadas (ex: Validade Expirada, Produto Danificado, Furto) com auditoria associada.
### Perfis de Utilizador (RBAC)
* **Administrador**: Gestão de funcionários, ativação/desativação de utilizadores e ecrã de promoções.
* **Repositor**: Consulta de stock, transferência de stock entre locais (Armazém $\rightarrow$ Loja), gestão de zonas físicas e registo de quebras.
* **Operador de Caixa**: Registo de vendas, carrinho de compras, devoluções com opção de reposição de stock e consulta de clientes.
### Logística & Estatísticas
* **Movimentação Física de Stock**: Transferência de produtos entre diferentes locais e atribuição flexível a zonas físicas (ex: prateleiras, corredores).
* **Encomendas a Fornecedores**: Gestão de pedidos de reposição com custos de envio, prazos previstos de entrega e exportação de dados em formato CSV.
* **Dashboard Operacional**: KPIs em tempo real com faturação diária, quantidade de artigos, alertas de rutura de stock e gráficos de vendas.
---
## Stack Tecnológica
* **Back-End**: Java EE / Jakarta EE (Servlets, JSP, Filters, JDBC)
* **Base de Dados**: MySQL 8+
* **Front-End**: HTML5, CSS3 Nativo (responsivo com CSS Grid/Flexbox), Vanilla JavaScript (Modais e validações assíncronas)
* **Servidor de Aplicações**: Apache Tomcat (v10.0+)
* **IDE Recomendada**: Eclipse IDE para Enterprise Java Developers
---
## Arquitetura do Sistema
O projeto divide-se em três camadas bem definidas:
```
[Cliente / Browser] 
       │ ▲  (Pedidos HTTP / Resposta HTML)
       ▼ │
┌────────────────────────────────────────────────────────┐
│                      VIEW (JSP)                        │
│ - Páginas dinâmicas renderizadas no servidor.          │
│ - Componentes reutilizáveis (sidebar, topbar).         │
└──────────────────┬──────────────────▲──────────────────┘
                   │                  │
┌──────────────────▼──────────────────┴──────────────────┐
│                   CONTROLLER (Servlets)                │
│ - Processa pedidos GET/POST (ex: RegistarPerdaServlet) │
│ - Controlo de rotas seguro através do AuthFilter.      │
│ - Gestão de sessões de utilizadores.                   │
└──────────────────┬──────────────────▲──────────────────┘
                   │                  │
┌──────────────────▼──────────────────┴──────────────────┐
│                     MODEL (Java / DAO)                 │
│ - POJOs (Produto, Funcionario, Venda, PerdaStock).     │
│ - Camada DAO para operações CRUD baseadas em JDBC.     │
└────────────────────────────────────────────────────────┘
```
### Filtro de Autenticação (`AuthFilter`)
Implementa uma barreira de segurança global (`@WebFilter("/*")`) que valida a sessão ativa e restringe o acesso aos recursos protegidos (Servlets e JSPs) em conformidade com as permissões atribuídas a cada cargo de funcionário.
### Modelação Relacional (Herança de Movimentos)
A base de dados MySQL utiliza o padrão **Class Table Inheritance** para transações de inventário. 
* A tabela **`movimentos`** atua como tabela pai, centralizando as colunas de auditoria: utilizador (NIF), data, hora e status.
* As tabelas filhas **`venda`**, **`devolucao`**, **`encomenda`** e **`perda_stock`** contêm os dados específicos de cada tipo de transação física, partilhando o mesmo ID do movimento através de uma chave estrangeira e primária simultânea (relação 1:1).
---
## Instalação e Configuração
### 1. Clonar o Repositório
```bash
git clone https://github.com/o-teu-utilizador/SuperMarket.git
```
### 2. Configurar a Base de Dados
1. Certifica-te de que tens o MySQL Server a correr localmente.
2. Cria a base de dados importando o script de tabelas:
   ```bash
   mysql -u root -p < SuperMARKT/SQL/supermercado.sql
   ```
3. (Opcional) Importa dados fictícios para testes:
   ```bash
   mysql -u root -p < "SuperMARKT/SQL/criar dados.sql"
   ```
### 3. Configurar a Ligação JDBC
Acede ao ficheiro `DBconnection.java` no pacote `DBconnection` do backend e ajusta as credenciais de acesso ao teu servidor de MySQL local:
```java
// SuperMARKT/src/main/java/DBconnection/DBconnection.java
private static final String URL = "jdbc:mysql://localhost:3306/supermercado";
private static final String USER = "o_teu_utilizador";
private static final String PASSWORD = "a_tua_password";
```
### 4. Executar no Eclipse / Tomcat
1. Importa o projeto no Eclipse IDE como um **Existing Projects into Workspace**.
2. Configura o teu servidor **Apache Tomcat 10.0+** na vista de *Servers* do Eclipse.
3. Clica com o botão direito no projeto `SuperMARKT` $\rightarrow$ **Run As** $\rightarrow$ **Run on Server**.
4. Acede à aplicação no teu browser através do endereço padrão:
   `http://localhost:8080/SuperMARKT/`
---
## Gestão e Divisão de Tarefas
O desenvolvimento deste projeto pautou-se por metodologias ágeis de desenvolvimento colaborativo:
* **Trello**: Utilizado para criar um quadro Kanban central, definir o *Backlog* de funcionalidades, delegar tarefas específicas a cada membro e acompanhar o progresso (A Fazer $\rightarrow$ Em Curso $\rightarrow$ Feito), evitando conflitos ou trabalho redundante.
* **GitHub Workflow**: Adoção de controlo de versões distribuído, recorrendo a *feature branches* dedicadas para evitar alterações em simultâneo no ramo principal (`main`) e garantir uma integração limpa de código.
