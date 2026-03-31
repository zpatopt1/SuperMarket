package model;

public class Categoria {
    private int idCategoria;
    private String nome;
    private String descricao;
    
    public Categoria() {
    	// TODO Auto-generated constructor stub
    }
    
    public Categoria(int idCategoria, String nome, String descricao ) {
    	this.setIdCategoria(idCategoria);
    	this.nome = nome;
    	this.descricao = descricao;
    }
    
	// Getters e Setters

    public int getIdCategoria() {
    	return idCategoria;
	}
	
	public void setIdCategoria(int idCategoria) {
		this.idCategoria = idCategoria;
	}
	
	public String getNome() {
		return nome;
	}
	
	public void setNome(String nome) {
		this.nome = nome;
	}
	
	public String getDescricao() {
		return descricao;
	}
	
	public void setDescricao(String descricao) {
		this.descricao = descricao;
	}	    
}