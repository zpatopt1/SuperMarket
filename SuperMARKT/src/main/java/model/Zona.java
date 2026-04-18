package model;

public class Zona {
    private int idZona;
    private Local local;
    private String nome;
    
    public Zona() {
    	// TODO Auto-generated constructor stub
    }
    
    public Zona(int idZona, Local local, String nome) {
    	this.idZona = idZona;
    	this.local = local;
    	this.nome = nome;
    }

	public int getIdZona() {
		return idZona;
	}

	public void setIdZona(int idZona) {
		this.idZona = idZona;
	}

	public Local getLocal() {
		return local;
	}

	public void setLocal(Local local) {
		this.local = local;
	}

	public String getNome() {
		return nome;
	}

	public void setNome(String nome) {
		this.nome = nome;
	}

}
    