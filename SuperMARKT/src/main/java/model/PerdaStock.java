package model;

import java.util.Date;

public class PerdaStock {
    private int idPerda;
    private Produto produto;
    private Local local;
    private int quantidade;
    private String motivo;
    private Date dataRegisto;

    public PerdaStock() {
    }

    public PerdaStock(int idPerda, Produto produto, Local local, int quantidade, String motivo, Date dataRegisto) {
        this.idPerda = idPerda;
        this.produto = produto;
        this.local = local;
        this.quantidade = quantidade;
        this.motivo = motivo;
        this.dataRegisto = dataRegisto;
    }

    public int getIdPerda() {
        return idPerda;
    }

    public void setIdPerda(int idPerda) {
        this.idPerda = idPerda;
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

    public String getMotivo() {
        return motivo;
    }

    public void setMotivo(String motivo) {
        this.motivo = motivo;
    }

    public Date getDataRegisto() {
        return dataRegisto;
    }

    public void setDataRegisto(Date dataRegisto) {
        this.dataRegisto = dataRegisto;
    }
}