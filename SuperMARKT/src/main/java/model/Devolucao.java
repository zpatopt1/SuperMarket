package model;

public class Devolucao {
	private Movimentos idMovimentos;
	private LinhaVenda idLinhavenda;
	private String motivo;
	private int quantidade;
	private float valor;
	private boolean reporStock;
	
	public Devolucao() {
		
	}
	
	public Devolucao(Movimentos idMovimentos, LinhaVenda idLinhaVenda, String motivo, int quantidade, float valor, boolean reporStock) {
		this.idMovimentos = idMovimentos;
		this.idLinhavenda = idLinhaVenda;
		this.motivo = motivo;
		this.quantidade = quantidade;
		this.valor = valor;
		this.reporStock = reporStock;
	}

	public Movimentos getIdMovimentos() {
		return idMovimentos;
	}

	public void setIdMovimentos(Movimentos idMovimentos) {
		this.idMovimentos = idMovimentos;
	}

	public LinhaVenda getIdLinhavenda() {
		return idLinhavenda;
	}

	public void setIdLinhavenda(LinhaVenda idLinhavenda) {
		this.idLinhavenda = idLinhavenda;
	}

	public String getMotivo() {
		return motivo;
	}

	public void setMotivo(String motivo) {
		this.motivo = motivo;
	}

	public int getQuantidade() {
		return quantidade;
	}

	public void setQuantidade(int quantidade) {
		this.quantidade = quantidade;
	}

	public float getValor() {
		return valor;
	}

	public void setValor(float valor) {
		this.valor = valor;
	}

	public boolean isReporStock() {
		return reporStock;
	}

	public void setReporStock(boolean reporStock) {
		this.reporStock = reporStock;
	}

}