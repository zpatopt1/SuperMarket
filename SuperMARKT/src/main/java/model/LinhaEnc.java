package model;

public class LinhaEnc {
	private int idLinhaOrder;
	private Encomenda idMovimentos;
	private Produto idProduto;
	private int quantidade;
	private float precoEncomenda;
	
	public LinhaEnc() {
		
	}
	
	public LinhaEnc(int idLinhaOrder, Encomenda idMovimentos, Produto idProduto, int quantidade, float precoEncomenda) {
		this.idLinhaOrder = idLinhaOrder;
		this.idMovimentos = idMovimentos;
		this.idProduto = idProduto;
		this.quantidade = quantidade;
		this.precoEncomenda = precoEncomenda;
	}

	public int getIdLinhaOrder() {
		return idLinhaOrder;
	}

	public void setIdLinhaOrder(int idLinhaOrder) {
		this.idLinhaOrder = idLinhaOrder;
	}

	public Encomenda getIdMovimentos() {
		return idMovimentos;
	}

	public void setIdMovimentos(Encomenda idMovimentos) {
		this.idMovimentos = idMovimentos;
	}

	public Produto getIdProduto() {
		return idProduto;
	}

	public void setIdProduto(Produto idProduto) {
		this.idProduto = idProduto;
	}

	public int getQuantidade() {
		return quantidade;
	}

	public void setQuantidade(int quantidade) {
		this.quantidade = quantidade;
	}

	public float getPrecoEncomenda() {
		return precoEncomenda;
	}

	public void setPrecoEncomenda(float precoEncomenda) {
		this.precoEncomenda = precoEncomenda;
	}
	
}