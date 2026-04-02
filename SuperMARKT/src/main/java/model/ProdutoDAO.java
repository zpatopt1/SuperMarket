	package model;
	
	import java.sql.Connection;
	import java.sql.*;
	import java.sql.PreparedStatement;
	import java.util.ArrayList;
	import java.util.List;
	
	import DBconnection.DBconnection;
	
	public class ProdutoDAO {
		//CRUD - Create
		public void insert(Produto produto) {
			
			String sql = "INSERT INTO produto (id_produto, id_categoria, unidade_medida, marca, nome, cod_barras, preco) VALUES (?, ?, ?, ?, ?, ?, ?)";
	
			try (Connection conn = DBconnection.getConnection();
		    	PreparedStatement stmt = conn.prepareStatement(sql)){
	
		    	stmt.setInt(1, produto.getIdProduto());
	            stmt.setInt(2, produto.getCategoria().getIdCategoria()); // Pegamos o ID do objeto Categoria
	            stmt.setString(3, produto.getUnidadeMedida());
	            stmt.setString(4, produto.getMarca());
	            stmt.setString(5, produto.getNome());
	            stmt.setString(6, produto.getCodBarras());
	            stmt.setFloat(7, produto.getPreco());
	            
	            int rows = stmt.executeUpdate();        
	            
	            if (rows > 0) {
	                System.out.println("Produto salvo com sucesso!");
	            } else {
	                System.out.println("Nenhum produto foi inserido!");
	            }
	            } catch (Exception e) {
				e.printStackTrace();
			    throw new RuntimeException(e); 
	
			}
		}
	//	public List<Produto> getAllProdutos() {
	//	    List<Produto> produtos = new ArrayList<>();
	//	    // O SQL agora junta as duas tabelas usando o ID comum
	//	    String sql = "SELECT p.*, c.nome AS nome_categoria " +
	//	                 "FROM produto p " +
	//	                 "INNER JOIN categoria c ON p.id_categoria = c.id_categoria";
	//
	//	    try (Connection conn = DBconnection.getConnection();
	//	         PreparedStatement stmt = conn.prepareStatement(sql);
	//	         ResultSet rs = stmt.executeQuery()) {
	//
	//	        while (rs.next()) {
	//	            Categoria cat = new Categoria();
	//	            cat.setIdCategoria(rs.getInt("id_categoria"));
	//	            // Agora podes preencher o nome porque o SQL trouxe-o!
	//	            cat.setNome(rs.getString("nome_categoria")); 
	//
	//	            Produto p = new Produto();
	//	            p.setIdProduto(rs.getInt("id_produto"));
	//	            p.setCategoria(cat); // Associa o objeto categoria completo ao produto
	//	            p.setNome(rs.getString("nome"));
	//	            p.setMarca(rs.getString("marca"));
	//	            p.setUnidadeMedida(rs.getString("unidade_medida"));
	//	            p.setCodBarras(rs.getString("cod_barras"));
	//	            p.setPreco(rs.getFloat("preco"));
	//
	//	            produtos.add(p);
	//	        }
	//	    } catch (Exception e) {
	//	        e.printStackTrace();
	//	        throw new RuntimeException(e);
	//	    }
	//	    return produtos;
	//	}
	//	public List<Produto> getSearchProdutos(String nomePesquisa) {
	//	    List<Produto> produtos = new ArrayList<>();
	//	    
	//	    String sql = "SELECT p.*, c.nome AS nome_categoria " +
	//	                 "FROM produto p " +
	//	                 "INNER JOIN categoria c ON p.id_categoria = c.id_categoria " + 
	//	                 "WHERE p.nome LIKE ?";
	//
	//	    try (Connection conn = DBconnection.getConnection();
	//	         PreparedStatement stmt = conn.prepareStatement(sql)) { 
	//
	//	        stmt.setString(1, "%" + (nomePesquisa != null ? nomePesquisa : "") + "%");
	//	        try (ResultSet rs = stmt.executeQuery()) {
	//	            while (rs.next()) {
	//	                Categoria cat = new Categoria();
	//	                cat.setIdCategoria(rs.getInt("id_categoria"));
	//	                cat.setNome(rs.getString("nome_categoria")); 
	//
	//	                Produto p = new Produto();
	//	                p.setIdProduto(rs.getInt("id_produto"));
	//	                p.setCategoria(cat);
	//	                p.setNome(rs.getString("nome"));
	//	                p.setMarca(rs.getString("marca"));
	//	                p.setUnidadeMedida(rs.getString("unidade_medida"));
	//	                p.setCodBarras(rs.getString("cod_barras"));
	//	                p.setPreco(rs.getFloat("preco"));
	//
	//	                produtos.add(p);
	//	            }
	//	        }
	//	    } catch (Exception e) {
	//	        e.printStackTrace();
	//	        throw new RuntimeException(e);
	//	    }
	//	    return produtos;
	//	}
	//	
		public List<Produto> getProdutos(String nomePesquisa, String orderBy, String orderDir, int pageSize, int offset) {
		    List<Produto> produtos = new ArrayList<>();
	
		    
		    String sql = "SELECT p.*, c.nome AS nome_categoria " +
	                "FROM produto p " +
	                "INNER JOIN categoria c ON p.id_categoria = c.id_categoria ";
	         
	        // Colunas válidas para ORDER BY
	        List<String> colunasValidas = List.of("id_produto", "nome", "marca", "unidade_medida", "cod_barras", "preco");
	        
	        if (orderBy == null || !colunasValidas.contains(orderBy)) {
	            orderBy = "id_produto";
	        }
	
	        if (orderDir == null || !"DESC".equalsIgnoreCase(orderDir)) {
	            orderDir = "ASC";
	        }
	        
			if (nomePesquisa != null && !nomePesquisa.isEmpty()) {
				sql += "WHERE p.nome LIKE ? ";
			}
		    
			
	        sql += "ORDER BY " + orderBy + " " + orderDir;
	
	        sql += " LIMIT ? OFFSET ?"; 
		    
		    try (Connection conn = DBconnection.getConnection();
		    		PreparedStatement stmt = conn.prepareStatement(sql)) { 	
		    		int index = 1; //coloquei index caso aumente a quantidade de ? nao deia erro
			        if (nomePesquisa != null && !nomePesquisa.isEmpty()) {
			            stmt.setString(index++, "%" + nomePesquisa + "%");
			            
			        }
			        stmt.setInt(index++, pageSize);
			        stmt.setInt(index++, offset);
		        
			        try (ResultSet rs = stmt.executeQuery()) {
			            while (rs.next()) {
			            	
			            	
			                Categoria cat = new Categoria();
			                cat.setIdCategoria(rs.getInt("id_categoria"));
			                cat.setNome(rs.getString("nome_categoria")); 
	
			                Produto p = new Produto();
			                p.setIdProduto(rs.getInt("id_produto"));
			                p.setCategoria(cat);
			                p.setNome(rs.getString("nome"));
			                p.setMarca(rs.getString("marca"));
			                p.setUnidadeMedida(rs.getString("unidade_medida"));
			                p.setCodBarras(rs.getString("cod_barras"));
			                p.setPreco(rs.getFloat("preco"));
	
			                produtos.add(p);
			            }
	
			        }
			    } catch (Exception e) {
			        e.printStackTrace();
			        throw new RuntimeException(e);
			    }
			    return produtos;
			}
		
		
		public int getTotalProdutos(String nomePesquisa) {
		    int total = 0;
		    String sql = "SELECT COUNT(*) FROM produto p ";
	
		    if (nomePesquisa != null && !nomePesquisa.isEmpty()) {
		        sql += "WHERE p.nome LIKE ?";
		    }
	
		    try (Connection conn = DBconnection.getConnection();
		         PreparedStatement stmt = conn.prepareStatement(sql)) {
	
		        if (nomePesquisa != null && !nomePesquisa.isEmpty()) {
		            stmt.setString(1, "%" + nomePesquisa + "%");
		        }
	
		        try (ResultSet rs = stmt.executeQuery()) {
		            if (rs.next()) {
		                total = rs.getInt(1);
		            }
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		    }
	
		    return total;
		}
	}