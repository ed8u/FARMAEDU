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
            } catch (SQLException ex) {
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

    public double obtenerIngresosHoy() {
        String sql = "SELECT ISNULL(SUM(total), 0) AS total_hoy FROM Ventas "
                + "WHERE CAST(fecha_venta AS DATE) = CAST(GETDATE() AS DATE) AND estado = 1";
        try (Connection con = ConexionDB.getConexion(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble("total_hoy");
            }
        } catch (Exception e) {
            System.err.println("Error al obtener ingresos de hoy: " + e.getMessage());
        }
        return 0.0;
    }

    public int contarVentasHoy() {
        String sql = "SELECT COUNT(*) AS cant_hoy FROM Ventas "
                + "WHERE CAST(fecha_venta AS DATE) = CAST(GETDATE() AS DATE) AND estado = 1";
        try (Connection con = ConexionDB.getConexion(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("cant_hoy");
            }
        } catch (Exception e) {
            System.err.println("Error al contar ventas de hoy: " + e.getMessage());
        }
        return 0;
    }

    public java.util.List<Venta> listarUltimasVentas(int limite) {
        java.util.List<Venta> lista = new java.util.ArrayList<>();
        String sql = "SELECT TOP (?) v.id_venta, v.tipo_comprobante, v.numero_comprobante, "
                + "       v.fecha_venta, v.subtotal, v.igv, v.total, v.metodo_pago, "
                + "       c.nombres_rsocial, c.dni_ruc, u.nombres_completos AS cajero "
                + "FROM Ventas v "
                + "INNER JOIN Clientes c ON v.id_cliente = c.id_cliente "
                + "INNER JOIN Usuarios u ON v.id_usuario = u.id_usuario "
                + "WHERE v.estado = 1 "
                + "ORDER BY v.fecha_venta DESC";

        try (Connection con = ConexionDB.getConexion(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limite);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Venta v = new Venta();
                    v.setIdVenta(rs.getInt("id_venta"));
                    v.setTipoComprobante(rs.getString("tipo_comprobante"));
                    v.setNumeroComprobante(rs.getString("numero_comprobante"));
                    java.sql.Timestamp ts = rs.getTimestamp("fecha_venta");
                    if (ts != null) {
                        v.setFechaVenta(ts.toLocalDateTime());
                    }
                    v.setSubtotal(rs.getDouble("subtotal"));
                    v.setIgv(rs.getDouble("igv"));
                    v.setTotal(rs.getDouble("total"));
                    v.setMetodoPago(rs.getString("metodo_pago"));
                    v.setNombreCliente(rs.getString("nombres_rsocial"));
                    v.setDocumentoCliente(rs.getString("dni_ruc"));
                    v.setNombreCajero(rs.getString("cajero"));
                    lista.add(v);
                }
            }
        } catch (Exception e) {
            System.err.println("Error al listar últimas ventas: " + e.getMessage());
        }
        return lista;
    }

    public String[] obtenerDatosGrafico7Dias() {
        java.util.Map<java.time.LocalDate, Double> mapaVentas = new java.util.LinkedHashMap<>();
        java.time.LocalDate hoy = java.time.LocalDate.now();

        for (int i = 6; i >= 0; i--) {
            mapaVentas.put(hoy.minusDays(i), 0.0);
        }

        String sql = "SELECT CAST(fecha_venta AS DATE) AS fecha, SUM(total) AS total_dia "
                + "FROM Ventas "
                + "WHERE fecha_venta >= DATEADD(DAY, -6, CAST(GETDATE() AS DATE)) AND estado = 1 "
                + "GROUP BY CAST(fecha_venta AS DATE)";

        try (Connection con = ConexionDB.getConexion(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                java.sql.Date fechaSql = rs.getDate("fecha");
                if (fechaSql != null) {
                    java.time.LocalDate fecha = fechaSql.toLocalDate();
                    if (mapaVentas.containsKey(fecha)) {
                        mapaVentas.put(fecha, rs.getDouble("total_dia"));
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("Error al obtener gráfico de 7 días: " + e.getMessage());
        }

        StringBuilder sbLabels = new StringBuilder("[");
        StringBuilder sbData = new StringBuilder("[");
        java.time.format.DateTimeFormatter fmt = java.time.format.DateTimeFormatter.ofPattern("dd/MM");

        int index = 0;
        for (java.util.Map.Entry<java.time.LocalDate, Double> entry : mapaVentas.entrySet()) {
            if (index > 0) {
                sbLabels.append(", ");
                sbData.append(", ");
            }
            sbLabels.append("'").append(entry.getKey().format(fmt)).append("'");
            sbData.append(String.format(java.util.Locale.US, "%.2f", entry.getValue()));
            index++;
        }
        sbLabels.append("]");
        sbData.append("]");

        return new String[]{sbLabels.toString(), sbData.toString()};
    }
}
