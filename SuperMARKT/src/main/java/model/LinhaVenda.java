package model;

public class LinhaVenda {
	private int idLinhaVenda;
	private Venda idMovimentos;
	private Produto idProduto;
	private int quantidade;
	private float precoVenda;
	private float iva;
	private float subtotal;
	private float desconto;
	
	public LinhaVenda() {
		
	}
	
	public LinhaVenda(int idLinhaVenda, Venda idMovimentos, Produto idProduto, int quantidade, float precoVenda, float iva, float subtotal, float desconto) {
		this.idLinhaVenda = idLinhaVenda;
		this.idMovimentos = idMovimentos;
		this.idProduto = idProduto;
		this.quantidade = quantidade;
		this.precoVenda = precoVenda;
		this.iva = iva;
		this.subtotal = subtotal;
		this.desconto = desconto;
	}

	public int getIdLinhaVenda() {
		return idLinhaVenda;
	}

	public void setIdLinhaVenda(int idLinhaVenda) {
		this.idLinhaVenda = idLinhaVenda;
	}

	public Venda getIdMovimentos() {
		return idMovimentos;
	}

	public void setIdMovimentos(Venda idMovimentos) {
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

	public float getPrecoVenda() {
		return precoVenda;
	}

	public void setPrecoVenda(float precoVenda) {
		this.precoVenda = precoVenda;
	}

	public float getIva() {
		return iva;
	}

	public void setIva(float iva) {
		this.iva = iva;
	}

	public float getSubtotal() {
		return subtotal;
	}

	public void setSubtotal(float subtotal) {
		this.subtotal = subtotal;
	}

	public float getDesconto() {
		return desconto;
	}

	public void setDesconto(float desconto) {
		this.desconto = desconto;
	}
	
}