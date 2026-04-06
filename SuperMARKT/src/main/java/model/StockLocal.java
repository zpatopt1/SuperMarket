package model;

public class StockLocal {
	private Produto idProduto;
	private Local idLocal;
	private int quantidade;
	
	public StockLocal() {
		
	}	
	
	public StockLocal(Produto idProduto, Local idLocal, int quantidade) {
		this.idProduto = idProduto;
		this.idLocal = idLocal;
		this.quantidade = quantidade;
	}

	public Produto getIdProduto() {
		return idProduto;
	}

	public void setIdProduto(Produto idProduto) {
		this.idProduto = idProduto;
	}

	public Local getIdLocal() {
		return idLocal;
	}

	public void setIdLocal(Local idLocal) {
		this.idLocal = idLocal;
	}

	public int getQuantidade() {
		return quantidade;
	}

	public void setQuantidade(int quantidade) {
		this.quantidade = quantidade;
	}

	
}
	
	

	