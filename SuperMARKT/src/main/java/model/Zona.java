package model;

public class Zona {
    private int idZona;
    private Local idLocal;
    private String nome;
    
    public Zona() {
    	// TODO Auto-generated constructor stub
    }
    
    public Zona(int idZona, Local idLocal, String nome) {
    	this.idZona = idZona;
    	this.idLocal = idLocal;
    	this.nome = nome;
    }

	public int getIdZona() {
		return idZona;
	}

	public void setIdZona(int idZona) {
		this.idZona = idZona;
	}

	public Local getIdLocal() {
		return idLocal;
	}

	public void setIdLocal(Local idLocal) {
		this.idLocal = idLocal;
	}

	public String getNome() {
		return nome;
	}

	public void setNome(String nome) {
		this.nome = nome;
	}

}
    