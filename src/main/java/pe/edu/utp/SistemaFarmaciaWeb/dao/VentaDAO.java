package pe.edu.utp.SistemaFarmaciaWeb.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Date;
import pe.edu.utp.SistemaFarmaciaWeb.config.ConexionDB;
import pe.edu.utp.SistemaFarmaciaWeb.modelo.DetalleVenta;
import pe.edu.utp.SistemaFarmaciaWeb.modelo.Venta;

public class VentaDAO {

    public boolean registrarVenta(Venta venta) {
        Connection con = null;
        boolean exito = false;

        try {
            con = ConexionDB.getConexion();
            con.setAutoCommit(false);

            String prefix = venta.getTipoComprobante().equals("FACTURA") ? "F001-" : "B001-";
            String numComprobante = prefix + new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());

            String sqlVenta = "INSERT INTO Ventas (id_cliente, id_usuario, tipo_comprobante, numero_comprobante, subtotal, igv, total, metodo_pago) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

            int idVentaGenerado = 0;
            try (PreparedStatement psVenta = con.prepareStatement(sqlVenta, Statement.RETURN_GENERATED_KEYS)) {
                psVenta.setInt(1, venta.getIdCliente());
                psVenta.setInt(2, venta.getIdUsuario());
                psVenta.setString(3, venta.getTipoComprobante());
                psVenta.setString(4, numComprobante);
                psVenta.setDouble(5, venta.getSubtotal());
                psVenta.setDouble(6, venta.getIgv());
                psVenta.setDouble(7, venta.getTotal());
                psVenta.setString(8, venta.getMetodoPago());
                psVenta.executeUpdate();

                try (ResultSet rsKeys = psVenta.getGeneratedKeys()) {
                    if (rsKeys.next()) {
                        idVentaGenerado = rsKeys.getInt(1);
                    }
                }
            }

            String sqlLotes = "SELECT id_lote, stock_actual FROM LotesMedicamentos "
                    + "WHERE id_medicamento = ? AND stock_actual > 0 AND estado = 1 "
                    + "ORDER BY fecha_vencimiento ASC";

            String sqlUpdateLote = "UPDATE LotesMedicamentos SET stock_actual = ? WHERE id_lote = ?";

            String sqlDetalle = "INSERT INTO DetalleVentas (id_venta, id_medicamento, id_lote, cantidad, precio_unitario, subtotal) "
                    + "VALUES (?, ?, ?, ?, ?, ?)";

            try (PreparedStatement psLotes = con.prepareStatement(sqlLotes); PreparedStatement psUpdateLote = con.prepareStatement(sqlUpdateLote); PreparedStatement psDetalle = con.prepareStatement(sqlDetalle)) {

                for (DetalleVenta item : venta.getDetalles()) {
                    int idMed = item.getId();
                    int cantidadRequerida = item.getCantidad();
                    double precioUnitario = item.getPrecio();

                    psLotes.setInt(1, idMed);
                    try (ResultSet rsLotes = psLotes.executeQuery()) {

                        while (rsLotes.next() && cantidadRequerida > 0) {
                            int idLote = rsLotes.getInt("id_lote");
                            int stockLote = rsLotes.getInt("stock_actual");

                            int cantidadADescontar = Math.min(cantidadRequerida, stockLote);

                            psUpdateLote.setInt(1, stockLote - cantidadADescontar);
                            psUpdateLote.setInt(2, idLote);
                            psUpdateLote.executeUpdate();

                            psDetalle.setInt(1, idVentaGenerado);
                            psDetalle.setInt(2, idMed);
                            psDetalle.setInt(3, idLote);
                            psDetalle.setInt(4, cantidadADescontar);
                            psDetalle.setDouble(5, precioUnitario);
                            psDetalle.setDouble(6, cantidadADescontar * precioUnitario);
                            psDetalle.executeUpdate();

                            cantidadRequerida -= cantidadADescontar;
                        }
                    }

                    if (cantidadRequerida > 0) {
                        throw new Exception("Quiebre de stock inesperado para el Medicamento ID: " + idMed);
                    }
                }
            }

            con.commit();
            exito = true;

        } catch (Exception e) {
            System.err.println("ROLLBACK EJECUTADO. Error en venta: " + e.getMessage());
            try {
                if (con != null) {
                    con.rollback();
                }
            } catch (Exception ex) {
            }
        } finally {
            try {
                if (con != null) {
                    con.setAutoCommit(true);
                    con.close();
                }
            } catch (SQLException ex) {
            }
        }

        return exito;
    }
}
