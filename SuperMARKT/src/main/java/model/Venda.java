package model;

public class Venda {
	private Movimentos idMovimentos;
	private Cliente idCliente;
	private float valorTotal;
	
	
	public Venda() {
		
	}	
	
	public Venda(Movimentos idMovimentos, Cliente idCliente, float valorTotal) {
		this.idMovimentos = idMovimentos;
		this.idCliente = idCliente;
		this.valorTotal = valorTotal;
	}

	public Movimentos getIdMovimentos() {
		return idMovimentos;
	}

	public void setIdMovimentos(Movimentos idMovimentos) {
		this.idMovimentos = idMovimentos;
	}

	public Cliente getIdCliente() {
		return idCliente;
	}

	public void setIdCliente(Cliente idCliente) {
		this.idCliente = idCliente;
	}

	public float getValorTotal() {
		return valorTotal;
	}

	public void setValorTotal(float valorTotal) {
		this.valorTotal = valorTotal;
	}
	
}
	
	

	