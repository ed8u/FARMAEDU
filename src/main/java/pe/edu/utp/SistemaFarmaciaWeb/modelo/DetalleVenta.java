package pe.edu.utp.SistemaFarmaciaWeb.modelo;
import lombok.Data;

@Data
public class DetalleVenta {
    private int idDetalle;
    private int idVenta;
    private int idMedicamento;
    private int idLote;
    private int cantidad;
    private double precioUnitario;
    private double subtotal;
    
    // Campo auxiliar para recibir el JSON
    private int id; 
    private double precio;
}