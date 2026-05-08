package model;

import java.sql.Date;
import java.sql.Time;

public class Movimentos {
    private int idMovimentos;
    private Funcionario funcionario;
    private String status;
    private Date data;
    private Time hora;
    
    public Movimentos() {
    	// TODO Auto-generated constructor stub
    }
    
    public Movimentos(int idMovimentos, Funcionario funcionario, String status, Date data, Time hora) {
    	this.idMovimentos = idMovimentos;
    	this.funcionario = funcionario;
    	this.status = status;
    	this.data = data;
    	this.hora = hora;
    }	

	public int getIdMovimentos() {
		return idMovimentos;
	}

	public void setIdMovimentos(int idMovimentos) {
		this.idMovimentos = idMovimentos;
	}

	public Funcionario getFuncionario() {
		return funcionario;
	}

	public void setFuncionario(Funcionario funcionario) {
		this.funcionario = funcionario;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Date getData() {
		return data;
	}

	public void setData(Date date) {
		this.data = date;
	}

	public void setHora(Time hora) {
		this.hora = hora;
	}

	public Time getHora() {
		return hora;
	}


}
    