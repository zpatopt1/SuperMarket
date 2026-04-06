package model;

public class Movimentos {
    private int idMovimentos;
    private Funcionario nif;
    private String status;
    private String data;
    private String hora;
    
    public Movimentos() {
    	// TODO Auto-generated constructor stub
    }
    
    public Movimentos(int idMovimentos, Funcionario nif, String status, String data, String hora) {
    	this.idMovimentos = idMovimentos;
    	this.nif = nif;
    	this.status = status;
    	this.data = data;
    	this.hora = hora;
    }

	public int getIdMovimentos() {
		return idMovimentos;
	}

	public void setIdMovimentos(int idMovimentos) {
		this.idMovimentos = idMovimentos;
	}

	public String getNif() {
		return nif;
	}

	public void setNif(String nif) {
		this.nif = nif;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getData() {
		return data;
	}

	public void setData(String data) {
		this.data = data;
	}

	public String getHora() {
		return hora;
	}

	public void setHora(String hora) {
		this.hora = hora;
	}
}
    
    