package modelo;

import java.util.Date;

public class Lote {
    private int idLote;
    private String numeroLote;
    private String nombreMedicamento;
    private int idCompra;
    private Date fechaVencimiento;
    private int stockInicial;
    private int stockActual;
    private String estado;

    // Constructor vacío
    public Lote() {}

    // Getters y Setters
    public int getIdLote() { return idLote; }
    public void setIdLote(int idLote) { this.idLote = idLote; }

    public String getNumeroLote() { return numeroLote; }
    public void setNumeroLote(String numeroLote) { this.numeroLote = numeroLote; }

    public String getNomeMedicamento() { return nombreMedicamento; }
    public void setNomeMedicamento(String nombreMedicamento) { this.nombreMedicamento = nombreMedicamento; }

    public int getIdCompra() { return idCompra; }
    public void setIdCompra(int idCompra) { this.idCompra = idCompra; }

    public Date getFechaVencimiento() { return fechaVencimiento; }
    public void setFechaVencimiento(Date fechaVencimiento) { this.fechaVencimiento = fechaVencimiento; }

    public int getStockInicial() { return stockInicial; }
    public void setStockInicial(int stockInicial) { this.stockInicial = stockInicial; }

    public int getStockActual() { return stockActual; }
    public void setStockActual(int stockActual) { this.stockActual = stockActual; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
}