package model;

public class Funcao {
    private int idFuncao;
    private String descricao;
    
	public Funcao() {
		// TODO Auto-generated constructor stub
	}
    public Funcao(int idFuncao, String descricao) {
    	this.idFuncao = idFuncao;
    	this.descricao = descricao;
    }

	public int getIdFuncao() {
		return idFuncao;
	}


	public void setIdFuncao(int idFuncao) {
		this.idFuncao = idFuncao;
	}


	public String getDescricao() {
		return descricao;
	}


	public void setDescricao(String descricao) {
		this.descricao = descricao;
	}
    
}
    
    