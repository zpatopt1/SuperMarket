package model;

public class Produto {
    private int idProduto;
    private Categoria idCategoria; // Relacionamento
    private String unidadeMedida;
    private String marca;
    private String nome;
    private String codBarras;
    private float preco;
    
	public Produto() {
		// TODO Auto-generated constructor stub
	}
	
	public Produto(int idProduto, Categoria idCategoria, String unidadeMedida, String marca, String nome, String codBarras, float preco) {
		this.idProduto = idProduto;
		this.idCategoria = idCategoria;
		this.unidadeMedida = unidadeMedida;
		this.marca = marca;
		this.nome = nome;
		this.codBarras = codBarras;
		this.preco = preco;
	}

    // Getters e Setters

	public int getIdProduto() {
		return idProduto;
	}


	public void setIdProduto(int idProduto) {
		this.idProduto = idProduto;
	}


	public Categoria getCategoria() {
		return idCategoria;
	}


	public void setCategoria(Categoria categoria) {
		this.idCategoria = categoria;
	}


	public String getUnidadeMedida() {
		return unidadeMedida;
	}


	public void setUnidadeMedida(String unidadeMedida) {
		this.unidadeMedida = unidadeMedida;
	}


	public String getMarca() {
		return marca;
	}


	public void setMarca(String marca) {
		this.marca = marca;
	}


	public String getNome() {
		return nome;
	}


	public void setNome(String nome) {
		this.nome = nome;
	}


	public String getCodBarras() {
		return codBarras;
	}


	public void setCodBarras(String codBarras) {
		this.codBarras = codBarras;
	}


	public float getPreco() {
		return preco;
	}


	public void setPreco(float preco) {
		this.preco = preco;
	}




}