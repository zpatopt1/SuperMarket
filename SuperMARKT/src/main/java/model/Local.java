package model;

public class Local {
	private int idLocal;
	private String nome;
	private String tipoLocal;
	
	public Local() {
		
	}
	
	public Local(int idLocal, String nome, String tipoLocal) {
		this.idLocal = idLocal;
		this.nome = nome;
		this.tipoLocal = tipoLocal;
	}

	// Getters e Setters
	
	public int getIdLocal() {
		return idLocal;
	}

	public void setIdLocal(int idLocal) {
		this.idLocal = idLocal;
	}

	public String getNome() {
		return nome;
	}

	public void setNome(String nome) {
		this.nome = nome;
	}

	public String getTipoLocal() {
		return tipoLocal;
	}

	public void setTipoLocal(String tipoLocal) {
		this.tipoLocal = tipoLocal;
	}
}