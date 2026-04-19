package model;

public class StockLocal {
    private Produto produto;
    private Local local;
    private int quantidade;

    public StockLocal() {
    }

    public StockLocal(Produto produto, Local local, int quantidade) {
        this.produto = produto;
        this.local = local;
        this.quantidade = quantidade;
    }

    public Produto getProduto() {
        return produto;
    }

    public void setProduto(Produto produto) {
        this.produto = produto;
    }

    public Local getLocal() {
        return local;
    }

    public void setLocal(Local local) {
        this.local = local;
    }

    public int getQuantidade() {
        return quantidade;
    }

    public void setQuantidade(int quantidade) {
        this.quantidade = quantidade;
    }
}
	
	

	