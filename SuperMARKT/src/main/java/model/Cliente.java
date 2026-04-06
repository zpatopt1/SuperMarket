package model;

public class Cliente {
    private int idCliente;
    private String nome;
    private String contacto;
    private String nif;
    
    public Cliente() {
    	// TODO Auto-generated constructor stub
    }
    
    public Cliente(int idCliente, String nome, String contacto, String nif) {
    	this.idCliente = idCliente;
    	this.nome = nome;
    	this.contacto = contacto;
    	this.nif = nif;
    }

	public int getIdCliente() {
		return idCliente;
	}

	public void setIdCliente(int idCliente) {
		this.idCliente = idCliente;
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

	public String getNif() {
		return nif;
	}

	public void setNif(String nif) {
		this.nif = nif;
	}
    
}
    
    