package model;

public class Funcionario {
    private int nif;
    private Funcao idFuncao;
    private String nome;
    private String contacto;
    
    public Funcionario() {
    	// TODO Auto-generated constructor stub
    }
    
    public Funcionario(int nif, Funcao idFuncao, String nome, String contacto) {
    	this.nif = nif;
    	this.idFuncao = idFuncao;
    	this.nome = nome;
    	this.contacto = contacto;
    }

	public int getNif() {
		return nif;
	}

	public void setNif(int nif) {
		this.nif = nif;
	}

	public Funcao getIdFuncao() {
		return idFuncao;
	}

	public void setIdFuncao(Funcao idFuncao) {
		this.idFuncao = idFuncao;
	}

	public String getNome() {
		return nome;
	}

	public void setNome(String nome) {
		this.nome = nome;
	}

	public String getContacto() {
		return contacto;
	}

	public void setContacto(String contacto) {
		this.contacto = contacto;
	}
    
}
    
    