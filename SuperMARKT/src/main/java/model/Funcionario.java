package model;

public class Funcionario {
    private String nif;
    private Funcao idFuncao;
    private String nome;
    private String contacto;
    private String email;
    private String password;
    private boolean ativo;
    
    public Funcionario() {

    }
    
    public Funcionario(String nif, Funcao idFuncao, String nome, String contacto) {
    	this.nif = nif;
    	this.idFuncao = idFuncao;
    	this.nome = nome;
    	this.contacto = contacto;
    }

	public String getNif() {
		return nif;
	}

	public void setNif(String nif) {
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

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public boolean isAtivo() {
		return ativo;
	}

	public void setAtivo(boolean ativo) {
		this.ativo = ativo;
	}
    
}
    
    
