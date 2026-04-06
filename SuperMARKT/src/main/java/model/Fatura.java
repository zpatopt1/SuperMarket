package model;

public class Fatura {
    private int nrFatura;
    private Venda idMovimentos;
    
    public Fatura() {
    	// TODO Auto-generated constructor stub
    }
    
    public Fatura(int nrFatura, Venda idMovimentos) {
    	this.nrFatura = nrFatura;
    	this.idMovimentos = idMovimentos;
    }

	public int getNrFatura() {
		return nrFatura;
	}

	public void setNrFatura(int nrFatura) {
		this.nrFatura = nrFatura;
	}

	public Venda getIdMovimentos() {
		return idMovimentos;
	}

	public void setIdMovimentos(Venda idMovimentos) {
		this.idMovimentos = idMovimentos;
	}

}
    
    