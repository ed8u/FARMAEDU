package pe.edu.utp.SistemaFarmaciaWeb.modelo;

import java.time.LocalDateTime;
import java.util.List;
import lombok.Data;

@Data
public class Venta {
    private int idVenta;
    private int idCliente;
    private int idUsuario; 
    private String tipoComprobante;
    private String numeroComprobante;
    private double subtotal;
    private double igv;
    private double total;
    private String metodoPago;
    private List<DetalleVenta> detalles;
    private LocalDateTime fechaVenta;
    
    private String nombreCliente;
    private String documentoCliente;
    private String nombreCajero;
}