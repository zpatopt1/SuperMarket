package model;

public class FornecedorProduto {

    private Fornecedor fornecedor;
    private Produto produto;
    private float preco;

    public FornecedorProduto() {

    }

    public FornecedorProduto(Fornecedor fornecedor, Produto produto, float preco) {
        this.fornecedor = fornecedor;
        this.produto = produto;
        this.preco = preco;
    }

    public Fornecedor getFornecedor() {
        return fornecedor;
    }

    public void setFornecedor(Fornecedor fornecedor) {
        this.fornecedor = fornecedor;
    }

    public Produto getProduto() {
        return produto;
    }

    public void setProduto(Produto produto) {
        this.produto = produto;
    }

    public float getPreco() {
        return preco;
    }

    public void setPreco(float preco) {
        this.preco = preco;
    }
}