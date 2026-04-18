package model;

import java.util.Date;

public class LinhaEnc {

    private int idLinhaOrder;
    private Encomenda encomenda;
    private Produto produto;
    private int quantidade;
    private float precoEncomenda;
    
    private Date dataValidade;

    public LinhaEnc() {
    }

    public LinhaEnc(int idLinhaOrder, Encomenda encomenda, Produto produto,
                    int quantidade, float precoEncomenda, Date dataValidade) {
        this.idLinhaOrder = idLinhaOrder;
        this.encomenda = encomenda;
        this.produto = produto;
        this.quantidade = quantidade;
        this.precoEncomenda = precoEncomenda;
        this.dataValidade = dataValidade;
    }

    public int getIdLinhaOrder() {
        return idLinhaOrder;
    }

    public void setIdLinhaOrder(int idLinhaOrder) {
        this.idLinhaOrder = idLinhaOrder;
    }

    public Encomenda getEncomenda() {
        return encomenda;
    }

    public void setEncomenda(Encomenda encomenda) {
        this.encomenda = encomenda;
    }

    public Produto getProduto() {
        return produto;
    }

    public void setProduto(Produto produto) {
        this.produto = produto;
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

    public Date getDataValidade() {
        return dataValidade;
    }

    public void setDataValidade(Date dataValidade) {
        this.dataValidade = dataValidade;
    }
}