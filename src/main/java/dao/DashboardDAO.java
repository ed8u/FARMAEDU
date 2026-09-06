package dao;

import config.ConexionDB;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DashboardDAO {

    // 1. Obtener el total de dinero ingresado HOY
    public double getIngresosHoy() {
        double total = 0;
        String sql = "SELECT SUM(total) AS ingresos FROM Ventas WHERE CAST(fecha_venta AS DATE) = CAST(GETDATE() AS DATE)";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                total = rs.getDouble("ingresos");
            }
        } catch (Exception e) {
            System.out.println("Error Ingresos Hoy: " + e.getMessage());
        }
        return total;
    }

    // 2. Obtener la cantidad de ventas (boletas/facturas) emitidas HOY
    public int getCantidadVentasHoy() {
        int cantidad = 0;
        String sql = "SELECT COUNT(*) AS cantidad FROM Ventas WHERE CAST(fecha_venta AS DATE) = CAST(GETDATE() AS DATE)";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                cantidad = rs.getInt("cantidad");
            }
        } catch (Exception e) {
            System.out.println("Error Cantidad Ventas: " + e.getMessage());
        }
        return cantidad;
    }

    // 3. Obtener el total de clientes registrados
    public int getTotalClientes() {
        int total = 0;
        String sql = "SELECT COUNT(*) AS total FROM Clientes";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (Exception e) {
            System.out.println("Error Total Clientes: " + e.getMessage());
        }
        return total;
    }

    // 4. Alertas: Lotes con stock crítico (<=10) o por vencer en los próximos 90 días
    public int getAlertasSanitarias() {
        int alertas = 0;
        String sql = "SELECT COUNT(*) AS alertas FROM Lotes WHERE stock_actual <= 10 OR fecha_vencimiento <= DATEADD(day, 90, GETDATE())";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                alertas = rs.getInt("alertas");
            }
        } catch (Exception e) {
            System.out.println("Error Alertas: " + e.getMessage());
        }
        return alertas;
    }
}